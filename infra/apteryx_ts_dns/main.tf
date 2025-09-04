terraform {
  required_providers {
    porkbun = {
      source  = "cullenmcdermott/porkbun"
      version = "0.3.0"
    }
  }
}

variable "subdomains" {
    type = list(string)
    default = []
}

variable "ipv4_addr" {
    type = string
    default = "100.95.200.106"
}

variable "ipv6_addr" {
    type = string
    default = "fd7a:115c:a1e0::891f:c86a"
}

variable "slug_domain" {
    type = string
    default = "slug.gay"
}

resource "porkbun_dns_record" "apteryx_ts_dns_ipv4" {
  for_each = toset(var.subdomains)
  domain  = var.slug_domain
  name    = "${each.value}"
  type    = "A"
  content = var.ipv4_addr
}

resource "porkbun_dns_record" "apteryx_ts_dns_ipv6" {
  for_each = toset(var.subdomains)
  domain  = var.slug_domain
  name    = "${each.value}"
  type    = "AAAA"
  content = var.ipv6_addr
}
