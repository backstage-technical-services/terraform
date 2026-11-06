locals {
  all_parameters = merge(aws_ssm_parameter.managed, aws_ssm_parameter.unmanaged)
}

output "arns" {
  value = { for key, param in local.all_parameters : key => param.arn }
}

output "names" {
  value = { for key, param in local.all_parameters : key => param.name }
}
