{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.caddy = {
    enable = true;
    package = (
      pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = lib.fakeHash;
      }
    );
    virtualHosts."anycast.as215207.net" = {
      extraConfig = ''
        respond "You have reached the anycast IPv6 address of AS215207: 2602:fbcf:df::1 \n This is being served by ${config.networking.hostName} in ${config.motd.location} \n Ping this server directly at 6.${config.networking.hostName}.as215207.net"
      '';
    };

  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
