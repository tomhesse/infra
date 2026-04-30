# infra

Homelab infrastructure as code, managed with [OpenTofu](https://opentofu.org/).

## Repo layout

```
tofu/
  backend.tf      # S3 backend configuration
  providers.tf    # Scaleway provider configuration
  main.tf         # Root module, calls dns and storage modules
  variables.tf    # Root-level input variables
  terraform.tfvars  # Variable values (gitignored, contains personal data)
  modules/
    dns/           # Domain registrations and DNS records
    storage/       # S3-compatible object storage (Scaleway Object Storage)
  bootstrap/
    main.tf        # IAM application, policy, and API key
    outputs.tf     # API key credentials (sensitive)
```

## Prerequisites

- [Nix](https://nixos.org/) with flakes enabled
- A Scaleway account with API keys

## Getting started

Enter the dev shell to get all required tools (OpenTofu, etc.) and set up credentials:

```sh
nix develop
```

This will prompt for your Scaleway Access Key and Secret Key, and export them for both the Scaleway provider and the S3 backend.

## State

The root module stores state remotely in the `infra-opentofu-state` S3 bucket on Scaleway (`nl-ams`). Running `tofu init` will configure the backend automatically.

The bootstrap module uses local state, which is not committed to the repo.

## Bootstrapping

Bootstrapping requires a **personal Scaleway API key** with organization-level permissions (IAM access). Run these steps once to set up the infrastructure that the root module depends on.

### 1. Bootstrap IAM (`tofu/bootstrap/`)

The bootstrap module creates the IAM application and API key used by the root module.

```sh
cd tofu/bootstrap
tofu init
tofu apply
```

After applying, retrieve the credentials:

```sh
tofu output -raw access_key
tofu output -raw secret_key
```

Use these as `SCW_ACCESS_KEY` / `SCW_SECRET_KEY` and `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` for the root module.

### 2. Initialize the root module

On first apply, the S3 state bucket does not exist yet. Temporarily comment out the `backend "s3"` block in `backend.tf` to use local state:

```sh
cd tofu
tofu init
tofu apply
```

Then uncomment the backend block and migrate the state to the new bucket:

```sh
tofu init -migrate-state
```

### Key renewal

The API key has an expiration date set in `bootstrap/main.tf`. To renew, update the `expires_at` field and apply:

```sh
cd tofu/bootstrap
tofu apply
```

This will destroy the old key and create a new one. Retrieve the new credentials and update all environments using the old key:

```sh
tofu output -raw access_key
tofu output -raw secret_key
```

## Usage

```sh
cd tofu
tofu init
tofu plan
tofu apply
```
