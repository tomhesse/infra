variable "tem" {
  description = "Transactional Email DNS record values"
  type = object({
    spf_value    = string
    dkim_config  = string
    dkim_name    = string
    dmarc_config = string
    dmarc_name   = string
    mx_config    = string
    mx_priority  = number
  })
}
