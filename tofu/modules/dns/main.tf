resource "scaleway_domain_registration" "shrimphouse_xyz" {
  domain_names = ["shrimphouse.xyz"]
  auto_renew   = true
  dnssec       = true

  owner_contact {
    legal_form                  = var.owner_contact.legal_form
    firstname                   = var.owner_contact.firstname
    lastname                    = var.owner_contact.lastname
    email                       = var.owner_contact.email
    phone_number                = var.owner_contact.phone_number
    address_line_1              = var.owner_contact.address_line_1
    zip                         = var.owner_contact.zip
    city                        = var.owner_contact.city
    country                     = var.owner_contact.country
    vat_identification_code     = ""
    company_identification_code = ""
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [owner_contact[0].resale]
  }
}

resource "scaleway_domain_record" "shrimphouse_xyz_ns_root_0" {
  dns_zone = "shrimphouse.xyz"
  type     = "NS"
  data     = "ns0.dom.scw.cloud."
  ttl      = 86400
}

resource "scaleway_domain_record" "shrimphouse_xyz_ns_root_1" {
  dns_zone = "shrimphouse.xyz"
  type     = "NS"
  data     = "ns1.dom.scw.cloud."
  ttl      = 86400
}

resource "scaleway_domain_record" "shrimphouse_xyz_a_vpn" {
  dns_zone = "shrimphouse.xyz"
  type     = "A"
  name     = "vpn"
  data     = "31.172.13.60"
  ttl      = 3600
}

resource "scaleway_domain_record" "shrimphouse_xyz_aaaa_vpn" {
  dns_zone = "shrimphouse.xyz"
  type     = "AAAA"
  name     = "vpn"
  data     = "2a00:c380:e004:19b0::"
  ttl      = 3600
}

resource "scaleway_domain_record" "shrimphouse_xyz_caa_root_issue" {
  dns_zone = "shrimphouse.xyz"
  type     = "CAA"
  data     = "0 issue \"letsencrypt.org\""
  ttl      = 3600
}

resource "scaleway_domain_record" "shrimphouse_xyz_caa_root_issuewild" {
  dns_zone = "shrimphouse.xyz"
  type     = "CAA"
  data     = "0 issuewild \"letsencrypt.org\""
  ttl      = 3600
}
