resource "scaleway_domain_registration" "tomhesse_xyz" {
  domain_names = ["tomhesse.xyz"]
  auto_renew   = true
  dnssec       = true

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

resource "scaleway_domain_record" "tomhesse_xyz_txt_dmarc" {
  dns_zone = "tomhesse.xyz"
  type     = "TXT"
  name     = "_dmarc"
  data     = "v=DMARC1;p=none;rua=mailto:postmaster@tomhesse.xyz"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_cname_openpgpkey" {
  dns_zone = "tomhesse.xyz"
  type     = "CNAME"
  name     = "openpgpkey"
  data     = "wkd.keys.openpgp.org."
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_caa_root_issue" {
  dns_zone = "tomhesse.xyz"
  type     = "CAA"
  data     = "0 issue \"letsencrypt.org\""
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_caa_root_issuewild" {
  dns_zone = "tomhesse.xyz"
  type     = "CAA"
  data     = "0 issuewild \";\""
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_caa_root_iodef" {
  dns_zone = "tomhesse.xyz"
  type     = "CAA"
  data     = "0 iodef \"mailto:hostmaster@tomhesse.xyz\""
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_txt_root_google_verification" {
  dns_zone = "tomhesse.xyz"
  type     = "TXT"
  data     = "google-site-verification=te4u3ZZMlXXGfA7U0IxdmDtdSUQ8qUO8G1__yCrMsh8"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_a_root_0" {
  dns_zone = "tomhesse.xyz"
  type     = "A"
  data     = "185.199.108.153"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_a_root_1" {
  dns_zone = "tomhesse.xyz"
  type     = "A"
  data     = "185.199.109.153"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_a_root_2" {
  dns_zone = "tomhesse.xyz"
  type     = "A"
  data     = "185.199.110.153"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_a_root_3" {
  dns_zone = "tomhesse.xyz"
  type     = "A"
  data     = "185.199.111.153"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_aaaa_root_0" {
  dns_zone = "tomhesse.xyz"
  type     = "AAAA"
  data     = "2606:50c0:8000::153"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_aaaa_root_1" {
  dns_zone = "tomhesse.xyz"
  type     = "AAAA"
  data     = "2606:50c0:8001::153"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_aaaa_root_2" {
  dns_zone = "tomhesse.xyz"
  type     = "AAAA"
  data     = "2606:50c0:8002::153"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_aaaa_root_3" {
  dns_zone = "tomhesse.xyz"
  type     = "AAAA"
  data     = "2606:50c0:8003::153"
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_cname_www" {
  dns_zone = "tomhesse.xyz"
  type     = "CNAME"
  name     = "www"
  data     = "tomhesse.github.io."
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_cname_start" {
  dns_zone = "tomhesse.xyz"
  type     = "CNAME"
  name     = "start"
  data     = "tomhesse.github.io."
  ttl      = 3600
}

resource "scaleway_domain_record" "tomhesse_xyz_txt_github_pages_challenge" {
  dns_zone = "tomhesse.xyz"
  type     = "TXT"
  name     = "_github-pages-challenge-tomhesse"
  data     = "97e1c287c159666347d305ddebb439"
  ttl      = 3600
}
