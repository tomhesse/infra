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

variable "owner_contact" {
  description = "Domain owner contact details"
  type = object({
    legal_form     = string
    firstname      = string
    lastname       = string
    email          = string
    phone_number   = string
    address_line_1 = string
    zip            = string
    city           = string
    country        = string
  })
}
