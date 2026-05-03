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
