{ config, lib, ... }:

let
  cfg = config.metrics;
in
{
  options.metrics = {
    node = {
      enable = lib.mkEnableOption { description = "Enable the node exporter"; };
      port = lib.mkOption {
        type = lib.types.int;
        default = 9100;
        description = "Port for the node exporter";
      };
      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open the firewall for the node exporter";
      };
    };
    bird = {
      enable = lib.mkEnableOption { description = "Enable the bird exporter"; };
      port = lib.mkOption {
        type = lib.types.int;
        default = 9324;
        description = "Port for the bird exporter";
      };
      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open the firewall for the bird exporter";
      };
    };
  };

  config =
    lib.mkIf cfg.node.enable {
      services.prometheus.exporters.node = {
        enable = true;
        port = cfg.node.port;
        openFirewall = cfg.node.openFirewall;
      };
    }
    // lib.mkIf cfg.bird.enable {
      services.prometheus.exporters.bird = {
        enable = true;
        port = cfg.bird.port;
        user = "bird";
        openFirewall = cfg.bird.openFirewall;
        birdVersion = 2;
      };
    };
}
