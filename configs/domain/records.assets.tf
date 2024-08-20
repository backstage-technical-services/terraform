########################################################################################################################
# assets.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "CNAME_assets" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "assets"
  type    = "CNAME"
  records = ["susv-backstage.bath.ac.uk"]
  ttl     = 60
}
