module "openldap" {
  source = "./openldap"

  namespace = kubernetes_namespace.backstage.metadata[0].name
  labels    = local.default_labels
}

module "phpldapadmin" {
  source = "./phpldapadmin"

  namespace = kubernetes_namespace.backstage.metadata[0].name
  labels    = local.default_labels

  openldap_secrets_parameter = module.openldap.secrets_parameter_name

  depends_on = [
    module.openldap,
  ]
}
