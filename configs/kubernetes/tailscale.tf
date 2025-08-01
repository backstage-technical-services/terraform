data "aws_ssm_parameter" "tailscale_auth" {
  name = "/backstage/tailscale-auth"
}

resource "helm_release" "tailscale" {
  name      = "tailscale-operator"
  namespace = kubernetes_namespace_v1.backstage_tailscale.metadata[0].name

  repository = "https://pkgs.tailscale.com/helmcharts"
  chart      = "tailscale-operator"
  version    = "1.86.2"

  create_namespace = false
  wait             = true
  wait_for_jobs    = true

  values = [
    <<EOT
operatorConfig:
  nodeSelector:
    bnjns.uk/owner: 'backstage'
  tolerations:
    - key: 'bnjns.uk/reserved-for'
      operator: 'Equal'
      value: 'backstage'
      effect: 'NoSchedule'
EOT
  ]

  set_sensitive = [
    {
      name  = "oauth.clientId"
      value = jsondecode(data.aws_ssm_parameter.tailscale_auth.value)["oauthClientId"]
    },
    {
      name  = "oauth.clientSecret"
      value = jsondecode(data.aws_ssm_parameter.tailscale_auth.value)["oauthClientSecret"]
    }
  ]
}

resource "kubernetes_manifest" "tailscale_proxy_class" {
  manifest = {
    apiVersion = "tailscale.com/v1alpha1"
    kind       = "ProxyClass"
    metadata = {
      name = "backstage"
    }
    spec = {
      statefulSet = {
        pod = {
          labels = local.default_labels
          nodeSelector = {
            "bnjns.uk/owner" = "backstage"
          }
          tolerations = [
            {
              key      = "bnjns.uk/reserved-for"
              operator = "Equal"
              value    = "backstage"
              effect   = "NoSchedule"
            }
          ]
        }
      }
    }
  }

  depends_on = [
    helm_release.tailscale,
  ]
}

resource "kubernetes_manifest" "tailscale_proxy_class_egress" {
  manifest = {
    apiVersion = "tailscale.com/v1alpha1"
    kind       = "ProxyClass"
    metadata = {
      name = "backstage-onprem"
    }
    spec = {
      statefulSet = {
        pod = {
          labels = local.default_labels
          nodeSelector = {
            "bnjns.uk/owner" = "backstage"
          }
          tolerations = [
            {
              key      = "bnjns.uk/reserved-for"
              operator = "Equal"
              value    = "backstage"
              effect   = "NoSchedule"
            }
          ]
        }
      }
      tailscale = {
        acceptRoutes = true
      }
    }
  }

  depends_on = [
    helm_release.tailscale,
  ]
}
