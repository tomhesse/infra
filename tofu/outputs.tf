output "iam_access_keys" {
  description = "Access keys for the per-service IAM API keys, by application name"
  value       = { for name, m in module.iam : name => m.access_key }
  sensitive   = true
}

output "iam_secret_keys" {
  description = "Secret keys for the per-service IAM API keys, by application name"
  value       = { for name, m in module.iam : name => m.secret_key }
  sensitive   = true
}

output "tem_smtp_host" {
  description = "SMTP host for sending emails"
  value       = module.tem.smtp_host
}

output "tem_smtps_port" {
  description = "SMTPS port for sending emails"
  value       = module.tem.smtps_port
}

output "tem_smtps_auth_user" {
  description = "SMTPS authentication user"
  value       = module.tem.smtps_auth_user
}

output "storagebox_server" {
  description = "FQDN of the Storage Box"
  value       = module.storagebox.server
}

output "storagebox_username" {
  description = "Primary username of the Storage Box"
  value       = module.storagebox.username
}

output "storagebox_subaccounts" {
  description = "Map of subaccount details, keyed by name"
  value       = module.storagebox.subaccounts
  sensitive   = true
}
