########################################################################################################################
# Terraform
########################################################################################################################
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}

rule "terraform_naming_convention" {
  enabled = true

  format = "snake_case"
  custom_formats = {
    module = {
      description = "^_?[a-z]+(_[a-z]+)*$"
      regex = "^_?[a-z]+(_[a-z]+)*$"
    }
    block = {
      description = "^[a-z][a-z0-9]*(_[a-zA-Z][a-zA-Z0-9]*)*$"
      regex = "^[a-z][a-z0-9]*(_[a-zA-Z][a-zA-Z0-9]*)*$"
    }
  }

  resource {
    format = "block"
  }

  data {
    format = "block"
  }

  module {
    format = "module"
  }
}

########################################################################################################################
# AWS
########################################################################################################################
plugin "aws" {
  enabled = true
  version = "0.30.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
