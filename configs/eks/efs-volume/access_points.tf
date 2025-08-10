resource "aws_efs_access_point" "default" {
  for_each = { for ap in var.access_points : ap.directory => ap }

  file_system_id = aws_efs_file_system.default.id
  tags = merge(var.tags, {
    Name = "${var.name}${each.value.directory}"
  })

  posix_user {
    gid = each.value.gid
    uid = each.value.uid
  }

  root_directory {
    path = each.value.directory

    creation_info {
      owner_gid   = each.value.gid
      owner_uid   = each.value.uid
      permissions = "766"
    }
  }
}
