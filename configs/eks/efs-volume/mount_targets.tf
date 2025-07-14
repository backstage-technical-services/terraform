data "aws_eks_cluster" "bnjns" {
  name = "bnjns"
}

resource "aws_security_group" "default" {
  name        = "${var.name}-efs"
  description = "Controls access to the ${var.name} EFS"
  vpc_id      = var.vpc_id
  tags = merge(var.tags, {
    Name = "${var.name}-efs"
  })

  ingress {
    description     = "Allow all traffic from the node group"
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    security_groups = [var.node_security_group_id]
  }

  egress {
    description     = "Allow egress to the node group"
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    security_groups = [var.node_security_group_id]
  }
}

resource "aws_efs_mount_target" "default" {
  for_each = toset(var.private_subnet_ids)

  file_system_id = aws_efs_file_system.default.id
  subnet_id      = each.value
  security_groups = [
    aws_security_group.default.id,
    data.aws_eks_cluster.bnjns.vpc_config[0].cluster_security_group_id,
  ]
}
