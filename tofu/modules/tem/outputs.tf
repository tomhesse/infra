output "spf_value" {
  description = "SPF record value for TEM"
  value       = scaleway_tem_domain.this.spf_value
}

output "dkim_config" {
  description = "DKIM record value for TEM"
  value       = scaleway_tem_domain.this.dkim_config
}

output "dkim_name" {
  description = "DKIM record name for TEM"
  value       = scaleway_tem_domain.this.dkim_name
}

output "dmarc_config" {
  description = "DMARC record value for TEM"
  value       = scaleway_tem_domain.this.dmarc_config
}

output "dmarc_name" {
  description = "DMARC record name for TEM"
  value       = scaleway_tem_domain.this.dmarc_name
}

output "mx_config" {
  description = "MX record value for TEM (priority and hostname)"
  value       = scaleway_tem_domain.this.mx_config
}

output "smtp_host" {
  description = "SMTP host for sending emails"
  value       = scaleway_tem_domain.this.smtp_host
}

output "smtp_port" {
  description = "SMTP port for sending emails"
  value       = scaleway_tem_domain.this.smtp_port
}

output "smtps_port" {
  description = "SMTPS port for sending emails"
  value       = scaleway_tem_domain.this.smtps_port
}

output "smtps_auth_user" {
  description = "SMTPS authentication user"
  value       = scaleway_tem_domain.this.smtps_auth_user
}
