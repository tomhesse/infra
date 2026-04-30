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
