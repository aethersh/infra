{
  description = "AetherNet's NixOS-based infrastructure";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
      ...
    }:
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
    in
    {
      nixosConfigurations = {
        # pete = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/pete ];
        # };

        maple = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/maple ];
        };

        bay = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/bay ];
        };

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

        strudel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/strudel ];
        };
      };

      deploy = {
        fastConnection = true;
        remoteBuild = true;
        user = "root";
        sshUser = "admin";

        nodes = {
          maple = {
            hostname = "maple.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.maple;
          };

          bay = {
            hostname = "bay.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.bay;
          };

          nova = {
            hostname = "nova.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.nova;
          };

          strudel = {
            hostname = "strudel.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.strudel;
          };
        };
      };

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
        aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
