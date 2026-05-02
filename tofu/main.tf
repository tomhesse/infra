module "storage" {
  source = "./modules/storage"
  region = var.region
}

module "dns" {
  source        = "./modules/dns"
  owner_contact = var.owner_contact
}

module "iam_acme_mimir" {
  source               = "./modules/iam"
  name                 = "acme-mimir"
  project_ids          = [var.project_id]
  permission_set_names = ["DomainsDNSFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}
