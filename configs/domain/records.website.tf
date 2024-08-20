########################################################################################################################
# bts-crew.com, www.bts-crew.com, staging.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "website" {
  for_each = toset(["", "www", "staging"])

  zone_id = aws_route53_zone.bts_crew_com.id
  name    = each.key
  type    = "A"
  records = ["185.52.1.30"]
  ttl     = 60
}

########################################################################################################################
# v4-k3s.bts-crew.com
########################################################################################################################
data "aws_eip" "k3s_node" {
  filter {
    name = "tag:Name"
    values = ["backstage-k3s-worker"]
  }
}
resource "aws_route53_record" "website_v4_k3s" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "v4-k3s"
  type    = "A"
  records = [data.aws_eip.k3s_node.public_ip]
  ttl     = 60
}
