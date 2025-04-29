{
  pkgs,
  unstable,
  lib,
  config,
  outputs,
  ...
}:
{
  options.ae.caddy = with lib; {
    enable = mkEnableOption {
      default = false;
      description = "Enable Caddy";
    };
  };

  config = lib.mkIf config.ae.caddy.enable {
    age.secrets.caddyEnvVars = {
      file = ../../secrets/caddyEnvVars.age;
      owner = "caddy";
      group = "caddy";
    };

    services.caddy = {
      enable = true;
      package = outputs.packages.x86_64-linux.caddy;
      extraConfig = builtins.readFile ./Caddyfile;
      logFormat = lib.mkForce ''
        level INFO
      '';
      virtualHosts = {
        "anycast.as215207.net" = {
          extraConfig = ''
            import cf-dns-v6
            respond "You have reached the anycast IPv6 address of AS215207: 2602:fbcf:df::1 . This is being served by ${config.networking.hostName}.as215207.net in ${config.motd.location}. Ping this server directly at 6.${config.networking.hostName}.as215207.net"
          '';
        };
        "${config.networking.hostName}.as215207.net" = {
          extraConfig = ''
            import cf-dns-v6
            respond "You have reached the service address of ${config.networking.hostName}.as215207.net in ${config.motd.location}. Try the AS215207 address at 6.${config.networking.hostName}.as215207.net"
          '';
        };
        "6.${config.networking.hostName}.as215207.net" = {
          extraConfig = ''
            import cf-dns-v6
            respond "You have reached the AS215207 IPv6 address of ${config.networking.hostName}.as215207.net in ${config.motd.location}"
          '';
        };
      };
    };
    # List that starts with an empty string forces systemd to "reset" instead of appending a second ExecStart value. This way, we replace the existing one
    systemd.services.caddy.serviceConfig.ExecStart = lib.mkForce [
      ""
      "${config.services.caddy.package}/bin/caddy run --config /etc/caddy/caddy_config --adapter caddyfile --envfile ${config.age.secrets.caddyEnvVars.path}"
    ];

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };

}
