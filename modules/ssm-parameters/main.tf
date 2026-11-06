locals {
  prefix = format("/%s", join("/", compact(["backstage", var.meta.environment, var.meta.component])))
}

resource "aws_ssm_parameter" "managed" {
  for_each = { for param in var.parameters : lower(param.name) => param if param.value != null }

  name  = "${local.prefix}/${each.key}"
  type  = each.value.sensitive ? "SecureString" : "String"
  value = each.value.value
  tags  = var.tags
}

resource "aws_ssm_parameter" "unmanaged" {
  for_each = { for param in var.parameters : lower(param.name) => param if param.value == null }

  name  = "${local.prefix}/${each.key}"
  type  = each.value.sensitive ? "SecureString" : "String"
  value = each.value.initial_value
  tags  = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}
