########################################################################################################################
# bts-crew.com, www.bts-crew.com, staging.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "website" {
  for_each = toset(["", "www", "staging"])

  zone_id = aws_route53_zone.bts_crew_com.id
  name    = each.key
  type    = "A"
  records = [data.aws_eip.k3s_node.public_ip]
  ttl     = 60
}

resource "aws_route53_record" "auth" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "auth"
  type    = "A"
  records = [data.aws_eip.k3s_node.public_ip]
  ttl     = 60
}
