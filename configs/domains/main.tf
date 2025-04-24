locals {
  default_tags = {
    managed-by = "Terraform"
    owner      = "backstage"
    repo       = "backstage/terraform"
    config     = try(regex("[^/]+$", path.cwd), "unknown")
  }
}

data "aws_eip" "k3s_node" {
  filter {
    name   = "tag:Name"
    values = ["backstage-k3s-worker"]
  }
}

module "bts_crew_com" {
  source = "./domain"

  domain_name = "bts-crew.com"
  records = [
    {
      name    = ""
      type    = "A"
      records = [data.aws_eip.k3s_node.public_ip]
    },
    {
      name = ""
      type = "MX"
      ttl  = 300
      records = [
        "1 aspmx.l.google.com",
        "5 alt1.aspmx.l.google.com",
        "5 alt2.aspmx.l.google.com",
        "10 alt3.aspmx.l.google.com",
        "10 alt4.aspmx.l.google.com",
      ]
    },
    {
      name    = ""
      type    = "TXT"
      ttl     = 600
      records = ["v=spf1 include:_spf.google.com ~all"]
    },
    {
      name    = "_domainconnect"
      type    = "CNAME"
      ttl     = 600
      records = ["_domainconnect.ss.domaincontrol.com"]
    },
    {
      name    = "_github-challenge-backstage-technical-services"
      type    = "TXT"
      ttl     = 600
      records = ["6193c4ccc3"]
    },
    {
      name    = "assets"
      type    = "A"
      records = [data.aws_eip.k3s_node.public_ip]
    },
    {
      name    = "auth"
      type    = "A"
      records = [data.aws_eip.k3s_node.public_ip]
    },
    {
      name    = "drive"
      type    = "CNAME"
      records = ["ghs.googlehosted.com"]
    },
    {
      name    = "google._domainkey"
      type    = "TXT"
      ttl     = 600
      records = ["v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAswqEb+vOQHUgn5u150Yp9qO/jLvRTvozU6R0PZinlOxQts29CHgEtecx88JZGDVE57axEqXZ7TysuA90Fst/V47tDDPq3qtM6SANgC850cR9FB8gEiVM3cxofpEtrKY2IjRusfzhL6lLUbH8MN4Mqaz6/WecSurt2UahRsc0Z723sKagY54Hq6LHOlviAL64G\"\"2HuV9s20Uhe5BmsPPH2c9oia/iEm5nnC7v3Dj0sKKoAtK8tIGFm4WB3Cifga+pFhMPUIgjj+/72bMJ3F51FwSUBD3CPUAt2MUmmszm16olPTcpv88X4aY7NYfRvDQ/2Gk2Nrf/WCfUL8SUfjlgmhwIDAQAB"]
    },
    {
      name    = "google-site-verification"
      type    = "TXT"
      ttl     = 600
      records = ["v=spf1 include:_spf.google.com ~all"]
    },
    {
      name    = "librenms"
      type    = "CNAME"
      records = ["bts-librenms.su.bath.ac.uk"]
    },
    {
      name    = "mail"
      type    = "CNAME"
      records = ["ghs.googlehosted.com"]
    },
    {
      name    = "nas"
      type    = "A"
      records = ["138.38.11.55"]
    },
    {
      name    = "pbx"
      type    = "A"
      records = ["138.38.11.61"]
    },
    {
      name    = "pc-deployment"
      type    = "CNAME"
      records = ["bts-pxesrv.su.bath.ac.uk"]
    },
    {
      name    = "staging"
      type    = "A"
      records = [data.aws_eip.k3s_node.public_ip]
    },
    {
      name    = "telephony"
      type    = "CNAME"
      records = ["bts-telephony.su.bath.ac.uk"]
    },

    {
      name    = "wiki"
      type    = "CNAME"
      records = ["bts-wiki.su.bath.ac.uk"]
    },
    {
      name    = "www"
      type    = "A"
      records = [data.aws_eip.k3s_node.public_ip]
    },
  ]
}

module "bts_finance_co_uk" {
  source = "./domain"

  domain_name = "bts-finance.co.uk"
  records = [
    {
      name    = ""
      type    = "A"
      records = ["69.163.179.6"]
    },
    {
      name = ""
      type = "MX"
      ttl  = 300
      records = [
        "10 ASPMX.L.GOOGLE.COM",
        "20 ALT1.ASPMX.L.GOOGLE.COM",
        "20 ALT2.ASPMX.L.GOOGLE.COM",
        "30 ASPMX2.GOOGLEMAIL.COM",
        "30 ASPMX3.GOOGLEMAIL.COM",
        "30 ASPMX4.GOOGLEMAIL.COM",
        "30 ASPMX5.GOOGLEMAIL.COM",
      ]
    },
    {
      name    = "_acme-challenge"
      type    = "TXT"
      records = ["sKQM-6DlAQ25wv-AsLZ-aHpDO3_uu2_95iP9_6X_1k0"]
    },
    {
      name    = "ftp"
      type    = "A"
      records = ["69.163.179.6"]
    },
    {
      name    = "mail"
      type    = "CNAME"
      records = ["ghs.googlehosted.com"]
    },
    {
      name    = "mysql"
      type    = "A"
      records = ["64.90.32.36"]
    },
    {
      name    = "ssh"
      type    = "A"
      records = ["69.163.179.6"]
    },
    {
      name    = "www"
      type    = "A"
      records = ["69.163.179.6"]
    },
  ]
}
