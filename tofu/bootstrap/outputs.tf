output "access_key" {
  description = "Access key for the infra-opentofu IAM API key"
  value       = scaleway_iam_api_key.infra_opentofu.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Secret key for the infra-opentofu IAM API key"
  value       = scaleway_iam_api_key.infra_opentofu.secret_key
  sensitive   = true
}
