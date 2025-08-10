locals {
  component = "${var.engine}-${replace(var.engine_version, ".", "-")}"

  selector_labels = {
    "backstage.uk/component" = "database"
    "backstage.uk/engine"    = var.engine
    "backstage.uk/version"   = var.engine_version
  }
  labels = merge(var.default_labels, local.selector_labels, {
    "app.kubernetes.io/name" = "database-${local.component}"
  })
}

resource "kubernetes_service_v1" "default" {
  metadata {
    namespace = "backstage"
    name      = local.component
    labels    = local.labels
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
    namespace = "backstage"
    name      = "database-${local.component}"
    labels    = local.labels
  }

  spec {
    service_name = kubernetes_service_v1.default.metadata[0].name
    replicas     = 1

    selector {
      match_labels = local.selector_labels
    }

    template {
      metadata {
        namespace = "backstage"
        name      = "database-${local.component}"
        labels    = local.labels
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

          dynamic "resources" {
            for_each = var.resources != null ? [1] : []

            content {
              requests = var.resources.requests
              limits   = var.resources.limits
            }
          }
        }

        volume {
          name = "data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.data.metadata[0].name
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
