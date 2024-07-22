{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionalString
    types
    ;

  configFormat = pkgs.formats.yaml { };

  cfg = config.services.pathvector;

in
{
  environment.systemPackages = with pkgs; [
    bgpq4
    bird
    pathvector
  ];

  options = {
    services.pathvector = {
      enable = mkEnableOption "pathvector";

      autoReload = mkOption {
        default = true;
        description = "Automatically regenerate pathvector configuration on changes";
        type = types.bool;
      };

      config = mkOption {
        description = ''
          Pathvector Configuration
        '';

        type = types.submodule {
          freeformType = configFormat.type;

          router-id = mkOption {

          };
        };
      };
    };
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
    };
  };
}
