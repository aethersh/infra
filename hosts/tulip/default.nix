{ config, ... }:

{
  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  age.secrets.tulipWgPrivkey.file = ../../secrets/tulipWgPrivkey.age;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "tulip";

    interfaces = {
      # Servperso Systems
      ens18 = {
        ipv4.addresses = [
          {
            address = "194.28.98.92";
            prefixLength = 27;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a0c:b640:8:92::1";
            prefixLength = 48;
          }
        ];
      };

      # LOCIX Netherlands
      ens19 = {
        ipv4.addresses = [
          {
            address = "185.1.138.49";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a0c:b641:700::a5:21:5207:1";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway = {
      address = "194.28.98.94";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2a0c:b640:8::ffff";
      interface = "ens18";
    };

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.tulipWgPrivkey.path;
      ips = [
        "172.31.0.14/24"
        "2602:fbcf:dd:db::/48"
      ];
      peers = [
        {
          name = "bay";
          publicKey = builtins.readFile config.age.secrets.bayWgPubkey.path;
          endpoint = "bay.as215207.net:51820";
          allowedIPs = [
            "172.31.0.8/32"
            "2602:fbcf:dd:d5::/64"
          ];
        }
        {
          name = "falaise";
          publicKey = builtins.readFile config.age.secrets.falaiseWgPubkey.path;
          endpoint = "falaise.as215207.net:51820";
          allowedIPs = [
            "172.31.0.1/32"
            "2602:fbcf:dd:d9::/64"
          ];
        }
        {
          name = "maple";
          publicKey = builtins.readFile config.age.secrets.mapleWgPubkey.path;
          endpoint = "maple.as215207.net:51820";
          allowedIPs = [
            "172.31.0.11/32"
            "2602:fbcf:dd:d8::/64"
          ];
        }
        {
          name = "pete";
          publicKey = builtins.readFile config.age.secrets.peteWgPubkey.path;
          endpoint = "pete.as215207.net:51820";
          allowedIPs = [
            "172.31.0.5/32"
            "2602:fbcf:dd:d6::/64"
          ];
        }
        {
          name = "strudel";
          endpoint = "strudel.as215207.net:51820";
          allowedIPs = [
            "172.31.0.16/32"
            "2602:fbcf:dd:de::/64"
          ];
          publicKey = builtins.readFile config.age.secrets.strudelWgPubkey.path;
        }
        # {
        #   name = "tulip";
        #   endpoint = "tulip.as215207.net:51820";
        #   allowedIPs = [
        #     "172.31.0.14/32"
        #     "2602:fbcf:dd:db::/64"
        #   ];
        #   publicKey = builtins.readFile config.age.secrets.tulipWgPubkey.path;
        # }
        {
          name = "yeehaw";
          endpoint = "yeehaw.as215207.net:51820";
          allowedIPs = [
            "172.31.0.7/32"
            "2602:fbcf:dd:d4::/64"
          ];
          publicKey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
        }
      ];
    };
  };

  motd.location = "meppel, nl";

  # See options.pathvector in modules/pathvector.nix
  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };
  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
