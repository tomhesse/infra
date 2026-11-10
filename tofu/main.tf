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

module "iam_acme_homeassistant" {
  source               = "./modules/iam"
  name                 = "acme-homeassistant"
  project_ids          = [var.project_id]
  permission_set_names = ["DomainsDNSFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_acme_mimir" {
  source               = "./modules/iam"
  name                 = "acme-mimir"
  project_ids          = [var.project_id]
  permission_set_names = ["DomainsDNSFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
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

module "iam_tem_alertmanager" {
  source               = "./modules/iam"
  name                 = "tem-alertmanager"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_authelia" {
  source               = "./modules/iam"
  name                 = "tem-authelia"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_homeassistant" {
  source               = "./modules/iam"
  name                 = "tem-homeassistant"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_immich" {
  source               = "./modules/iam"
  name                 = "tem-immich"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_lldap" {
  source               = "./modules/iam"
  name                 = "tem-lldap"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_loki" {
  source               = "./modules/iam"
  name                 = "tem-loki"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_mimir" {
  source               = "./modules/iam"
  name                 = "tem-mimir"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_prowlarr" {
  source               = "./modules/iam"
  name                 = "tem-prowlarr"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_radarr" {
  source               = "./modules/iam"
  name                 = "tem-radarr"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_sabnzbd" {
  source               = "./modules/iam"
  name                 = "tem-sabnzbd"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_nextcloud" {
  source               = "./modules/iam"
  name                 = "tem-nextcloud"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_seer" {
  source               = "./modules/iam"
  name                 = "tem-seer"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_sonarr" {
  source               = "./modules/iam"
  name                 = "tem-sonarr"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}

module "iam_tem_tyr" {
  source               = "./modules/iam"
  name                 = "tem-tyr"
  project_ids          = [var.project_id]
  permission_set_names = ["TransactionalEmailEmailFullAccess"]
  expires_at           = "2027-05-02T00:00:00Z"
}
