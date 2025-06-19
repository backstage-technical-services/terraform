resource "kubernetes_secret" "traefik_middleware_staging_basic_auth" {
  metadata {
    name        = "staging-basic-auth-users"
    namespace   = kubernetes_namespace.backstage.metadata[0].name
    annotations = local.default_annotations
  }

  data = {
    users = ""
  }

  lifecycle {
    ignore_changes = [data]
  }
}

resource "kubernetes_manifest" "traefik_middleware_staging_basic_auth" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"
    metadata = {
      namespace   = kubernetes_namespace.backstage.metadata[0].name
      name        = "staging-basic-auth"
      annotations = local.default_annotations
    }
    spec = {
      basicAuth = {
        secret       = kubernetes_secret.traefik_middleware_staging_basic_auth.metadata[0].name
        removeHeader = true
      }
    }
  }
}
