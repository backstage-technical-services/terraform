module "oidc_docker_image" {
  source = "./oidc-role"

  name = "docker-image"
  repositories = [
    "asset-database",
    "keycloak",
    "website",
  ]

  inline_policies = {
    "docker-image" = data.aws_iam_policy_document.docker_image.json
  }

  allow_pull_requests = true
  allowed_branches    = ["main"]
}

data "aws_iam_policy_document" "docker_image" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:BatchGetImage",
    ]
    resources = [
      "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/backstage-*"
    ]
  }
}
