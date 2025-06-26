{
  description = "AetherNet's NixOS-based infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/b024ced1aac25639f8ca8fdfc2f8c4fbd66c48ef";

    deploy-rs.url = "github:serokell/deploy-rs";
    agenix.url = "github:yaxitech/ragenix";
    algae.url = "github:aethersh/algae";
  };

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
      agenix,
      ...
    }@inputs:
    let

      inherit (self) outputs;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });

      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      unstable = import inputs.unstable { inherit system; };

      deployPkgs = import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlays.default
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
      packages = forEachSystem (feSystem: import ./packages inputs.unstable.legacyPackages.${feSystem});

      overlays = import ./overlays { };

      nixosConfigurations =
        let
          specialArgs = {
            inherit system;
            inherit inputs outputs;
            inherit unstable;
          };
        in
        {
          pete = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              agenix.nixosModules.default
              ./hosts/pete
            ];
          };

          maple = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              agenix.nixosModules.default
              ./hosts/maple
            ];
          };

          bay = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
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
          yeehaw = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              agenix.nixosModules.default
              ./hosts/yeehaw
            ];
          };

          kier = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              agenix.nixosModules.default
              ./hosts/kier
            ];
          };

          nova = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              agenix.nixosModules.default
              ./hosts/nova
            ];
          };

          strudel = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              agenix.nixosModules.default
              ./hosts/strudel
            ];
          };

          tulip = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              agenix.nixosModules.default
              ./hosts/tulip
            ];
          };

          canal = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              agenix.nixosModules.default
              ./hosts/canal
            ];
          };

          falaise = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit specialArgs;
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

          # nova = {
          #   hostname = "nova.as215207.net";
          #   profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.nova;
          # };

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
          yeehaw = {
            hostname = "yeehaw.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.yeehaw;
          };
          kier = {
            hostname = "kier.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.kier;
          };
          canal = {
            hostname = "canal.as215207.net";
            profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.canal;
          };
        };
      };

      formatter = forEachSupportedSystem ({ pkgs }: pkgs.nixfmt-rfc-style);

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
