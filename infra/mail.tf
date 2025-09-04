# Mail records for slug.gay should point to fastmail

resource "porkbun_dns_record" "slug_gay_mx_1" {
  domain  = "slug.gay"
  type    = "MX"
  content = "in1-smtp.messagingengine.com"
  prio    = "10"
}

resource "porkbun_dns_record" "slug_gay_mx_2" {
  domain  = "slug.gay"
  type    = "MX"
  content = "in2-smtp.messagingengine.com"
  prio    = "20"
}

resource "porkbun_dns_record" "slug_gay_dkim_1" {
  domain  = "slug.gay"
  name    = "fm1._domainkey"
  type    = "CNAME"
  content = "fm1.slug.gay.dkim.fmhosted.com"
}

resource "porkbun_dns_record" "slug_gay_dkim_2" {
  domain  = "slug.gay"
  name    = "fm2._domainkey"
  type    = "CNAME"
  content = "fm2.slug.gay.dkim.fmhosted.com"
}

resource "porkbun_dns_record" "slug_gay_dkim_3" {
  domain  = "slug.gay"
  name    = "fm3._domainkey"
  type    = "CNAME"
  content = "fm3.slug.gay.dkim.fmhosted.com"
}

resource "porkbun_dns_record" "slug_gay_spf" {
  domain  = "slug.gay"
  type    = "TXT"
  content = "v=spf1 include:spf.messagingengine.com ?all"
}
