resource "kubernetes_service_account_v1" "github_actions" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "github-actions"
    labels    = local.default_labels
  }
}

resource "kubernetes_secret_v1" "github_actions_token" {
  type = "kubernetes.io/service-account-token"

  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "github-actions-service-account-token"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.github_actions.metadata[0].name
    }
    labels = local.default_labels
  }
}

########################################################################################################################
# cluster-wide
########################################################################################################################
resource "kubernetes_cluster_role_v1" "github_actions" {
  metadata {
    name   = "backstage:github-actions"
    labels = local.default_labels
  }

  rule {
    api_groups = [""]
    resources = [
      "persistentvolumes",
      "persistentvolumeclaims",
    ]
    verbs = ["*"]
  }

  rule {
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
    verbs      = ["create", "get"]
  }
}
resource "kubernetes_cluster_role_binding_v1" "github_actions" {
  metadata {
    name   = "backstage:github-actions"
    labels = local.default_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.github_actions.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = kubernetes_service_account_v1.github_actions.metadata[0].name
  }
}

########################################################################################################################
# namespaced
########################################################################################################################
resource "kubernetes_role_v1" "github_actions" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "backstage:github-actions"
    labels    = local.default_labels
  }

  rule {
    api_groups = [""]
    resources = [
      "services",
      "secrets",
      "configmaps",
    ]
    verbs = ["*"]
  }

  rule {
    api_groups = ["apps"]
    resources = [
      "deployments",
      "replicasets",
      "statefulsets",
    ]
    verbs = ["*"]
  }

  rule {
    api_groups = ["batch"]
    resources = [
      "cronjobs",
    ]
    verbs = ["*"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources = [
      "ingresses",
    ]
    verbs = ["*"]
  }

  rule {
    api_groups = ["external-secrets.io"]
    resources  = ["externalsecrets"]
    verbs      = ["*"]
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates"]
    verbs      = ["*"]
  }

  rule {
    api_groups = ["traefik.io"]
    resources  = ["ingressroutes"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding_v1" "github_actions" {
  metadata {
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = "backstage:github-actions"
    labels    = local.default_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.github_actions.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    namespace = kubernetes_namespace.backstage.metadata[0].name
    name      = kubernetes_service_account_v1.github_actions.metadata[0].name
  }
}
