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
      port = var.port
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
            for_each = var.env

            content {
              name  = env.key
              value = env.value
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_manifest.external_secrets.manifest.metadata.name
            }
          }

          volume_mount {
            name       = "data"
            mount_path = var.data_dir
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
