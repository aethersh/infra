{
  description = "AetherNet's NixOS-based infrastructure";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      deployPkgs = import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlay
          (self: super: {
            deploy-rs = {
              inherit (pkgs) deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
      };
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations = {
        # pete = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/pete ];
        # };
        #
        # maple = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/maple ];
        # };
        #
        # bay = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/bay ];
        # };
        #
        # zurich = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/zurich ];
        # };
        #
        # yeehaw = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/yeehaw ];
        # };

        nova = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/nova ];
        };
      };

      deploy = {
        fastConnection = true;
        remoteBuild = true;
        user = "root";
        sshUser = "admin";

        nodes = {
          nova = {
            hostname = "nova.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos
              self.nixosConfigurations.nova;
          };
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
