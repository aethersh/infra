{
  pkgs,
  unstable,
  lib,
  config,
  ...
}:
let
  caddyWithCfDns = unstable.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
    hash = "sha256-UwrkarDwfb6u+WGwkAq+8c+nbsFt7sVdxVAV9av0DLo=";
  };
in
{
  age.secrets.caddyEnvVars = {
    file = ../../secrets/caddyEnvVars.age;
    owner = "caddy";
    group = "caddy";
  };
  # system.activationScripts."caddy-secrets" = ''
  #   cloudflare_tls_api_key=$(cat "${config.age.secrets.cfDnsKey.path}")
  #   configFile=${config.services.caddy.configFile}
  #   ${pkgs.gnused}/bin/sed -i "s/@cloudflare_tls_api_key@/$cloudflare_tls_api_key/" "$configFile"
  # '';

  services.caddy = {
    enable = true;
    package = caddyWithCfDns;
    extraConfig = builtins.readFile ./Caddyfile;
    logFormat = lib.mkForce ''
    level INFO
    '';
    virtualHosts."anycast.as215207.net" = {
      extraConfig = ''
        import cf-dns-v6
        respond "You have reached the anycast IPv6 address of AS215207: 2602:fbcf:df::1 \n This is being served by ${config.networking.hostName} in ${config.motd.location} \n Ping this server directly at 6.${config.networking.hostName}.as215207.net"
      '';
    };
  };

  # systemd.services.caddy.serviceConfig.EnviromentFile = config.age.secrets.caddyEnvVars.path;

  # List that starts with an empty string forces systemd to "reset" instead of appending a second ExecStart value. This way, we replace the existing one
  systemd.services.caddy.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${caddyWithCfDns}/bin/caddy run --config /etc/caddy/caddy_config --adapter caddyfile --envfile ${config.age.secrets.caddyEnvVars.path}"
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
