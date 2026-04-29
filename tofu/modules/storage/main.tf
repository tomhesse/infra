resource "scaleway_object_bucket" "infra_tofu_state" {
  name          = "infra-tofu-state"
  region        = var.region
  force_destroy = false

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "scaleway_object_bucket_acl" "infra_tofu_state" {
  bucket = scaleway_object_bucket.infra_tofu_state.id
  region = var.region

  acl = "private"
}

resource "scaleway_object_bucket_server_side_encryption_configuration" "infra_tofu_state" {
  bucket = scaleway_object_bucket.infra_tofu_state.name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
