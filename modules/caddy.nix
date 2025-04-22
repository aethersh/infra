{
  pkgs,
  unstablePkgs,
  lib,
  config,
  ...
}:
{
  age.secrets.cfDnsKey.file = ../secrets/cfDnsKey.age;
  system.activationScripts."caddy-secrets" = ''
    cloudflare_tls_api_key=$(cat "${config.age.secrets.cfDnsKey.path}")
    configFile=${config.services.caddy.configFile}
    ${pkgs.gnused}/bin/sed -i "s/@cloudflare_tls_api_key@/$cloudflare_tls_api_key/" "$configFile"
  '';

  services.caddy = {
    enable = true;
    package = (
      unstablePkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = "sha256-UwrkarDwfb6u+WGwkAq+8c+nbsFt7sVdxVAV9av0DLo=";
      }
    );
    globalConfig = builtins.readFile ./Caddyfile;
    virtualHosts."anycast.as215207.net" = {
      extraConfig = ''
        import cf-dns-v6
        respond "You have reached the anycast IPv6 address of AS215207: 2602:fbcf:df::1 \n This is being served by ${config.networking.hostName} in ${config.motd.location} \n Ping this server directly at 6.${config.networking.hostName}.as215207.net"
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
