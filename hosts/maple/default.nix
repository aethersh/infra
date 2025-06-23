{ config, ... }:

{
  imports = [
    ../../modules/common.nix

    ../../modules/blocky.nix
    ../../modules/chrony.nix
    ../../modules/globalping.nix
    ../../modules/pathvector.nix

    ./hardware-configuration.nix
  ];

  age.secrets.mapleWgPrivkey.file = ../../secrets/mapleWgPrivkey.age;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "maple";

    interfaces = {
      ens18 = {
        # ParadoxNetworks
        ipv4.addresses = [
          {
            address = "23.154.9.40";
            prefixLength = 26;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fa7e:10::4a";
            prefixLength = 64;
          }

          {
            address = "2602:fbcf:d8::1";
            prefixLength = 48;
          }
          {
            address = "2602:fbcf:df::1";
            prefixLength = 48;
          }
        ];
      };

      ens19 = {
        # ONIX
        ipv6.addresses = [
          {
            address = "2001:504:125:e1::bca";
            prefixLength = 64;
          }
        ];
      };

      # bird0 = {
      #   ipv6.addresses = [
      #     {
      #       address = "2602:fbcf:d8::1";
      #       prefixLength = 128;
      #     }
      #   ];
      #   ipv6.routes = [{
      #     type = "local";
      #     address = "2602:fbcf:d8::";
      #       prefixLength = 48;
      #   }];
      # };
    };

    defaultGateway = {
      address = "23.154.9.1";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:fa7e:10::1";
      interface = "ens18";
    };

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.mapleWgPrivkey.path;
      ips = [
        "172.31.0.11/24"
        "2602:fbcf:dd:d8::/48"
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
        # {
        #   name = "maple";
        #   publicKey = "FcSTiNO/GrPeTqfIcHrpOGQks324suM4QcdbGOM1igc=";
        #   endpoint = "maple.as215207.net:60908";
        #   allowedIPs = [
        #     "172.31.0.11/32"
        #     "2602:fbcf:dd:d8::/64"
        #   ];
        # }
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

  motd.location = "toronto, on";
  ae = {
    caddy.enable = true;
    algae = {
      enable = true;
      testIPv6Address = "2602:fbcf:d8::1";
    };
  };

  metrics.node.enable = true;
  metrics.node.openFirewall = true;
  metrics.bird.enable = true;
  metrics.bird.openFirewall = true;

  # See options.pathvector in modules/pathvector.nix
  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
