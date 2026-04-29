terraform {
  backend "s3" {
    bucket = "infra-tofu-state"
    key    = "terraform.tfstate"
    region = "nl-ams"

    endpoints = {
      s3 = "https://s3.nl-ams.scw.cloud"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}
