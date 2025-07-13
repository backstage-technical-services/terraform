resource "aws_ssm_parameter" "default" {
  name  = "/backstage/database/${local.component}"
  type  = "SecureString"
  value = jsonencode(var.secrets)
}

resource "kubernetes_manifest" "external_secrets" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"
    metadata = {
      namespace = "backstage"
      name      = "database-${local.component}"
      labels    = local.labels
    }
    spec = {
      secretStoreRef = {
        kind = "ClusterSecretStore"
        name = "aws-ssm"
      }
      data = [for k, v in var.secrets :
        {
          secretKey = k
          remoteRef = {
            key      = aws_ssm_parameter.default.name
            property = k
          }
        }
      ]
    }
  }
}
