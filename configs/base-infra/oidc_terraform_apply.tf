module "oidc_terraform_apply" {
  source = "./oidc-role"

  name         = "terraform-apply"
  repositories = ["terraform"]

  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  allowed_branches = ["main"]
}
