variable "name" {
  description = "Name of the storage box"
  type        = string
}

variable "storage_box_type" {
  description = "Type of the storage box (e.g. bx11, bx21)"
  type        = string
}

variable "location" {
  description = "Location of the storage box (e.g. fsn1, hel1)"
  type        = string
}

variable "password" {
  description = "Password for the root storage box account"
  type        = string
  sensitive   = true
}

variable "subaccounts" {
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

variable "ssh_keys" {
  description = "List of SSH public keys to add to the storage box"
  type        = list(string)
  default     = []
}

variable "access_settings" {
  description = "Access settings for the storage box"
  type = object({
    ssh_enabled          = optional(bool, true)
    reachable_externally = optional(bool, true)
    samba_enabled        = optional(bool, false)
    webdav_enabled       = optional(bool, false)
    zfs_enabled          = optional(bool, false)
  })
  default = {}
}
