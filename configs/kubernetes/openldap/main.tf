locals {
  selector_labels = {
    "backstage.uk/component" = "openldap"
  }
  labels = merge(var.labels, local.selector_labels, {
    "app.kubernetes.io/name" = "openldap"
  })

  root_dn = "dc=ldap,dc=bts-crew,dc=com"
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
          image             = "bitnamilegacy/openldap:2.6.10"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "LDAP_CONFIG_ADMIN_ENABLED"
            value = "yes"
          }

          env {
            name  = "LDAP_CONFIG_ADMIN_USERNAME"
            value = "admin"
          }

          env {
            name  = "LDAP_ADMIN_USERNAME"
            value = "admin"
          }

          env {
            name  = "LDAP_ROOT"
            value = local.root_dn
          }

          env {
            name  = "LDAP_ADMIN_DN"
            value = "cn=admin,${local.root_dn}"
          }

          env {
            name  = "LDAP_SKIP_DEFAULT_TREE"
            value = "yes"
          }

          env {
            name  = "LDAP_CUSTOM_LDIF_DIR"
            value = "/ldifs/bootstrap"
          }

          env {
            name  = "LDAP_CONFIGURE_PPOLICY"
            value = "yes"
          }

          env {
            name  = "LDAP_PPOLICY_HASH_CLEARTEXT"
            value = "yes"
          }

          env_from {
            secret_ref {
              name = kubernetes_manifest.external_secrets.manifest.metadata.name
            }
          }

          resources {
            requests = {
              memory = "128Mi"
            }
            limits = {
              memory = "265Mi"
            }
          }

          volume_mount {
            name       = "ldifs-bootstrap"
            mount_path = "/ldifs/bootstrap"
          }

          volume_mount {
            name       = "ldifs-misc"
            mount_path = "/ldifs/misc"
          }

          volume_mount {
            name       = "data"
            mount_path = "/bitnami/openldap"
          }
        }

        volume {
          name = "ldifs-bootstrap"

          config_map {
            name = kubernetes_config_map_v1.ldifs_bootstrap.metadata[0].name
          }
        }

        volume {
          name = "ldifs-misc"

          config_map {
            name = kubernetes_config_map_v1.ldifs_misc.metadata[0].name
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
    kubernetes_config_map_v1.ldifs_bootstrap,
    kubernetes_config_map_v1.ldifs_misc,
    kubernetes_manifest.external_secrets,
  ]
}
