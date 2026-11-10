# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Homelab infrastructure as code, managed with OpenTofu. Two cloud providers: Scaleway (DNS, object storage, IAM, Transactional Email) and Hetzner Cloud (Storage Box, SSH keys). The single domain is `shrimphouse.xyz`.

## Commands

All OpenTofu work needs credentials, which come from the Nix dev shell:

```sh
nix develop   # prompts for Scaleway access/secret key and Hetzner Cloud token
```

The shell hook exports `SCW_ACCESS_KEY`/`SCW_SECRET_KEY`, mirrors them into `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` (the S3 backend uses the same Scaleway keys), and exports `HCLOUD_TOKEN`.

```sh
cd tofu
tofu fmt -recursive       # formatting — run before committing
tofu validate             # offline-ish syntax/type check
tofu plan
tofu apply
tofu output -raw <name>   # read a sensitive output, e.g. tem_immich_secret_key
```

There is no test suite; `tofu fmt`, `tofu validate`, and `tofu plan` are the full feedback loop.

## Two separate root modules

- `tofu/` — the main root module. Remote state in the `infra-tofu-state` Scaleway bucket (`nl-ams`), configured in [backend.tf](tofu/backend.tf). Runs with the `infra-opentofu` application credentials.
- `tofu/bootstrap/` — a standalone root module with **local state** (gitignored, so applying it is effectively one-shot). It creates the `infra-opentofu` IAM application, its policy, and its API key. Requires a *personal* Scaleway key with organization-level IAM permissions, and hardcodes the organization/project ID inline rather than using variables.

The chicken-and-egg ordering (bootstrap IAM → create state bucket with local state → `tofu init -migrate-state`) and the DNS import commands are documented in [README.md](README.md). Don't re-derive them.

## Module conventions

Child modules under `tofu/modules/` declare `required_providers` in their own `providers.tf` **without version constraints**; versions are pinned only in [tofu/providers.tf](tofu/providers.tf). No module takes an explicit `providers` block, so all of them inherit the root's default provider instances (including `organization_id`/`project_id`/`region`).

`modules/iam` is a generic factory — one Scaleway IAM application + policy + API key per instantiation. The root module instantiates it once per consumer service, named `iam_<purpose>_<service>` (`iam_tem_immich`, `iam_acme_mimir`, …).

### Adding a per-service API key

Three edits, and all three must agree on the service name:

1. A `module "iam_tem_<service>"` block in [tofu/main.tf](tofu/main.tf) (copy an existing one; `expires_at` comes from `local.iam_key_expires_at`, so leave that line alone).
2. `tem_<service>_access_key` and `tem_<service>_secret_key` outputs in [tofu/outputs.tf](tofu/outputs.tf), both `sensitive = true`.
3. Commit as `feat(iam): add TEM API key for <service>`.

Copy-paste in the outputs file has produced a real bug before (commit `0b6cb43`, "use correct module output for sabnzbd") — verify each new output references its own module.

Permission sets in use: `DomainsDNSFullAccess` for ACME/DNS-01 keys, `TransactionalEmailEmailFullAccess` for mail-sending keys.

## TEM ↔ DNS wiring

The Transactional Email domain (`mail.shrimphouse.xyz`) is created with `autoconfig = false`, so its SPF/DKIM/DMARC/MX records are managed explicitly by the `dns` module instead of by Scaleway. The values flow `modules/tem` outputs → the `tem = { … }` object passed to the `dns` module in [tofu/main.tf](tofu/main.tf) → `var.tem.*` in [modules/dns/main.tf](tofu/modules/dns/main.tf). Adding a TEM-derived record means threading a new field through all three places.

The MX record uses `mx_config` (hostname) and `mx_priority` (number) as separate values. Before Scaleway provider 2.84, `mx_config` returned both joined by a space and had to be split; that form is gone.

Note the root zone already carries mailbox.org mail records (SPF, MX, four DKIM CNAMEs, DMARC); TEM records live under the `mail` subdomain and must not clash with them.

## Protected resources

The state bucket ([modules/storage](tofu/modules/storage/main.tf)) and the Storage Box ([modules/storagebox](tofu/modules/storagebox/main.tf)) both carry `prevent_destroy`, and the Storage Box also has `delete_protection = true` plus `ignore_changes = [ssh_keys]`. Destroying either requires deliberately removing those guards; don't do it as a side effect of another change.

## Secrets

`tofu/terraform.tfvars` is gitignored and holds the organization/project IDs, the Storage Box root password, and the `storagebox_subaccounts` map (per-service passwords and home directories). Subaccounts are keyed by service name via `for_each`, so renaming a key destroys and recreates that subaccount.

## Commits

Conventional Commits with a scope drawn from the area touched: `iam`, `dns`, `tem`, `bootstrap`, `hcloud`, `tofu`, `nix`, or none for `docs`/`chore`.
