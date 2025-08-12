resource "kubernetes_persistent_volume_v1" "data" {
  metadata {
    name = "backstage-openldap"
    labels = merge(local.labels, {
      "backstage.uk/storage-name" = "openldap"
    })
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    volume_mode        = "Filesystem"
    storage_class_name = "aws-efs"

    persistent_volume_reclaim_policy = "Retain"

    capacity = {
      storage = "10Gi"
    }

    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "fs-05929b3d75352ac77::fsap-0c8770498832d4e68"
        volume_attributes = {
          encryptInTransit = "true"
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "data" {
  metadata {
    namespace = var.namespace
    name      = "openldap"
    labels = merge(local.labels, {
      "backstage.uk/storage-name" = "openldap"
    })
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "aws-efs"

    resources {
      requests = {
        storage = kubernetes_persistent_volume_v1.data.spec[0].capacity.storage
      }
    }

    selector {
      match_labels = merge(local.selector_labels, {
        "backstage.uk/storage-name" = "openldap"
      })
    }
  }
}
