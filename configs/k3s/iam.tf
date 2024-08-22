// For now, just use the same IAM role as the master node
data "aws_iam_instance_profile" "master_node" {
  name = "bnjns-k3s"
}

########################################################################################################################
# external-secrets
########################################################################################################################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_policy_document" "node_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_instance_profile.master_node.role_arn]
    }
  }
}
resource "aws_iam_role" "external_secrets" {
  name               = "backstage-k3s-external-secrets"
  assume_role_policy = data.aws_iam_policy_document.node_assume.json
}

data "aws_iam_policy_document" "external_secrets" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/backstage/*"]
  }
}
resource "aws_iam_role_policy" "external_secrets" {
  name   = "ssm-read"
  role   = aws_iam_role.external_secrets.id
  policy = data.aws_iam_policy_document.external_secrets.json
}
