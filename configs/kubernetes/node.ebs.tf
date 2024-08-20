data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_ebs_volume" "node_data" {
  availability_zone = data.aws_availability_zones.available.names[0]
  encrypted         = true
  size              = 20
  type              = "gp3"
  tags = {
    Name      = "${local.meta.owner}-k3s-data"
    component = "k3s"
  }
}
