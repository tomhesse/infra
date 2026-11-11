locals {
  # All per-service IAM API keys share one expiry so they can be rotated together.
  iam_key_expires_at = "2027-05-02T00:00:00Z"

  # Per-service IAM API keys: application name => permission set.
  iam_keys = {
    "acme-homeassistant" = "DomainsDNSFullAccess"
    "tem-authelia"       = "TransactionalEmailEmailFullAccess"
    "tem-homeassistant"  = "TransactionalEmailEmailFullAccess"
    "tem-immich"         = "TransactionalEmailEmailFullAccess"
    "tem-lldap"          = "TransactionalEmailEmailFullAccess"
    "tem-loki"           = "TransactionalEmailEmailFullAccess"
    "tem-mimir"          = "TransactionalEmailEmailFullAccess"
    "tem-nextcloud"      = "TransactionalEmailEmailFullAccess"
    "tem-prowlarr"       = "TransactionalEmailEmailFullAccess"
    "tem-radarr"         = "TransactionalEmailEmailFullAccess"
    "tem-sabnzbd"        = "TransactionalEmailEmailFullAccess"
    "tem-seer"           = "TransactionalEmailEmailFullAccess"
    "tem-sonarr"         = "TransactionalEmailEmailFullAccess"
    "tem-tyr"            = "TransactionalEmailEmailFullAccess"
  }
}

module "storage" {
  source = "./modules/storage"
  region = var.region
}

module "dns" {
  source           = "./modules/dns"
  owner_contact_id = var.owner_contact_id

  tem = {
    spf_value    = module.tem.spf_value
    dkim_config  = module.tem.dkim_config
    dkim_name    = module.tem.dkim_name
    dmarc_config = module.tem.dmarc_config
    dmarc_name   = module.tem.dmarc_name
    mx_config    = module.tem.mx_config
    mx_priority  = module.tem.mx_priority
  }
}

module "tem" {
  source     = "./modules/tem"
  domain     = "mail.shrimphouse.xyz"
  project_id = var.project_id
}

module "iam" {
  for_each = local.iam_keys

  source               = "./modules/iam"
  name                 = each.key
  project_ids          = [var.project_id]
  permission_set_names = [each.value]
  expires_at           = local.iam_key_expires_at
}

resource "hcloud_ssh_key" "thesse" {
  name       = "thesse"
  public_key = file("${path.module}/keys/thesse.pub")
}

module "storagebox" {
  source           = "./modules/storagebox"
  name             = "backups"
  storage_box_type = "bx11"
  location         = "fsn1"
  password         = var.storagebox_password
  ssh_keys         = [hcloud_ssh_key.thesse.public_key]
  subaccounts      = var.storagebox_subaccounts
}
