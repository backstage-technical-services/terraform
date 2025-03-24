########################################################################################################################
# librenms.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "librenms" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "librenms"
  type    = "CNAME"
  records = ["bts-librenms.su.bath.ac.uk"]
  ttl     = 60
}
