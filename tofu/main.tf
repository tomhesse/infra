module "storage" {
  source = "./modules/storage"
  region = var.region
}

module "dns" {
  source        = "./modules/dns"
  owner_contact = var.owner_contact
}
