data "aws_ssm_parameter" "openldap_secrets" {
  name = var.openldap_secrets_parameter
}

resource "aws_ssm_parameter" "app_key" {
  name  = "/backstage/phpldapadmin/app-key"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "kubernetes_manifest" "external_secrets" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"
    metadata = {
      namespace = var.namespace
      name      = "phpldapadmin"
      labels    = local.labels
    }
    spec = {
      secretStoreRef = {
        kind = "ClusterSecretStore"
        name = "aws-ssm"
      }
      data = [
        {
          secretKey = "APP_KEY"
          remoteRef = {
            key = aws_ssm_parameter.app_key.name
          }
        },
        {
          secretKey = "LDAP_PASSWORD"
          remoteRef = {
            key      = data.aws_ssm_parameter.openldap_secrets.name
            property = "adminPassword"
          }
        },
      ]
    }
  }
}
