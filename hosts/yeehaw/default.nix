{ config, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];

  age.secrets.yeehawWgPrivkey.file = ../../secrets/yeehawWgPrivkey.age;

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

          {
            address = "2602:fbcf:d4::1";
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
            address = "2602:2b7:40:1::";
            prefixLength = 64;
            via = "2602:02b7:40:65::1";
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
      privateKeyFile = config.age.secrets.yeehawWgPrivkey.path;
      ips = [
        "172.31.0.7/24"
        "2602:fbcf:dd:d4::/48"
      ];
      peers = [
        {
          name = "bay";
          publicKey = "R6XggQejbqHF/l9rvgTJx5a/89Zw0Grd0pJ8OKwkXUE=";
          endpoint = "bay.as215207.net:60908";
          allowedIPs = [
            "172.31.0.8/32"
            "2602:fbcf:dd:d5::/64"
          ];
        }
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
        # {
        #   name = "yeehaw";
        #   endpoint = "yeehaw.as215207.net:60908";
        #   allowedIPs = [
        #     "172.31.0.7/32"
        #     "2602:fbcf:dd:d4::/64"
        #   ];
        #   publicKey = "BWvxchKyCm2LrXKkVFInjgGWqRVOTyUcKYDGcPpUdR4=";
        # }
      ];
    };
  };

  motd.location = "kansas city, us";

  # See options.pathvector in modules/pathvector.nix
  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };

  metrics.node.enable = true;
  metrics.node.openFirewall = true;
  metrics.bird.enable = true;
  metrics.bird.openFirewall = true;
  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "23.05";
  # ======================== DO NOT CHANGE THIS ========================
}
