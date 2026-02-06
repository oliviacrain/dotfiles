# Root of slug.gay should resolve to the slug-party fly.io project

resource "porkbun_dns_record" "slug_gay_fly_alias" {
  domain  = "slug.gay"
  type    = "ALIAS"
  content = "slug-party.fly.dev"
}

resource "porkbun_dns_record" "www_slug_gay_fly_alias" {
  domain  = "slug.gay"
  name    = "www"
  type    = "CNAME"
  content = "slug-party.fly.dev"
}

# docs.slug.gay should point to the slug-docs fly.io project

resource "porkbun_dns_record" "docs_slug_gay_fly_alias" {
  domain  = "slug.gay"
  name    = "docs"
  type    = "CNAME"
  content = "slug-docs.fly.dev"
}

# Most subdomains of slug.gay should point to apteryx

locals {
  apteryx_ts_sudomains = ["budget", "git", "media", "minecraft", "notes", "recipes", "requests", "rss", "vault"]
}

module "apteryx_ts_dns" {
  source     = "./apteryx_ts_dns"
  subdomains = local.apteryx_ts_sudomains
}

resource "porkbun_dns_record" "auth_slug_gay_ipv4" {
  domain  = "slug.gay"
  name    = "auth"
  type    = "A"
  content = "209.38.51.107"
}
