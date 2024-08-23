locals {
  mysql_selector_labels = {
    "backstage.uk/component" = "database"
    "backstage.uk/engine"    = "mysql"
  }
  mysql_labels = merge(local.mysql_selector_labels, {
    "app.kubernetes.io/name" = "database-mysql"
  })
}

resource "random_password" "mysql_root_password" {
  length  = 20
  special = false
}

resource "aws_ssm_parameter" "mysql_root_password" {
  name  = "/backstage/database/mysql/root-password"
  type  = "SecureString"
  value = random_password.mysql_root_password.result
}

resource "kubernetes_service_v1" "mysql" {
  metadata {
    namespace   = "backstage"
    name        = "mysql"
    annotations = local.default_annotations
    labels      = local.mysql_labels
  }

  spec {
    type     = "ClusterIP"
    selector = local.mysql_selector_labels

    port {
      port = 3306
    }
  }
}

resource "kubernetes_manifest" "mysql_credentials" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = {
      namespace   = "backstage"
      name        = "database-mysql-credentials"
      annotations = local.default_annotations
      labels      = local.mysql_labels
    }
    spec = {
      secretStoreRef = {
        kind = "SecretStore"
        name = "aws-ssm"
      }
      data = [
        {
          secretKey = "MARIADB_ROOT_PASSWORD"
          remoteRef = {
            key = aws_ssm_parameter.mysql_root_password.name
          }
        }
      ]
    }
  }
}

resource "kubernetes_stateful_set_v1" "mysql" {
  metadata {
    namespace   = "backstage"
    name        = "database-mysql"
    annotations = local.default_annotations
    labels      = local.mysql_labels
  }

  spec {
    service_name = kubernetes_service_v1.mysql.metadata[0].name
    replicas     = 1

    selector {
      match_labels = local.mysql_selector_labels
    }

    template {
      metadata {
        namespace   = "backstage"
        name        = "database-mysql"
        annotations = local.default_annotations
        labels      = local.mysql_labels
      }

      spec {
        container {
          name              = "mariadb"
          image             = "mariadb:10.2"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "MARIADB_ROOT_HOST"
            value = "localhost"
          }

          env_from {
            secret_ref {
              name = kubernetes_manifest.mysql_credentials.manifest.metadata.name
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "data"

          host_path {
            path = "/opt/data/backstage/database/mysql"
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
}
