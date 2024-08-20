resource "kubernetes_service_account_v1" "github_actions" {
  metadata {
    namespace   = "backstage"
    name        = "github-actions"
    annotations = local.default_annotations
  }
}

resource "kubernetes_secret_v1" "github_actions_token" {
  type = "kubernetes.io/service-account-token"

  metadata {
    namespace = "backstage"
    name      = "github-actions-service-account-token"
    annotations = merge(local.default_annotations, {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.github_actions.metadata[0].name
    })
  }
}

########################################################################################################################
# cluster-wide
########################################################################################################################
resource "kubernetes_cluster_role_v1" "github_actions" {
  metadata {
    name        = "backstage:github-actions"
    annotations = local.default_annotations
  }

  rule {
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
    verbs      = ["create", "get"]
  }
}
resource "kubernetes_cluster_role_binding_v1" "github_actions" {
  metadata {
    name        = "backstage:github-actions"
    annotations = local.default_annotations
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.github_actions.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    namespace = "backstage"
    name      = kubernetes_service_account_v1.github_actions.metadata[0].name
  }
}

########################################################################################################################
# namespaced
########################################################################################################################
resource "kubernetes_role_v1" "github_actions" {
  metadata {
    namespace   = "backstage"
    name        = "backstage:github-actions"
    annotations = local.default_annotations
  }

  rule {
    api_groups = [
      "",
      "apps",
      "networking.k8s.io",
    ]
    resources = [
      "deployments",
      "replicasets",
      "statefulsets",
      "ingresses",
      "services",
      "secrets"
    ]
    verbs = ["*"]
  }
}

resource "kubernetes_role_binding_v1" "github_actions" {
  metadata {
    namespace   = "backstage"
    name        = "backstage:github-actions"
    annotations = local.default_annotations
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.github_actions.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    namespace = "backstage"
    name      = kubernetes_service_account_v1.github_actions.metadata[0].name
  }
}
