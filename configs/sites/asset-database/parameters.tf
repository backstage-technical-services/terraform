resource "aws_ssm_parameter" "secret_key" {
  name  = "${var.ssm_prefix}/secret-key"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_credentials" {
  name = "${var.ssm_prefix}/db-credentials"
  type = "SecureString"
  value = jsonencode({
    username = ""
    password = ""
  })

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "smtp_credentials" {
  name = "${var.ssm_prefix}/smtp-credentials"
  type = "SecureString"
  value = jsonencode({
    username = ""
    password = ""
  })

  lifecycle {
    ignore_changes = [value]
  }
}
