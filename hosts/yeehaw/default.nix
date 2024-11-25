{ config, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];

  age.secrets.wgPrivKey = ../../secrets/yeehawWgPrivKey.age;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "yeehaw";

    interfaces = {
      # F4 Networks
      ens18 = {
        ipv4.addresses = [
          {
            address = "23.150.41.166";
            prefixLength = 27;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:02b7:40:65::166";
            prefixLength = 128;
          }
        ];
      };
      # F4IX
      ens19 = {
        ipv6.addresses = [
          {
            address = "2602:fa3d:f4:1::bf";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway = {
      address = "23.150.41.161";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:02b7:40:65::1";
      interface = "ens18";
    };

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wgPrivKey.path;
      ips = [
        "172.31.0.12/24"
        "2602:fbcf:dd:d4::/48"
      ];
    };
  };

  motd.location = "kansas city, us";

  # See options.pathvector in modules/pathvector.nix
  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
    routerId = "23.150.41.161";
  };

  metrics.node.enable = true;
  metrics.node.openFirewall = true;
  metrics.bird.enable = true;
  metrics.bird.openFirewall = true;
  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "23.05";
  # ======================== DO NOT CHANGE THIS ========================
}
