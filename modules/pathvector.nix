{
  pkgs,
  config,
  lib,
  ...
}:

let

  cfg = config.pathvector;
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
      enable = true;
      checkConfig = true;
      config = builtins.readFile ./bird-default.conf;
    };
  };

  systemd.services.pathvector = {
    description = "Run pathvector and regenerate on config change";
    wantedBy = [ "multi-user.target" ];
    reloadTriggers = [ config.environment.etc."pathvector.yml".source ];
    requires = [ "bird2.service" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.pathvector}/bin/pathvector generate && cp -f /etc/bird/bird.conf /etc/bird/bird2.conf";
      ExecReload = "${pkgs.pathvector}/bin/pathvector generate && cp -f /etc/bird/bird.conf /etc/bird/bird2.conf";
      Environment = "PATH=/bin:/sbin:/nix/var/nix/profiles/default/bin:${pkgs.bgpq4}/bin:${pkgs.bird}/bin:${pkgs.pathvector}/bin";
    };
  };
}
