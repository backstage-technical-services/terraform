resource "random_password" "admin_password" {
  special = false
  length  = 30
}

resource "aws_ssm_parameter" "admin_password" {
  name  = "/backstage/openldap/admin-password"
  type  = "SecureString"
  value = random_password.admin_password.result
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
            key = aws_ssm_parameter.admin_password.name
          }
        },
      ]
    }
  }
}
