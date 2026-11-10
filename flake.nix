{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.opentofu
        ];

        shellHook = ''
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
