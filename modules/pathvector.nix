{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.pathvector;
  caps = [
    "CAP_NET_ADMIN"
    "CAP_NET_BIND_SERVICE"
    "CAP_NET_RAW"
  ];
in
{
  options.pathvector = {
    configFile = lib.mkOption {
      type = with lib.types; path;
      default = ./pathvector.yml;
      description = "Pathvector configuration file";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      bgpq4
      bird
      pathvector
    ];

    environment.etc."pathvector.yml".source = pkgs.writeTextFile {
      name = "pathvector";
      text =
        ''
          bird-binary: ${pkgs.bird}/bin/bird
        ''
        + builtins.readFile cfg.configFile;
    };

    environment.etc."bird/bird.conf" = {
      source = ./bird-default.conf;
      mode = "0664";
    };

    systemd.services = {
      bird = {
        description = "BIRD Internet Routing Daemon";
        wantedBy = [ "multi-user.target" ];
        reloadTriggers = [ config.environment.etc."bird/bird.conf".source ];
        serviceConfig = {
          Type = "forking";
          Restart = "on-failure";
          User = "bird";
          Group = "bird";
          ExecStart = "${pkgs.bird}/bin/bird -c /etc/bird/bird.conf";
          ExecReload = "${pkgs.bird}/bin/birdc configure";
          ExecStop = "${pkgs.bird}/bin/birdc down";
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
        requires = [ "bird.service" ];
        path = with pkgs; [ bgpq4 ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${pkgs.pathvector}/bin/pathvector generate";
          ExecReload = "${pkgs.pathvector}/bin/pathvector generate";
          RuntimeDirectory = "pathvector";
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
  };
}
