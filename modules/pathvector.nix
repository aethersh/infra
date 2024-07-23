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
  environment.systemPackages = with pkgs; [
    bgpq4
    bird
    pathvector
  ];

  options.pathvector = {
    configFile = lib.mkOption {
      type = with lib.types; path;
      default = ./pathvector.yml;
      description = "Pathvector configuration file";
    };
  };

  config = {
    environment.etc."pathvector.yml".source = pkgs.writeTextFile {
      name = "pathvector";
      text = ''
        bird-binary: ${pkgs.bird}/bin/bird
      '' ++ builtins.readFile cfg.configFile;
    };

    services.bird2 = {
      enable = true;
      checkConfig = true;
      config = builtins.readFile ./bird-default.conf;
    };
  };

  # systemd.services.pathvector = {
  #   description = "Run pathvector and regenerate on config change";
  #   wantedBy = [ "multi-user.target" ];
  #   reloadTriggers = [ config.environment.etc."pathvector.yml".source ];
  #   requires = [ "bird2.service" ];
  #   serviceConfig = {
  #     Type = "forking";
  #     ExecStart = "${pkgs.pathvector}/bin/pathvector generate";
  #     ExecReload = "${pkgs.pathvector}/bin/pathvector generate";
  #   };
  # };
}
