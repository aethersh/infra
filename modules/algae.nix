{
  config,
  inputs,
  lib,
  system,
  ...
}:
let
  cfg = config.algae;
  algaePkg = inputs.algae.packages.${system}.algae;
in
with lib;
{
  options.algae = {
    enable = mkEnableOption "Enable the Algae Looking Glass";
    location = mkOption {
      type = types.string;
      default = config.motd.location;
    };
    testIPv6Address = mkOption {
      type = types.string;
      default = "";
    };
  };

  config = mkIf cfg.enable (
    let
      systemLgDomain = "https://lg.${config.networking.hostname}.as215207.net";
    in
    {
      users = {
        users.algae = {
          isSystemUser = true;
          group = "algae";
          extraGroups = [ "bird" ];
        };
        groups.algae = { };
      };

      systemd.services.algae = {
        requires = [
          "network-online.target"
          "blocky.service"
        ];
        path = with pkgs; [
          mtr
          inetutils
        ];
        description = "Algae Looking Glass";
        wantedBy = [ "multi-user.target" ];
        environment = {
          ALGAE_ALLOWED_ORIGINS = "http://lg.as215207.net,${systemLgDomain}";
          ALGAE_DOMAIN = "as215207.net";
          ALGAE_TEST_V6 = cfg.testIPv6Address;
          ALGAE_LOCATION = cfg.location;
        };
        serviceConfig =
          let
            caps = [
              "CAP_NET_ADMIN"
              "CAP_NET_BIND_SERVICE"
              "CAP_NET_RAW"
            ];
          in
          {
            Type = "forking";
            Restart = "on-failure";
            User = "algae";
            Group = "algae";
            ExecStart = "${algaePkg}/bin/algae";
            CapabilityBoundingSet = caps;
            AmbientCapabilities = caps;
          };
      };
    }
  );
}
