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

          {
            address = "2602:fbcf:db::1";
            prefixLength = 48;
          }
          {
            address = "2602:fbcf:df::1";
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

    wireguard.enable = true;
    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.tulipWgPrivkey.path;
      ips = [
        "172.31.0.20/24"
        "fd:215:207::528/64"
      ];
      peers = [
        {
          name = "strudel";
          endpoint = "strudel.as215207.net:60908";
          allowedIPs = [
            "172.31.0.10/32"
            "fd:215:207::1276/128"
          ];
          publicKey = "Q/uu+7+gMFT57LkFH4tu1bMrfQSuYiR/OALmR/oJaBY=";
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
