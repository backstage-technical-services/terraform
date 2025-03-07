########################################################################################################################
# pc-deployment.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "wiki" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "pc-deployment"
  type    = "CNAME"
  records = ["bts-pxesrv.su.bath.ac.uk"]
  ttl     = 60
}
