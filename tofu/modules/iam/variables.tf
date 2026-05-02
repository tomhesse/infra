variable "name" {
  description = "Name for the IAM application and policy"
  type        = string
}

variable "project_ids" {
  description = "Scaleway project IDs to scope the policy to"
  type        = list(string)
}

variable "permission_set_names" {
  description = "Scaleway permission set names to grant"
  type        = list(string)
}

variable "expires_at" {
  description = "Expiration date for the API key (RFC3339 format)"
  type        = string
}
