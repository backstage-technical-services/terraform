module "oidc_terraform_plan" {
  source = "./oidc-role"

  name         = "terraform-plan"
  repositories = ["terraform"]

  policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  allow_pull_requests = true
}
