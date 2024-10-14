{ config, lib, ... }:
{
  options.wg = with lib; {
    enable = mkEnableOption { description = "Enable the WireGuard service"; };
  };

  config = lib.mkIf config.wg.enable {
    networking.firewall.allowedUDPPorts = [ 51820 ];
    networking.wireguard.interfaces.wg0 = { };
  };
}
