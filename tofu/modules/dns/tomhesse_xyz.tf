resource "scaleway_domain_registration" "tomhesse_xyz" {
  domain_names = ["tomhesse.xyz"]
  auto_renew   = true
  dnssec       = false

  owner_contact_id = var.owner_contact_id

  lifecycle {
    prevent_destroy = true
  }
}
