data "aws_efs_file_system" "backstage_data" {
  creation_token = "backstage-data"
}

resource "kubernetes_persistent_volume_v1" "data" {
  metadata {
    name   = "backstage-database-${local.component}"
    labels = local.labels
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    volume_mode        = "Filesystem"
    storage_class_name = "aws-efs"

    persistent_volume_reclaim_policy = "Retain"

    capacity = {
      storage = var.storage_size
    }

    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${data.aws_efs_file_system.backstage_data.file_system_id}::${var.access_point_id}"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "data" {
  metadata {
    namespace = "backstage"
    name      = "database-${local.component}"
    labels    = local.labels
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "aws-efs"

    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }
}
