resource "kubernetes_manifest" "traefik_middleware_rate_limit" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "rate-limit"
      namespace = kubernetes_namespace.backstage.metadata[0].name
      labels    = local.default_labels
    }
    spec = {
      rateLimit = {
        average = 10
        burst   = 100
        period  = "1s"
      }
    }
  }
}

resource "kubernetes_manifest" "traefik_middleware_http_https" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "redirect-http-to-https"
      namespace = kubernetes_namespace.backstage.metadata[0].name
      labels    = local.default_labels
    }
    spec = {
      redirectScheme = {
        scheme    = "https"
        permanent = true
      }
    }
  }
}

resource "kubernetes_secret" "traefik_middleware_basic_auth" {
  metadata {
    name      = "basic-auth-users"
    namespace = kubernetes_namespace.backstage.metadata[0].name
    labels    = local.default_labels
  }

  data = {
    users = ""
  }

  lifecycle {
    ignore_changes = [data]
  }
}

resource "kubernetes_manifest" "traefik_middleware_basic_auth" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"
    metadata = {
      namespace = kubernetes_namespace.backstage.metadata[0].name
      name      = "basic-auth"
      labels    = local.default_labels
    }
    spec = {
      basicAuth = {
        secret       = kubernetes_secret.traefik_middleware_basic_auth.metadata[0].name
        removeHeader = true
      }
    }
  }
}

resource "kubernetes_manifest" "traefik_middleware_ip_allowlist_internal" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"
    metadata = {
      namespace = kubernetes_namespace.backstage.metadata[0].name
      name      = "ip-allowlist-internal"
      labels    = local.default_labels
    }
    spec = {
      ipWhiteList = {
        sourceRange = [
          "172.20.0.0/16",
        ]
      }
    }
  }
}
