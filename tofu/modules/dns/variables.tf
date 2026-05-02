variable "tem" {
  description = "Transactional Email DNS record values"
  type = object({
    spf_value    = string
    dkim_config  = string
    dkim_name    = string
    dmarc_config = string
    dmarc_name   = string
    mx_config    = string
  })
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
