module "oidc_terraform_plan" {
  source = "./oidc-role"

  name         = "terraform-plan"
  repositories = ["terraform", "keycloak"]

  policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  inline_policies = {
    "plan-outputs" = data.aws_iam_policy_document.plan_write_outputs.json
  }

  allow_pull_requests = true
}

data "aws_iam_policy_document" "plan_write_outputs" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject*"]
    resources = ["${aws_s3_bucket.plan_outputs.arn}/*"]
  }
}
