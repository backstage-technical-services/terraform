########################################################################################################################
# nextcloud.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "nextcloud" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "nextcloud"
  type    = "CNAME"
  records = ["bts-nextcloud.su.bath.ac.uk"]
  ttl     = 60
}
