locals {
  component = "${var.engine}-${replace(var.engine_version, ".", "-")}"

  selector_labels = {
    "backstage.uk/component" = "database"
    "backstage.uk/engine"    = var.engine
    "backstage.uk/version"   = var.engine_version
  }
  labels = merge(local.selector_labels, {
    "app.kubernetes.io/name" = "database-${local.component}"
  })

  config = local.engine_config[var.engine]
}

resource "random_password" "root_password" {
  length  = 20
  special = false
}


resource "aws_ssm_parameter" "root_password" {
  name  = "/backstage/database/${local.component}/root-password"
  type  = "SecureString"
  value = random_password.root_password.result
}

resource "kubernetes_service_v1" "default" {
  metadata {
    namespace   = "backstage"
    name        = local.component
    annotations = var.default_annotations
    labels      = local.labels
  }

  spec {
    type     = "ClusterIP"
    selector = local.selector_labels

    port {
      port = local.config.port
    }
  }
}

resource "kubernetes_manifest" "default" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = {
      namespace   = "backstage"
      name        = "database-${local.component}-credentials"
      annotations = var.default_annotations
      labels      = local.labels
    }
    spec = {
      secretStoreRef = {
        kind = "SecretStore"
        name = "aws-ssm"
      }
      data = [
        {
          secretKey = local.config.root_password_variable_name
          remoteRef = {
            key = aws_ssm_parameter.root_password.name
          }
        }
      ]
    }
  }
}

resource "kubernetes_stateful_set_v1" "default" {
  metadata {
    namespace   = "backstage"
    name        = "database-${local.component}"
    annotations = var.default_annotations
    labels      = local.labels
  }

  spec {
    service_name = kubernetes_service_v1.default.metadata[0].name
    replicas     = 1

    selector {
      match_labels = local.selector_labels
    }

    template {
      metadata {
        namespace   = "backstage"
        name        = "database-${local.component}"
        annotations = var.default_annotations
        labels      = local.labels
      }

      spec {
        container {
          name              = var.engine
          image             = "${var.engine}:${var.engine_version}"
          image_pull_policy = "IfNotPresent"

          dynamic "env" {
            for_each = local.config.env_variables

            content {
              name  = env.key
              value = env.value
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_manifest.default.manifest.metadata.name
            }
          }

          volume_mount {
            name       = "data"
            mount_path = local.config.data_dir
          }
        }

        volume {
          name = "data"

          host_path {
            path = "/opt/data/backstage/database/${local.component}"
          }
        }

        node_selector = {
          "bnjns.uk/owner" = "backstage"
        }

        toleration {
          key      = "bnjns.uk/reserved-for"
          operator = "Equal"
          value    = "backstage"
          effect   = "NoSchedule"
        }
      }
    }
  }
}
