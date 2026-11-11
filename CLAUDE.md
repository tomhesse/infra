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
tofu output -json iam_secret_keys | jq -r '.["tem-immich"]'   # read one service's secret
```

There is no test suite; `tofu fmt`, `tofu validate`, and `tofu plan` are the full feedback loop.

## Two separate root modules

- `tofu/` — the main root module. Remote state in the `infra-tofu-state` Scaleway bucket (`nl-ams`), configured in [backend.tf](tofu/backend.tf). Runs with the `infra-opentofu` application credentials.
- `tofu/bootstrap/` — a standalone root module with **local state** (gitignored, so applying it is effectively one-shot). It creates the `infra-opentofu` IAM application, its policy, and its API key. Apply it with a *personal* Scaleway key, not the `infra-opentofu` key. On the very first run nothing
else exists yet; afterwards the reason is self-reference — `infra-opentofu` does hold organization-scope
`IAMManager` and so has the permissions, but renewing its own key destroys the credential mid-apply and
the follow-up create then has nothing to authenticate with. The module hardcodes the organization/project
ID inline rather than using variables.

The chicken-and-egg ordering (bootstrap IAM → create state bucket with local state → `tofu init -migrate-state`) and the DNS import commands are documented in [README.md](README.md). Don't re-derive them.

## Module conventions

Child modules under `tofu/modules/` declare `required_providers` in their own `providers.tf` **without version constraints**; versions are pinned only in [tofu/providers.tf](tofu/providers.tf). Those pins are **exact**, not ranges, so every provider bump arrives as a reviewable Renovate PR — a breaking change once slipped in through a `~> 2.0` range and was only caught at plan time. `tofu/bootstrap/` pins separately and has its own lock file; it currently trails the root module. No module takes an explicit `providers` block, so all of them inherit the root's default provider instances (including `organization_id`/`project_id`/`region`).

The `dns` module has no `main.tf`; its resources are split one file per domain
([shrimphouse_xyz.tf](tofu/modules/dns/shrimphouse_xyz.tf), [tomhesse_xyz.tf](tofu/modules/dns/tomhesse_xyz.tf)).
Records are deliberately one explicit resource each, never a `for_each` over a records map — a map key
rename would destroy and recreate live MX/SPF/DKIM records.

`modules/iam` is a generic factory — one Scaleway IAM application + policy + API key per instantiation. The root module instantiates it once with `for_each` over `local.iam_keys`, so instances are addressed as `module.iam["tem-immich"]`. Its API key sets `create_before_destroy`, because `expires_at` is `ForceNew` and a rotation would otherwise leave a moment with no valid key.

### Adding a per-service API key

One edit: add an entry to `local.iam_keys` in [tofu/main.tf](tofu/main.tf), keyed by application name
(`tem-<service>` or `acme-<service>`) with the permission set as the value. Outputs are derived, so
there is nothing to add in [tofu/outputs.tf](tofu/outputs.tf). Commit as
`feat(iam): add TEM API key for <service>`.

The map key becomes the `for_each` key, so **renaming a key destroys and recreates that application,
policy, and API key** — the new credentials then have to be redistributed. Treat the keys as stable.

This used to be three edits that all had to agree, which produced a real bug (commit `0b6cb43`,
"use correct module output for sabnzbd", where one service's outputs pointed at another's module).
That class of mistake is now impossible.

Permission sets in use: `DomainsDNSFullAccess` for ACME/DNS-01 keys, `TransactionalEmailEmailFullAccess` for mail-sending keys.

## TEM ↔ DNS wiring

The Transactional Email domain (`mail.shrimphouse.xyz`) is created with `autoconfig = false`, so its SPF/DKIM/DMARC/MX records are managed explicitly by the `dns` module instead of by Scaleway. The values flow `modules/tem` outputs → the `tem = { … }` object passed to the `dns` module in [tofu/main.tf](tofu/main.tf) → `var.tem.*` in [modules/dns/shrimphouse_xyz.tf](tofu/modules/dns/shrimphouse_xyz.tf). Adding a TEM-derived record means threading a new field through all three places.

The MX record uses `mx_config` (hostname) and `mx_priority` (number) as separate values. Before Scaleway provider 2.84, `mx_config` returned both joined by a space and had to be split; that form is gone.

Note the root zone already carries mailbox.org mail records (SPF, MX, four DKIM CNAMEs, DMARC); TEM records live under the `mail` subdomain and must not clash with them.

## Protected resources

The state bucket ([modules/storage](tofu/modules/storage/main.tf)) and the Storage Box ([modules/storagebox](tofu/modules/storagebox/main.tf)) both carry `prevent_destroy`, and the Storage Box also has `delete_protection = true` plus `ignore_changes = [ssh_keys]`. Destroying either requires deliberately removing those guards; don't do it as a side effect of another change.

## Secrets

`tofu/terraform.tfvars` is gitignored and holds the organization/project IDs, the Storage Box root password, and the `storagebox_subaccounts` map (per-service passwords and home directories). Subaccounts are keyed by service name via `for_each`, so renaming a key destroys and recreates that subaccount.

## Commits

Conventional Commits with a scope drawn from the area touched: `iam`, `dns`, `tem`, `bootstrap`, `hcloud`, `tofu`, `nix`, or none for `docs`/`chore`.
