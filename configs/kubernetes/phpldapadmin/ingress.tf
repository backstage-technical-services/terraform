resource "kubernetes_service_v1" "main" {
  metadata {
    namespace = var.namespace
    name      = "phpldapadmin"
    labels    = local.labels
    annotations = {
      "tailscale.com/expose"      = "true"
      "tailscale.com/proxy-class" = "backstage"
    }
  }

  spec {
    type     = "ClusterIP"
    selector = local.selector_labels

    port {
      port = 8080
    }
  }
}
