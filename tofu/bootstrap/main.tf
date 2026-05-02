terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.6"
}

provider "scaleway" {
  organization_id = "608deeb4-b226-44f7-bb38-4354d8029c7e"
}

resource "scaleway_iam_application" "infra_opentofu" {
  name = "infra-opentofu"
}

resource "scaleway_iam_policy" "infra_opentofu" {
  name           = "infra-opentofu"
  application_id = scaleway_iam_application.infra_opentofu.id

  rule {
    project_ids          = ["608deeb4-b226-44f7-bb38-4354d8029c7e"]
    permission_set_names = ["DomainsDNSFullAccess", "ObjectStorageFullAccess", "TransactionalEmailFullAccess"]
  }

  rule {
    organization_id      = "608deeb4-b226-44f7-bb38-4354d8029c7e"
    permission_set_names = ["IAMManager"]
  }
}

resource "scaleway_iam_api_key" "infra_opentofu" {
  application_id = scaleway_iam_application.infra_opentofu.id
  expires_at     = "2026-05-19T00:00:00Z"
}
