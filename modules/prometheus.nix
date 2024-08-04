{ config, lib, ... }:

let
  cfg = config.metrics;
in
{
  options.metrics = {
    node = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the node exporter";
      };
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
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the bird exporter";
      };
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

  config = {
    services.prometheus.exporters.node = {
      enable = cfg.metrics.node.enable;
      port = cfg.metrics.node.port;
      openFirewall = cfg.metrics.node.openFirewall;
    };

    services.prometheus.exporters.bird = {
      enable = cfg.metrics.bird.enable;
      port = cfg.metrics.bird.port;
      openFirewall = cfg.metrics.bird.openFirewall;
      birdVersion = 2;
    };
  };
}
