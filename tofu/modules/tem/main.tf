resource "scaleway_tem_domain" "this" {
  name       = var.domain
  accept_tos = true
  autoconfig = false
  project_id = var.project_id
  region     = "fr-par"
}

resource "scaleway_tem_domain_validation" "this" {
  domain_id = scaleway_tem_domain.this.id
  region    = scaleway_tem_domain.this.region
  timeout   = 300
}
