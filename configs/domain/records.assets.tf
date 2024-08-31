########################################################################################################################
# assets.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "assets" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "assets"
  type    = "A"
  records = [data.aws_eip.k3s_node.public_ip]
  ttl     = 60
}
