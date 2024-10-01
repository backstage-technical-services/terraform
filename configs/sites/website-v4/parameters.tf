resource "aws_ssm_parameter" "app_key" {
  name  = "${var.ssm_prefix}/app-key"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "bugsnag_api_key" {
  name  = "${var.ssm_prefix}/bugsnag-api-key"
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

resource "aws_ssm_parameter" "log_level" {
  name  = "${var.ssm_prefix}/log-level"
  type  = "String"
  value = "info"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "nocaptcha_config" {
  name = "${var.ssm_prefix}/nocaptcha-config"
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

resource "aws_ssm_parameter" "youtube_api_key" {
  name  = "${var.ssm_prefix}/youtube-api-key"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "finance_db_key" {
  name  = "${var.ssm_prefix}/finance-db-key"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "backup_webhook" {
  name  = "${var.ssm_prefix}/backup-webhook"
  type  = "SecureString"
  value = "empty"

  lifecycle {
    ignore_changes = [value]
  }
}
