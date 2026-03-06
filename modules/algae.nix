{
  config,
  inputs,
  lib,
  system,
  pkgs,
  ...
}:
let
  cfg = config.ae.algae;
  algaePkg = inputs.algae.packages.${system}.algae;
in
with lib;
{
  options.ae.algae = {
    enable = mkEnableOption "Enable the Algae Looking Glass";
    location = mkOption {
      type = types.str;
      default = config.motd.location;
    };
    testIPv6Address = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable (
    let
      systemLgDomain = "lg.${config.networking.hostName}.as215207.net";
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
          bird2
        ];
        description = "Algae Looking Glass";
        wantedBy = [ "multi-user.target" ];
        environment = {
          ALGAE_ALLOWED_ORIGINS = "http://lg.as215207.net,https://${systemLgDomain}";
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
            Type = "exec";
            Restart = "on-failure";
            User = "algae";
            Group = "algae";
            ExecStart = "${algaePkg}/bin/algae";
            CapabilityBoundingSet = caps;
            AmbientCapabilities = caps;
          };
      };

      services.caddy.virtualHosts = {
        "${systemLgDomain}" = {
          extraConfig = ''
            import cf-dns-v6
            reverse_proxy localhost:2152
          '';
        };
      };

    }
  );
}
