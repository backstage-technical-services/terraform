data "aws_iam_role" "external_secrets" {
  name = "backstage-k3s-external-secrets"
}

resource "kubernetes_manifest" "external_secrets_aws_ssm" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "SecretStore"
    metadata = {
      namespace   = "backstage"
      name        = "aws-ssm"
      annotations = local.default_annotations
    }
    spec = {
      provider = {
        aws = {
          service = "ParameterStore"
          region  = "eu-west-1"
          role    = data.aws_iam_role.external_secrets.arn
        }
      }
    }
  }
}
