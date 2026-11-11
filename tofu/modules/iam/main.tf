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

  # expires_at is ForceNew, so changing it replaces the key. Create the
  # replacement before destroying the old one so there is never a moment
  # without a valid key.
  lifecycle {
    create_before_destroy = true
  }
}
