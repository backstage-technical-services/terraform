locals {
  oidc_provider_url = "https://token.actions.githubusercontent.com"

  github_org = "backstage-technical-services"
  conditions = flatten([
    for repo in var.repositories : concat(
      var.allow_pull_requests ? ["${repo}:pull_request"] : [],
      [for branch in var.allowed_branches : "${repo}:ref:refs/heads/${branch}"],
      [for env in var.allowed_environments : "${repo}:environment:${env}"],
    )
  ])
}

data "aws_iam_openid_connect_provider" "github" {
  url = local.oidc_provider_url
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for condition in local.conditions : "repo:${local.github_org}/${condition}"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = "backstage-oidc-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.default.id
  policy_arn = each.key
}

resource "aws_iam_role_policy" "default" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.default.id
  policy = each.value
}
