locals {
  ssm_prefix = "/${var.meta.owner}/${var.meta.environment}/${var.meta.component}"
}

resource "aws_ssm_parameter" "secret_key" {
  name  = "${local.ssm_prefix}/secret-key"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_credentials" {
  name = "${local.ssm_prefix}/db-credentials"
  type = "SecureString"
  value = jsonencode({
    username = ""
    password = ""
  })

  lifecycle {
    ignore_changes = [value]
  }
}
