resource "scaleway_domain_registration" "tomhesse_xyz" {
  domain_names = ["tomhesse.xyz"]
  auto_renew   = true
  dnssec       = false

  owner_contact_id = var.owner_contact_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "scaleway_domain_record" "tomhesse_xyz_ns_root_0" {
  dns_zone = "tomhesse.xyz"
  type     = "NS"
  data     = "ns0.dom.scw.cloud."
  ttl      = 86400
}

resource "scaleway_domain_record" "tomhesse_xyz_ns_root_1" {
  dns_zone = "tomhesse.xyz"
  type     = "NS"
  data     = "ns1.dom.scw.cloud."
  ttl      = 86400
}

resource "scaleway_domain_record" "tomhesse_xyz_mx_root_1" {
  dns_zone = "tomhesse.xyz"
  type     = "MX"
  data     = "mxext1.mailbox.org."
  priority = 10
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_mx_root_2" {
  dns_zone = "tomhesse.xyz"
  type     = "MX"
  data     = "mxext2.mailbox.org."
  priority = 10
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_mx_root_3" {
  dns_zone = "tomhesse.xyz"
  type     = "MX"
  data     = "mxext3.mailbox.org."
  priority = 10
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_mx_root_4" {
  dns_zone = "tomhesse.xyz"
  type     = "MX"
  data     = "mxext4.mailbox.org."
  priority = 10
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_txt_mailbox_verification" {
  dns_zone = "tomhesse.xyz"
  type     = "TXT"
  name     = "84f18801657f421ae1e16d6e239f3f051a002364"
  data     = "12639bdf6dcd898b2dc4bb2444ccba1a2ce47c1e"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_txt_root_spf" {
  dns_zone = "tomhesse.xyz"
  type     = "TXT"
  data     = "v=spf1 include:mailbox.org ~all"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_cname_dkim_mbo0001" {
  dns_zone = "tomhesse.xyz"
  type     = "CNAME"
  name     = "mbo0001._domainkey"
  data     = "mbo0001._domainkey.mailbox.org."
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_cname_dkim_mbo0002" {
  dns_zone = "tomhesse.xyz"
  type     = "CNAME"
  name     = "mbo0002._domainkey"
  data     = "mbo0002._domainkey.mailbox.org."
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_cname_dkim_mbo0003" {
  dns_zone = "tomhesse.xyz"
  type     = "CNAME"
  name     = "mbo0003._domainkey"
  data     = "mbo0003._domainkey.mailbox.org."
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_cname_dkim_mbo0004" {
  dns_zone = "tomhesse.xyz"
  type     = "CNAME"
  name     = "mbo0004._domainkey"
  data     = "mbo0004._domainkey.mailbox.org."
  ttl      = 3600
}
