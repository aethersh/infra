{ config, ... }:

{
  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  age.secrets.wgPrivKey = ../../secrets/bayWgPrivKey.age;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "bay";

    interfaces = {
      ens18 = {
        # ParadoxNetworks
        ipv4.addresses = [
          {
            address = "23.154.8.24";
            prefixLength = 26;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fa7e:12::47";
            prefixLength = 64;
          }
        ];
      };

      ens19 = {
        # FREMIX
        ipv6.addresses = [
          {
            address = "2001:504:125:e0::de";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway = {
      address = "23.154.8.1";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:fa7e:12::1";
      interface = "ens18";
    };

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wgPrivKey.path;
      ips = [ "172.31.0.6/24" ];
    };
  };

  motd.location = "fremont, ca";

  # See options.pathvector in modules/pathvector.nix
  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
