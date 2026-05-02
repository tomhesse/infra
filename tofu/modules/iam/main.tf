resource "scaleway_iam_application" "this" {
  name = var.name
}

resource "scaleway_iam_policy" "this" {
  name           = var.name
  application_id = scaleway_iam_application.this.id

  rule {
    project_ids          = var.project_ids
    permission_set_names = var.permission_set_names
  }
}

resource "scaleway_iam_api_key" "this" {
  application_id = scaleway_iam_application.this.id
  expires_at     = var.expires_at
}
