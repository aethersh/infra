{ ... }:

{
  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "nova";
    wireguard.enable = false;
    interfaces = {
      ens18 = {
        # ParadoxNetworks
        ipv4.addresses = [
          {
            address = "192.67.33.7";
            prefixLength = 26;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fa7e:14::6";
            prefixLength = 64;
          }
        ];
      };

      ens19 = {
        # NVIX
        ipv6.addresses = [
          {
            address = "2001:504:125:e2::e";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway = {
      address = "192.67.33.1";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:fa7e:14::1";
      interface = "ens18";
    };
  };

  motd.location = "ashburn, va";

  # See options.pathvector in modules/pathvector.nix
  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };

  # See options.metrics in modules/prometheus.nix
  # metrics.node.enable = true;
  # metrics.node.openFirewall = true;
  # metrics.bird.enable = true;
  # metrics.bird.openFirewall = true;

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
