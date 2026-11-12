{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, git-hooks-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      pre-commit = git-hooks-nix.lib.${system}.run {
        src = ./.;

        hooks = {
          # Commits
          convco.enable = true;

          # Misc
          check-added-large-files.enable = true;
          check-case-conflicts.enable = true;
          check-merge-conflicts.enable = true;

          # Nix
          deadnix.enable = true;
          nixfmt.enable = true;
          statix.enable = true;

          # Secrets
          detect-private-keys.enable = true;
          ripsecrets = {
            enable = true;
            excludes = [ "\\.pub$" ];
          };

          # Refuse the files .gitignore is only advisory about. Their contents
          # are passwords and state, which no pattern-based scanner will catch.
          forbid-secret-files = {
            enable = true;
            name = "forbid committing tfvars or tfstate";
            entry = toString (
              pkgs.writeShellScript "forbid-secret-files" ''
                echo "refusing to commit secret-bearing files:" >&2
                printf '  %s\n' "$@" >&2
                exit 1
              ''
            );
            files = "(^|/)terraform\\.tfvars$|\\.tfstate(\\.backup)?$";
          };

          # OpenTofu, not Terraform, so this is not the built-in hook.
          tofu-fmt = {
            enable = true;
            name = "tofu fmt";
            entry = "${pkgs.opentofu}/bin/tofu fmt -recursive tofu";
            files = "\\.tf$";
            pass_filenames = false;
          };
        };
      };
    in
    {
      checks.${system}.pre-commit = pre-commit;

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.opentofu
        ]
        ++ pre-commit.enabledPackages;

        shellHook = pre-commit.shellHook + ''
          if [ -z "''${SCW_ACCESS_KEY:-}" ]; then
            read -rp "Scaleway Access Key: " SCW_ACCESS_KEY
          fi
          if [ -z "''${SCW_SECRET_KEY:-}" ]; then
            read -rsp "Scaleway Secret Key: " SCW_SECRET_KEY
            echo
          fi
          if [ -z "''${HCLOUD_TOKEN:-}" ]; then
            read -rsp "Hetzner Cloud API Token: " HCLOUD_TOKEN
            echo
          fi

          export SCW_ACCESS_KEY
          export SCW_SECRET_KEY
          export AWS_ACCESS_KEY_ID="$SCW_ACCESS_KEY"
          export AWS_SECRET_ACCESS_KEY="$SCW_SECRET_KEY"
          export HCLOUD_TOKEN
        '';
      };
    };
}
