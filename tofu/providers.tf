terraform {
  required_version = ">= 1.6"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.91.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.70.2"
    }
  }
}

provider "scaleway" {
  organization_id = var.organization_id
  project_id      = var.project_id
  region          = var.region
}

provider "hcloud" {}
