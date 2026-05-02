output "access_key" {
  description = "Access key for the IAM API key"
  value       = scaleway_iam_api_key.this.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Secret key for the IAM API key"
  value       = scaleway_iam_api_key.this.secret_key
  sensitive   = true
}
