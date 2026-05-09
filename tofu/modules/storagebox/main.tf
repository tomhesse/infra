resource "hcloud_storage_box" "this" {
  name             = var.name
  storage_box_type = var.storage_box_type
  location         = var.location
  password         = var.password

  ssh_keys = var.ssh_keys

  delete_protection = true

  access_settings = {
    ssh_enabled          = var.access_settings.ssh_enabled
    reachable_externally = var.access_settings.reachable_externally
    samba_enabled        = var.access_settings.samba_enabled
    webdav_enabled       = var.access_settings.webdav_enabled
    zfs_enabled          = var.access_settings.zfs_enabled
  }

  lifecycle {
    ignore_changes  = [ssh_keys]
    prevent_destroy = true
  }
}

resource "hcloud_storage_box_subaccount" "this" {
  for_each = var.subaccounts

  storage_box_id = hcloud_storage_box.this.id
  description    = each.key
  password       = each.value.password
  home_directory = each.value.home_directory

  access_settings = {
    ssh_enabled          = coalesce(try(each.value.access_settings.ssh_enabled, null), var.access_settings.ssh_enabled)
    reachable_externally = coalesce(try(each.value.access_settings.reachable_externally, null), var.access_settings.reachable_externally)
    samba_enabled        = coalesce(try(each.value.access_settings.samba_enabled, null), var.access_settings.samba_enabled)
    webdav_enabled       = coalesce(try(each.value.access_settings.webdav_enabled, null), var.access_settings.webdav_enabled)
  }

}
