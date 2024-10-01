
module "keycloak" {
  source = "./keycloak"

  ssm_prefix = "/backstage/keycloak"
}

import {
  id = "/backstage/keycloak/db-credentials"
  to = module.keycloak.aws_ssm_parameter.db_credentials
}
