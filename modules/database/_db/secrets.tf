resource "aws_ssm_parameter" "default" {
  name  = "/backstage/database/${local.component}"
  type  = "SecureString"
  value = jsonencode(var.secrets)
}

resource "kubernetes_manifest" "external_secrets" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = {
      namespace   = "backstage"
      name        = "database-${local.component}"
      annotations = var.default_annotations
      labels      = local.labels
    }
    spec = {
      secretStoreRef = {
        kind = "SecretStore"
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
