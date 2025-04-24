resource "aws_route53_record" "MX_bts_crew_com" { # tflint-ignore: terraform_naming_convention
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = ""
  type    = "MX"
  ttl     = 300

  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com",
  ]
}
