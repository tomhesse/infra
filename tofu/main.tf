locals {
  # Per-service IAM API keys expire in groups, on separate dates. The dates and their
  # order are deliberate and the groups are rotated separately -- see CLAUDE.md
  # before changing either. Rotating a group early fails the org-wide expiry cap.
  # Each group's date is bumped when that group is rotated, not ahead of time, so a
  # plan stays empty between rotations. README has the schedule and the next target.
  iam_key_expiry = {
    acme  = "2027-11-15T00:00:00Z"
    apps  = "2027-05-02T00:00:00Z"
    hosts = "2027-05-02T00:00:00Z"
  }

  # Per-service IAM API keys: application name => permission set and expiry group.
  # loki, mimir and tyr are machines; everything else is an application.
  iam_keys = {
    "acme-homeassistant" = { permissions = "DomainsDNSFullAccess", group = "acme" }
    "acme-mimir"         = { permissions = "DomainsDNSFullAccess", group = "acme" }
    "tem-authelia"       = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-homeassistant"  = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-immich"         = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-lldap"          = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-loki"           = { permissions = "TransactionalEmailEmailFullAccess", group = "hosts" }
    "tem-mimir"          = { permissions = "TransactionalEmailEmailFullAccess", group = "hosts" }
    "tem-nextcloud"      = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-prowlarr"       = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-radarr"         = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-sabnzbd"        = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-seer"           = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-sonarr"         = { permissions = "TransactionalEmailEmailFullAccess", group = "apps" }
    "tem-tyr"            = { permissions = "TransactionalEmailEmailFullAccess", group = "hosts" }
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
  permission_set_names = [each.value.permissions]
  expires_at           = local.iam_key_expiry[each.value.group]
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
