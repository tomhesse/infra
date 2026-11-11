terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.74.0"
    }
  }

  required_version = ">= 1.6"
}

locals {
  organization_id = "608deeb4-b226-44f7-bb38-4354d8029c7e"

  # Scaleway's default project shares the organization's ID.
  project_id = local.organization_id
}

provider "scaleway" {
  organization_id = local.organization_id
}

resource "scaleway_iam_application" "infra_opentofu" {
  name = "infra-opentofu"
}

resource "scaleway_iam_policy" "infra_opentofu" {
  name           = "infra-opentofu"
  application_id = scaleway_iam_application.infra_opentofu.id

  rule {
    project_ids          = [local.project_id]
    permission_set_names = ["DomainsDNSFullAccess", "ObjectStorageFullAccess", "TransactionalEmailFullAccess"]
  }

  rule {
    organization_id      = local.organization_id
    permission_set_names = ["IAMManager"]
  }
}

resource "scaleway_iam_api_key" "infra_opentofu" {
  application_id = scaleway_iam_application.infra_opentofu.id
  expires_at     = "2027-05-19T00:00:00Z"

  # Without this, renewal destroys this key before creating its replacement,
  # which breaks the apply when it is run with this key's own credentials.
  lifecycle {
    create_before_destroy = true
  }
}
