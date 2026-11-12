resource "scaleway_domain_registration" "tomhesse_xyz" {
  domain_names = ["tomhesse.xyz"]
  auto_renew   = true
  dnssec       = false

  owner_contact_id = var.owner_contact_id

  lifecycle {
    prevent_destroy = true
  }
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
