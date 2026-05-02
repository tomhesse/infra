module "storage" {
  source = "./modules/storage"
  region = var.region
}

module "dns" {
  source        = "./modules/dns"
  owner_contact = var.owner_contact

  tem = {
    spf_value    = module.tem.spf_value
    dkim_config  = module.tem.dkim_config
    dkim_name    = module.tem.dkim_name
    dmarc_config = module.tem.dmarc_config
    dmarc_name   = module.tem.dmarc_name
    mx_config    = module.tem.mx_config
  }
}

module "tem" {
  source     = "./modules/tem"
  domain     = "mail.shrimphouse.xyz"
  project_id = var.project_id
}

module "iam_acme_mimir" {
  source               = "./modules/iam"
  name                 = "acme-mimir"
  project_ids          = [var.project_id]
  permission_set_names = ["DomainsDNSFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}
