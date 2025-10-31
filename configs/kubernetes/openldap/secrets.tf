resource "random_password" "admin_password" {
  special = false
  length  = 30
}

resource "random_password" "config_password" {
  special = false
  length  = 30
}

resource "aws_ssm_parameter" "secrets" {
  name = "/backstage/openldap/secrets"
  type = "SecureString"
  value = jsonencode({
    adminPassword  = random_password.admin_password.result
    configPassword = random_password.config_password.result
  })
}

resource "kubernetes_manifest" "external_secrets" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"
    metadata = {
      namespace = var.namespace
      name      = "openldap"
      labels    = local.labels
    }
    spec = {
      secretStoreRef = {
        kind = "ClusterSecretStore"
        name = "aws-ssm"
      }
      data = [
        {
          secretKey = "LDAP_ADMIN_PASSWORD"
          remoteRef = {
            key      = aws_ssm_parameter.secrets.name
            property = "adminPassword"
          }
        },
        {
          secretKey = "LDAP_CONFIG_ADMIN_PASSWORD"
          remoteRef = {
            key      = aws_ssm_parameter.secrets.name
            property = "configPassword"
          }
        }
      ]
    }
  }
}
