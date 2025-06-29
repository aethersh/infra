{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.pathvector;
  caps = [
    "CAP_NET_ADMIN"
    "CAP_NET_BIND_SERVICE"
    "CAP_NET_RAW"
  ];
in
{
  options.services.pathvector = with lib; {
    enable = mkEnableOption {
      default = false;
      description = "Enable pathvector";
    };
    configFile = mkOption {
      type = types.path;
      default = ./pathvector.yml;
      description = "Pathvector configuration file";
    };
    enableAutoreload = mkEnableOption {
      default = true;
      description = "Enable autoreload of pathvector";
    };
    routerId = mkOption {
      description = "Router ID for BIRD";
      type = types.str;
    };
  };

  config = (
    lib.mkIf cfg.enable (
      let
        birdPkg = pkgs.bird2;
      in
      {
        environment.systemPackages = with pkgs; [
          bgpq4
          birdPkg
          pathvector
        ];

        environment.etc."pathvector.yml".source = pkgs.writeTextFile {
          name = "pathvector";
          text =
            ''
              bird-binary: ${birdPkg}/bin/bird
            ''
            + builtins.readFile cfg.configFile;
        };

        environment.etc."bird/bird.conf" = {
          source = ./bird-default.conf;
          mode = "0664";
        };
        # environment.etc."bird/bird.conf" = {
        #   source = pkgs.writeTextFile {
        #     name = "bird";
        #     text =
        #       ''
        #         router id ${cfg.routerId};
        #       ''
        #       + builtins.readFile ./bird-default.conf;
        #   };
        #   mode = "0664";
        # };

        environment.shellAliases = {
          pv = "pathvector";
        };

        networking.firewall.allowedTCPPorts = [ 179 ];

        systemd.services = {
          bird = {
            description = "BIRD Internet Routing Daemon";
            wantedBy = [ "multi-user.target" ];
            reloadTriggers = [ config.environment.etc."bird/bird.conf".source ];
            requires = [
              "network-online.target"
              "blocky.service"
            ];
            path = with pkgs; [
              birdPkg
              pathvector
              bgpq4
            ];
            serviceConfig = {
              Type = "forking";
              Restart = "on-failure";
              User = "bird";
              Group = "bird";
              ExecStart = "${birdPkg}/bin/bird -c /etc/bird/bird.conf";
              ExecReload = "${birdPkg}/bin/birdc configure";
              ExecStop = "${birdPkg}/bin/birdc down";
              RuntimeDirectory = "bird";
              CapabilityBoundingSet = caps;
              AmbientCapabilities = caps;
              ProtectSystem = "full";
              ProtectHome = "yes";
              ProtectKernelTunables = true;
              ProtectControlGroups = true;
              PrivateTmp = true;
              PrivateDevices = true;
              SystemCallFilter = "~@cpu-emulation @debug @keyring @module @mount @obsolete @raw-io";
              MemoryDenyWriteExecute = "yes";
            };
          };

          pathvector = {
            description = "Run pathvector and regenerate daily";
            wantedBy = [ "multi-user.target" ];
            reloadTriggers = [ config.environment.etc."pathvector.yml".source ];
            requires = [
              "bird.service"
              "blocky.service"
            ];
            path = with pkgs; [ bgpq4 ];
            serviceConfig = {
              Type = "forking"; # PV stays attached to console while it generates; Type="forking" means it will fail if pathvector fails
              ExecStart = "${pkgs.pathvector}/bin/pathvector generate -v";
              ExecReload = "${pkgs.pathvector}/bin/pathvector generate -v";
              RuntimeDirectory = "pathvector";
              TimeoutStartSec = 120; # Two minute delay to ensure it doesn't time out
            };
            startAt = "daily";
            preStart = "/usr/bin/env sleep 2"; # Blocky takes a second to start, pathvector fails if it can't resolve dns RIGHT NOW !!
          };
        };

        users = {
          users.bird = {
            description = "BIRD Internet Routing Daemon user";
            group = "bird";
            isSystemUser = true;
          };
          groups.bird = { };
        };
      }
    )
  );
}
