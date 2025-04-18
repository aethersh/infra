{ config, ... }:

{
  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  age.secrets.bayWgPrivkey.file = ../../secrets/bayWgPrivkey.age;

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

          {
            address = "2602:fbcf:d5::1";
            prefixLength = 48;
          }
          {
            address = "2602:fbcf:df::1";
            prefixLength = 48;
          }
        ];

        # Upstream route
        ipv6.routes = [
          {
            address = "2606:fa7e:13::";
            prefixLength = 48;
            via = "2602:fa7e:12::1";
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
      privateKeyFile = config.age.secrets.bayWgPrivkey.path;
      ips = [
        "172.31.0.8/24"
        "2602:fbcf:dd:d5::/48"
      ];
      peers = [
        # {
        #   name = "bay";
        #   publicKey = "R6XggQejbqHF/l9rvgTJx5a/89Zw0Grd0pJ8OKwkXUE=";
        #   endpoint = "bay.as215207.net:60908";
        #   allowedIPs = [
        #     "172.31.0.8/32"
        #     "2602:fbcf:dd:d5::/64"
        #   ];
        # }
        {
          name = "falaise";
          publicKey = "F80L40pvu3N7pP9EXGS+SbP20NH6z+rHbcOHYBnQwg8=";
          endpoint = "falaise.as215207.net:60908";
          allowedIPs = [
            "172.31.0.12/32"
            "2602:fbcf:dd:d9::/64"
          ];
        }
        {
          name = "maple";
          publicKey = "FcSTiNO/GrPeTqfIcHrpOGQks324suM4QcdbGOM1igc=";
          endpoint = "maple.as215207.net:60908";
          allowedIPs = [
            "172.31.0.11/32"
            "2602:fbcf:dd:d8::/64"
          ];
        }
        {
          name = "pete";
          publicKey = "UI+GluPRk0biKO+JITUDgOy+4b2LOw7x7TbhML/lC1Q=";
          endpoint = "pete.as215207.net:60908";
          allowedIPs = [
            "172.31.0.5/32"
            "2602:fbcf:dd:d6::/64"
          ];
        }
        {
          name = "strudel";
          endpoint = "strudel.as215207.net:60908";
          allowedIPs = [
            "172.31.0.16/32"
            "2602:fbcf:dd:de::/64"
          ];
          publicKey = "Q/uu+7+gMFT57LkFH4tu1bMrfQSuYiR/OALmR/oJaBY=";
        }
        {
          name = "tulip";
          endpoint = "tulip.as215207.net:60908";
          allowedIPs = [
            "172.31.0.14/32"
            "2602:fbcf:dd:db::/64"
          ];
          publicKey = "OXdm485MJpI5923eHf5CUqcXjkkUCXkLGqRC4udLMAs=";
        }
        {
          name = "yeehaw";
          endpoint = "yeehaw.as215207.net:60908";
          allowedIPs = [
            "172.31.0.7/32"
            "2602:fbcf:dd:d4::/64"
          ];
          publicKey = "BWvxchKyCm2LrXKkVFInjgGWqRVOTyUcKYDGcPpUdR4=";
        }
      ];
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
