resource "aws_route53_zone" "bts_finance_co_uk" {
  name = "bts-finance.co.uk"
}

########################################################################################################################
# Web
########################################################################################################################
resource "aws_route53_record" "A_bts_finance_co_uk" {
  zone_id = aws_route53_zone.bts_finance_co_uk.id
  name    = ""
  type    = "A"
  ttl     = 60
  records = ["69.163.179.6"]
}
resource "aws_route53_record" "A_www_bts_finance_co_uk" {
  zone_id = aws_route53_zone.bts_finance_co_uk.id
  name    = "www"
  type    = "A"
  ttl     = 60
  records = ["69.163.179.6"]
}
resource "aws_route53_record" "A_ftp_bts_finance_co_uk" {
  zone_id = aws_route53_zone.bts_finance_co_uk.id
  name    = "ftp"
  type    = "A"
  ttl     = 60
  records = ["69.163.179.6"]
}
resource "aws_route53_record" "A_ssh_bts_finance_co_uk" {
  zone_id = aws_route53_zone.bts_finance_co_uk.id
  name    = "ssh"
  type    = "A"
  ttl     = 60
  records = ["69.163.179.6"]
}
resource "aws_route53_record" "A_mysql_bts_finance_co_uk" {
  zone_id = aws_route53_zone.bts_finance_co_uk.id
  name    = "mysql"
  type    = "A"
  ttl     = 60
  records = ["64.90.32.36"]
}

########################################################################################################################
# Mail
########################################################################################################################
resource "aws_route53_record" "MX_bts_finance_co_uk" {
  zone_id = aws_route53_zone.bts_finance_co_uk.id
  name    = ""
  type    = "MX"
  ttl     = 300
  records = [
    "10 ASPMX.L.GOOGLE.COM",
    "20 ALT1.ASPMX.L.GOOGLE.COM",
    "20 ALT2.ASPMX.L.GOOGLE.COM",
    "30 ASPMX2.GOOGLEMAIL.COM",
    "30 ASPMX3.GOOGLEMAIL.COM",
    "30 ASPMX4.GOOGLEMAIL.COM",
    "30 ASPMX5.GOOGLEMAIL.COM",
  ]
}
resource "aws_route53_record" "CNAME_mail_bts_finance_co_uk" {
  zone_id = aws_route53_zone.bts_finance_co_uk.id
  name    = "mail"
  type    = "CNAME"
  ttl     = 60
  records = ["ghs.googlehosted.com"]
}

########################################################################################################################
# Misc
########################################################################################################################
resource "aws_route53_record" "TXT_acme_challenge_bts_finance_co_uk" {
  zone_id = aws_route53_zone.bts_finance_co_uk.id
  name    = "_acme-challenge"
  type    = "TXT"
  ttl     = 60
  records = ["sKQM-6DlAQ25wv-AsLZ-aHpDO3_uu2_95iP9_6X_1k0"]
}
