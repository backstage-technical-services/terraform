module "oidc_terraform_apply" {
  source = "./oidc-role"

  name         = "terraform-apply"
  repositories = ["terraform"]

  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  inline_policies = {
    "plan-outputs" = data.aws_iam_policy_document.terraform_apply_plan_outputs.json
  }

  allowed_branches    = ["main"]
  allow_pull_requests = true
}

data "aws_iam_policy_document" "terraform_apply_plan_outputs" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.plan_outputs.arn}/*"]
  }
}
