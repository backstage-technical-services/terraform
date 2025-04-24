resource "aws_route53_record" "CNAME_domainconnect" { # tflint-ignore: terraform_naming_convention
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "_domainconnect"
  type    = "CNAME"
  records = ["_domainconnect.ss.domaincontrol.com"]
  ttl     = 600
}

resource "aws_route53_record" "TXT_bts_crew_com" { # tflint-ignore: terraform_naming_convention
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = ""
  type    = "TXT"
  records = ["v=spf1 include:_spf.google.com ~all"]
  ttl     = 600
}

resource "aws_route53_record" "TXT_google_site_verification" { # tflint-ignore: terraform_naming_convention
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "google-site-verification"
  type    = "TXT"
  records = ["v=spf1 include:_spf.google.com ~all"]
  ttl     = 600
}

resource "aws_route53_record" "TXT_google_domain_key" { # tflint-ignore: terraform_naming_convention
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "google._domainkey"
  type    = "TXT"
  records = ["v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAswqEb+vOQHUgn5u150Yp9qO/jLvRTvozU6R0PZinlOxQts29CHgEtecx88JZGDVE57axEqXZ7TysuA90Fst/V47tDDPq3qtM6SANgC850cR9FB8gEiVM3cxofpEtrKY2IjRusfzhL6lLUbH8MN4Mqaz6/WecSurt2UahRsc0Z723sKagY54Hq6LHOlviAL64G\"\"2HuV9s20Uhe5BmsPPH2c9oia/iEm5nnC7v3Dj0sKKoAtK8tIGFm4WB3Cifga+pFhMPUIgjj+/72bMJ3F51FwSUBD3CPUAt2MUmmszm16olPTcpv88X4aY7NYfRvDQ/2Gk2Nrf/WCfUL8SUfjlgmhwIDAQAB"]
  ttl     = 600
}

resource "aws_route53_record" "TXT_github_challenge" { # tflint-ignore: terraform_naming_convention
  zone_id = aws_route53_zone.bts_crew_com.id
  name    = "_github-challenge-backstage-technical-services"
  type    = "TXT"
  records = ["6193c4ccc3"]
  ttl     = 600
}
