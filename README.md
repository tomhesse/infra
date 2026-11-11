# infra

Homelab infrastructure as code, managed with [OpenTofu](https://opentofu.org/).

## Repo layout

```
flake.nix                   # Nix dev shell (OpenTofu, credentials)
flake.lock                  # Pinned Nix dependencies
tofu/
  backend.tf                # S3 backend configuration (Scaleway Object Storage)
  providers.tf              # Provider configuration and version pins (Scaleway, Hetzner Cloud)
  main.tf                   # Root module: instantiates the modules below, declares the Hetzner SSH key
  variables.tf              # Root-level input variables
  outputs.tf                # Per-service API key credentials (all sensitive)
  terraform.tfvars          # Variable values (gitignored, contains personal data)
  terraform.tfvars.example  # Template for the above (committed)
  .terraform.lock.hcl       # Provider dependency lock file (committed)
  keys/
    thesse.pub              # SSH public key, uploaded to Hetzner Cloud
  modules/
    dns/                    # Domain registrations + DNS records (incl. TEM-derived mail records)
    storage/                # Object storage bucket holding this repo's remote state
    tem/                    # Transactional Email domain (mail.shrimphouse.xyz)
    iam/                    # Generic factory: one IAM application + policy + API key
    storagebox/             # Hetzner Storage Box and its per-service subaccounts
  bootstrap/
    main.tf                 # IAM application, policy, and API key
    outputs.tf              # API key credentials (sensitive)
```

## Prerequisites

- [Nix](https://nixos.org/) with flakes enabled
- A Scaleway account with API keys
- A Hetzner Cloud account with an API token

## Getting started

Enter the dev shell to get all required tools (OpenTofu, etc.) and set up credentials:

```sh
nix develop
```

This will prompt for your Scaleway Access Key and Secret Key and your Hetzner Cloud API token.
The Scaleway keys are exported as `SCW_ACCESS_KEY` / `SCW_SECRET_KEY` and mirrored into
`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`, since the S3 backend authenticates with the same
credentials. The Hetzner token is exported as `HCLOUD_TOKEN` for the Hetzner Cloud provider.

The two secrets are read without echo. Variables that are already set are left alone, so you can
export them beforehand to skip the prompts or to use the shell non-interactively.

The root module also needs variable values. Copy the template and fill it in:

```sh
cp tofu/terraform.tfvars.example tofu/terraform.tfvars
```

`terraform.tfvars` is gitignored. `organization_id`, `project_id`, `storagebox_password` and
`owner_contact_id` are required; the rest have defaults.

## State

The root module stores state remotely in the `infra-tofu-state` S3 bucket on Scaleway (`nl-ams`). Running `tofu init` will configure the backend automatically.

The bootstrap module uses local state, which is not committed to the repo.

## Bootstrapping

Bootstrapping requires a **personal Scaleway API key** with organization-level permissions (IAM access), because nothing else exists yet. Run these steps once to set up the infrastructure that the root module depends on.

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

### 3. Import existing DNS resources

The domain registrations and NS records already exist at Scaleway and must be imported into state:

```sh
cd tofu
tofu import module.dns.scaleway_domain_registration.shrimphouse_xyz shrimphouse.xyz
tofu import module.dns.scaleway_domain_registration.tomhesse_xyz tomhesse.xyz
tofu import module.dns.scaleway_domain_record.shrimphouse_xyz_ns_root_0 shrimphouse.xyz/<record-id>
tofu import module.dns.scaleway_domain_record.shrimphouse_xyz_ns_root_1 shrimphouse.xyz/<record-id>
```

To find the NS record IDs:

```sh
curl -s -H "X-Auth-Token: $SCW_SECRET_KEY" \
  "https://api.scaleway.com/domain/v2beta1/dns-zones/shrimphouse.xyz/records?type=NS"
```

The domain registration is imported by domain name. This requires Scaleway provider 2.84 or later;
before that only `<project-id>/<task-id>` worked, and registration tasks are archived after a while,
which can make that form unusable. On older providers the error message reads
`expected 'projectID/domainName'` but the ID is in fact parsed as a task ID — the message is wrong.

The registration resource needs `owner_contact_id` in `terraform.tfvars` — the ID of the existing
Scaleway contact that owns the domain, readable from `tofu state show` after the import. Since
OpenTofu evaluates variables before importing, pass it inline on the import command the first time:

```sh
tofu import -var 'owner_contact_id=<id>' \
  module.dns.scaleway_domain_registration.shrimphouse_xyz shrimphouse.xyz
```

The contact is referenced by ID rather than declared inline because the registrar API does not
return contact fields on read, and changing a registrant requires a domain trade — the provider
refuses the change and directs you to the Scaleway console.

### Key renewal

The API key has an expiration date set in `bootstrap/main.tf`. To renew, update the `expires_at` field and apply:

```sh
cd tofu/bootstrap
tofu apply
```

This will destroy the old key and create a new one. **Use a personal API key for this, not the
`infra-opentofu` key itself.** The application does have the permissions (organization-scope
`IAMManager`), but the replacement destroys before it creates, so renewing the key you are
authenticating with leaves the create step with no valid credentials.

Retrieve the new credentials and update all environments using the old key:

```sh
tofu output -raw access_key
tofu output -raw secret_key
```

## Usage

Needs `tofu/terraform.tfvars` (see [Getting started](#getting-started)).

```sh
cd tofu
tofu init
tofu plan
tofu apply
```
