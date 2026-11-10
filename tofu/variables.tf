variable "organization_id" {
  description = "Scaleway organization ID"
  type        = string
}

variable "project_id" {
  description = "Scaleway project ID"
  type        = string
}

variable "region" {
  description = "Scaleway region"
  type        = string
  default     = "nl-ams"
}

variable "storagebox_password" {
  description = "Password for the root storage box account"
  type        = string
  sensitive   = true
}

variable "storagebox_subaccounts" {
  description = "Map of subaccounts to create, keyed by name"
  type = map(object({
    password       = string
    home_directory = string
    access_settings = optional(object({
      ssh_enabled          = optional(bool)
      reachable_externally = optional(bool)
      samba_enabled        = optional(bool)
      webdav_enabled       = optional(bool)
    }))
  }))
  default = {}
}

variable "owner_contact_id" {
  description = "ID of the existing Scaleway contact that owns the domain"
  type        = string
}
