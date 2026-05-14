output "acme_mimir_access_key" {
  description = "Access key for the acme-mimir IAM API key"
  value       = module.iam_acme_mimir.access_key
  sensitive   = true
}

output "acme_mimir_secret_key" {
  description = "Secret key for the acme-mimir IAM API key"
  value       = module.iam_acme_mimir.secret_key
  sensitive   = true
}

output "tem_mimir_access_key" {
  description = "Access key for the tem-mimir IAM API key"
  value       = module.iam_tem_mimir.access_key
  sensitive   = true
}

output "tem_mimir_secret_key" {
  description = "Secret key for the tem-mimir IAM API key"
  value       = module.iam_tem_mimir.secret_key
  sensitive   = true
}

output "tem_prowlarr_access_key" {
  description = "Access key for the tem-prowlarr IAM API key"
  value       = module.iam_tem_prowlarr.access_key
  sensitive   = true
}

output "tem_prowlarr_secret_key" {
  description = "Secret key for the tem-prowlarr IAM API key"
  value       = module.iam_tem_prowlarr.secret_key
  sensitive   = true
}

output "tem_radarr_access_key" {
  description = "Access key for the tem-radarr IAM API key"
  value       = module.iam_tem_radarr.access_key
  sensitive   = true
}

output "tem_radarr_secret_key" {
  description = "Secret key for the tem-radarr IAM API key"
  value       = module.iam_tem_radarr.secret_key
  sensitive   = true
}

output "tem_sonarr_access_key" {
  description = "Access key for the tem-sonarr IAM API key"
  value       = module.iam_tem_sonarr.access_key
  sensitive   = true
}

output "tem_sonarr_secret_key" {
  description = "Secret key for the tem-sonarr IAM API key"
  value       = module.iam_tem_sonarr.secret_key
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
