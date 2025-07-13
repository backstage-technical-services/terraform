resource "aws_efs_file_system" "default" {
  creation_token = var.name
  encrypted      = true
  tags = merge(var.tags, {
    Name = var.name
  })

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
}
