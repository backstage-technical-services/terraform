########################################################################################################################
# telephony.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "telephony" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "telephony"
  type    = "CNAME"
  records = ["bts-telephony.su.bath.ac.uk"]
  ttl     = 60
}
