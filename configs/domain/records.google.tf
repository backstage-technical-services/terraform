########################################################################################################################
# mail.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "CNAME_mail" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "mail"
  type    = "CNAME"
  records = ["ghs.googlehosted.com"]
  ttl     = 60
}

########################################################################################################################
# drive.bts-crew.com
########################################################################################################################
resource "aws_route53_record" "CNAME_drive" {
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "drive"
  type    = "CNAME"
  records = ["ghs.googlehosted.com"]
  ttl     = 60
}
