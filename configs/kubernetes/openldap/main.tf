locals {
  selector_labels = {
    "backstage.uk/component" = "openldap"
  }
  labels = merge(var.labels, local.selector_labels, {
    "app.kubernetes.io/name" = "openldap"
  })
}

resource "kubernetes_service_v1" "default" {
  metadata {
    namespace = var.namespace
    name      = "openldap"
    labels    = local.labels
    annotations = {
      "tailscale.com/expose"      = "true"
      "tailscale.com/proxy-class" = "backstage"
    }
  }

  spec {
    type     = "ClusterIP"
    selector = local.selector_labels

    port {
      port = 1389
    }
  }
}

resource "kubernetes_stateful_set_v1" "default" {
  metadata {
    namespace = var.namespace
    name      = "openldap"
    labels    = local.labels
  }

  spec {
    service_name = kubernetes_service_v1.default.metadata[0].name
    replicas     = 1

    selector {
      match_labels = local.selector_labels
    }

    template {
      metadata {
        namespace = var.namespace
        name      = "openldap"
        labels    = local.labels
      }

      spec {
        container {
          name              = "openldap"
          image             = "bitnami/openldap:2.6.10"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "LDAP_ADMIN_USERNAME"
            value = "admin"
          }

          env {
            name  = "LDAP_ROOT"
            value = "dc=ldap,dc=bts-crew,dc=com"
          }

          env {
            name  = "LDAP_ADMIN_DN"
            value = "cn=admin,dc=ldap,dc=bts-crew,dc=com"
          }

          env {
            name  = "LDAP_USER_OU"
            value = "users"
          }

          env {
            name  = "LDAP_GROUP_OU"
            value = "groups"
          }

          env_from {
            secret_ref {
              name = kubernetes_manifest.external_secrets.manifest.metadata.name
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/bitnami/openldap"
          }
        }

        volume {
          name = "data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.data.metadata[0].name
          }
        }

        node_selector = {
          "bnjns.uk/owner" = "backstage"
        }

        toleration {
          key      = "bnjns.uk/reserved-for"
          operator = "Equal"
          value    = "backstage"
          effect   = "NoSchedule"
        }
      }
    }
  }

  depends_on = [
    kubernetes_manifest.external_secrets,
  ]
}
