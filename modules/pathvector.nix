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
      text = "bird-binary: ${pkgs.bird}/bin/bird\n" + builtins.readFile cfg.configFile;
    };

    services.bird2 = {
      enable = false;
      # checkConfig = true;
      # config = builtins.readFile ./bird-default.conf;
    };

    systemd.services.pathvector = {
      description = "Run pathvector and regenerate on config change";
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = [ config.environment.etc."pathvector.yml".source ];
      requires = [ "bird2.service" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.pathvector}/bin/pathvector generate";
        ExecReload = "${pkgs.pathvector}/bin/pathvector generate";
        Environment = "PATH=/bin:/sbin:/nix/var/nix/profiles/default/bin:${pkgs.bgpq4}/bin:${pkgs.bird}/bin:${pkgs.pathvector}/bin";
      };
    };

    environment.etc."bird/bird.conf".source = ./bird-default.conf;

    # Custom bird systemd service ENTIRELY BECAUSE PATHVECTOR CANNOT WRITE TO A DIFFERENT GODDAMN FILE
    systemd.services.bird = {
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
