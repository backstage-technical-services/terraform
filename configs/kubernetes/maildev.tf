locals {
  maildev_selector_labels = {
    "backstage.uk/component" = "maildev"
  }
  maildev_labels = merge(local.default_labels, {
    "bnjns.uk/app"           = "maildev"
    "app.kubernetes.io/name" = "maildev"
  }, local.maildev_selector_labels)

  maildev_smtp_port = 1025
  maildev_web_port  = 1080
}

resource "kubernetes_service_v1" "maildev" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "maildev"
    labels    = local.maildev_labels
  }

  spec {
    type     = "ClusterIP"
    selector = local.maildev_selector_labels

    port {
      name = "smtp"
      port = local.maildev_smtp_port
    }

    port {
      name = "web"
      port = local.maildev_web_port
    }
  }
}

resource "kubernetes_stateful_set_v1" "maildev" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "maildev"
    labels    = local.maildev_labels
  }

  spec {
    service_name = kubernetes_service_v1.maildev.metadata[0].name
    replicas     = 1

    selector {
      match_labels = local.maildev_selector_labels
    }

    template {
      metadata {
        namespace = kubernetes_namespace.backstage.metadata[0].name
        name      = "maildev"
        labels    = local.maildev_labels
      }

      spec {
        container {
          name              = "maildev"
          image             = "maildev/maildev:2.2.1"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "MAILDEV_SMTP_PORT"
            value = tostring(local.maildev_smtp_port)
          }

          env {
            name  = "MAILDEV_WEB_PORT"
            value = tostring(local.maildev_web_port)
          }

          resources {
            requests = {
              memory = "100Mi"
            }
            limits = {
              memory = "100Mi"
            }
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
