########################################################################################################################
# backstage:admin
########################################################################################################################
resource "kubernetes_role_v1" "backstage_admin" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "backstage:admin"
    labels    = local.default_labels
  }

  rule {
    api_groups = [""]
    verbs      = ["*"]
    resources  = ["*"]
  }
}
resource "kubernetes_role_binding_v1" "backstage_admin" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "backstage:admin"
    labels    = local.default_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.backstage_admin.metadata[0].name
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "backstage:admin"
  }
}

########################################################################################################################
# backstage:dev
########################################################################################################################
resource "kubernetes_role_v1" "backstage_dev" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "backstage:dev"
    labels    = local.default_labels
  }

  rule {
    api_groups = [""]
    verbs      = ["get", "list", "watch"]
    resources  = ["*"]
  }

  rule {
    api_groups = [""]
    verbs      = ["delete"]
    resources  = ["pods"]
  }
}
resource "kubernetes_role_binding_v1" "backstage_dev" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "backstage:dev"
    labels    = local.default_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.backstage_dev.metadata[0].name
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "backstage:dev"
  }
}
