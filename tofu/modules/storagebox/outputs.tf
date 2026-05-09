output "server" {
  description = "FQDN of the Storage Box"
  value       = hcloud_storage_box.this.server
}

output "username" {
  description = "Primary username of the Storage Box"
  value       = hcloud_storage_box.this.server
}

output "subaccounts" {
  description = "Map of subaccount details, keyed by name"
  value = {
    for name, sa in hcloud_storage_box_subaccount.this : name => {
      username = sa.username
      password = sa.password
    }
  }
  sensitive = true
}
