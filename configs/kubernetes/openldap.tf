module "openldap" {
  source = "./openldap"

  namespace = kubernetes_namespace.backstage.metadata[0].name
  labels    = local.default_labels
}
