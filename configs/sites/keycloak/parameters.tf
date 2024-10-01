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

resource "random_pet" "admin_username" {
  length = 3
}
resource "random_password" "admin_password" {
  length = 25
}
resource "aws_ssm_parameter" "admin_credentials" {
  name = "${var.ssm_prefix}/admin-credentials"
  type = "SecureString"
  value = jsonencode({
    username = random_pet.admin_username.id
    password = random_password.admin_password.result
  })
}
