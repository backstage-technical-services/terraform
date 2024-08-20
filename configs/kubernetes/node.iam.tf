// For now, just use the same IAM role as the master node
data "aws_iam_instance_profile" "master_node" {
  name = "bnjns-k3s"
}
