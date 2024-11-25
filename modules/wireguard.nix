{ config, lib, ... }:
let

  cfg = config.wireguard.interfaces.wg0;

in
{
  options.wg = with lib; {
    enable = mkEnableOption { description = "Enable the WireGuard service"; };
    privateKeyFile = mkOption {
      type = types.path;
      description = ''
        The path to the private key file.
      '';
    };
    ipv4 = mkOption {
      type = types.str;
      description = ''
        The IPv4 address to assign to the WireGuard interface.
      '';
    };
    ipv6 = mkOption {
      type = types.str;
      description = ''
        The IPv6 address to assign to the WireGuard interface.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 51820 ];
    networking.wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          privateKeyFile = cfg.privateKeyFile;
          ips = [
            cfg.ipv4
            cfg.ipv6
          ];
        };
      };
    };
  };
}
