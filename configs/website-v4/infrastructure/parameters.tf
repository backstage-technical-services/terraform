locals {
  ssm_prefix = "/${var.meta.owner}/${var.meta.environment}/${var.meta.component}"
}

resource "aws_ssm_parameter" "app_key" {
  name  = "${local.ssm_prefix}/app-key"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "bugsnag_api_key" {
  name  = "${local.ssm_prefix}/bugsnag-api-key"
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

resource "aws_ssm_parameter" "log_level" {
  name  = "${local.ssm_prefix}/log-level"
  type  = "String"
  value = "info"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "nocaptcha_config" {
  name = "${local.ssm_prefix}/nocaptcha-config"
  type = "SecureString"
  value = jsonencode({
    siteKey = ""
    secret  = ""
  })

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "smtp_credentials" {
  name = "${local.ssm_prefix}/smtp-credentials"
  type = "SecureString"
  value = jsonencode({
    username = ""
    password = ""
  })

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "youtube_api_key" {
  name  = "${local.ssm_prefix}/youtube-api-key"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}
