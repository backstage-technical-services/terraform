locals {
  selector_labels = {
    "backstage.uk/component" = "phpldapadmin"
  }
  labels = merge(var.labels, local.selector_labels, {
    "app.kubernetes.io/name" = "phpldapadmin"
  })
}

resource "kubernetes_deployment_v1" "main" {
  metadata {
    namespace = var.namespace
    name      = "phpldapadmin"
    labels    = local.labels
  }

  spec {
    selector {
      match_labels = local.selector_labels
    }

    template {
      metadata {
        name   = "phpldapadmin"
        labels = local.selector_labels
      }

      spec {
        container {
          name              = "app"
          image             = "phpldapadmin/phpldapadmin:2.3.4"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "APP_TIMEZONE"
            value = "Europe/London"
          }

          env {
            name  = "LOG_CHANNEL"
            value = "stderr"
          }

          env {
            name  = "LDAP_HOST"
            value = "openldap"
          }

          env {
            name  = "LDAP_PORT"
            value = "1389"
          }

          env {
            name  = "LDAP_BASE_DN"
            value = "dc=ldap,dc=bts-crew,dc=com"
          }

          env {
            name  = "LDAP_ALLOW_GUEST"
            value = "false"
          }

          env {
            name  = "LDAP_LOGIN_ATTR"
            value = "uid"
          }

          env {
            name  = "LDAP_USERNAME"
            value = "cn=admin,dc=ldap,dc=bts-crew,dc=com"
          }

          env {
            name  = "LDAP_LOGIN_OBJECTCLASS"
            value = "inetOrgPerson"
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
              memory = "256Mi"
            }
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
