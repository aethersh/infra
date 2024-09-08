{
  description = "AetherNet's NixOS-based infrastructure";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    deploy-rs.url = "github:serokell/deploy-rs";
    agenix.url = "github:yaxitech/ragenix";
  };

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
      agenix,
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
        pete = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./hosts/pete
          ];
        };

        maple = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./hosts/maple
          ];
        };

        bay = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./hosts/bay
          ];
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
          modules = [
            agenix.nixosModules.default
            ./hosts/nova
          ];
        };

        strudel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./hosts/strudel
          ];
        };

        tulip = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./hosts/tulip
          ];
        };

        falaise = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./hosts/falaise
          ];
        };
      };

      deploy = {
        fastConnection = true;
        remoteBuild = true;
        user = "root";
        sshUser = "admin";

        nodes = {
          pete = {
            hostname = "pete.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.pete;
          };

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

          tulip = {
            hostname = "tulip.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.tulip;
          };

          falaise = {
            hostname = "falaise.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.falaise;
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
