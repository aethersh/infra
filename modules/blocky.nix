{
  pkgs,
  lib,
  config,
  ...
}:
let

  cfg = config.ae.blocky;
in

{
  options.ae.blocky = with lib; {
    enable = mkEnableOption "Enable blocky dns";
  };

  config =
    with lib;
    mkIf cfg.enable {
      networking = {
        nameservers = [
          "127.0.0.1"
          "::1"
        ];
      };

      services.blocky = {
        enable = true;
        settings = {
          upstreams.groups.default = [
            "https://ordns.he.net/dns-query"
            "https://dns10.quad9.net/dns-query"
            "https://cloudflare-dns.com/dns-query"
            "https://dns.google/dns-query"
            "https://dns.mullvad.net/dns-query"
            "https://freedns.controld.com/p0"
            "https://unfiltered.adguard-dns.com/dns-query"
            "https://wikimedia-dns.org/dns-query"
          ];
          bootstrapDns = [
            {
              upstream = "https://ordns.he.net/dns-query";
              ips = [
                "74.82.42.42"
                "2001:470:20::2"
              ];
            }
            {
              upstream = "https://dns10.quad9.net/dns-query";
              ips = [
                "9.9.9.10"
                "149.112.112.10"
                "2620:fe::10"
                "2620:fe::fe:10"
              ];
            }
          ];
          caching.prefetching = true;
          customDNS = {
            mapping = {
              "pete.wg" = "172.31.0.5,2602:fbcf:dd:d0::";
              "yeehaw.wg" = "172.31.0.7,2602:fbcf:dd:d4::";
              "bay.wg" = "172.31.0.8,2602:fbcf:dd:d5::";
              "maple.wg" = "172.31.0.11,2602:fbcf:dd:d8::";
              "falaise.wg" = "172.31.0.12,2602:fbcf:dd:d9::";
              "tulip.wg" = "172.31.0.14,2602:fbcf:dd:db::";
              "nova.wg" = "172.31.0.15,2602:fbcf:dd:dc::";
              "strudel.wg" = "172.31.0.16,2602:fbcf:dd:de::";
            };
          };
        };
      };

      systemd.services = {
        blocky = {
          description = "A DNS proxy and ad-blocker for the local network";
          requires = [ "network-online.target" ];
        };
        blocky-healthchecker = {
          description = "Check the health of the Blocky DNS service";
          requires = [ "blocky.service" ];
          serviceConfig = {
            Type = "oneshot";
          };
          script = with pkgs; ''
            ${ldns}/bin/drill cache.nixos.org

            if [ $? -ne 0 ]; then
              # Give it another chance
              sleep 5
              ${ldns}/bin/drill cache.nixos.org

              if [ $? -ne 0 ]; then
                systemctl restart blocky.service
                echo "Blocky was unhealthy and has been restarted"
              fi
            else
              echo "Blocky is healthy"
            fi
          '';
          startAt = "hourly";
        };
      };

      # services.cron.systemCronJobs = [ "0 0,12 * * * root systemctl restart blocky.service" ];
    };
}
