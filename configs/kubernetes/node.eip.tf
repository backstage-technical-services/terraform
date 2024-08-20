resource "aws_eip" "node" {
  domain = "vpc"
  tags = {
    Name = "${local.meta.owner}-k3s-worker"
  }
}

resource "aws_eip_association" "node" {
  allocation_id = aws_eip.node.id
  instance_id   = module.node.instance_id
}
