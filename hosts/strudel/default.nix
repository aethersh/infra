{ config, ... }:

{
  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  age.secrets.strudelWgPrivkey.file = ../../secrets/strudelWgPrivkey.age;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  ae.blocky.enable = false;

  networking = {
    hostName = "strudel";

    interfaces = {
      # Servperso Systems
      ens18 = {
        ipv4.addresses = [
          {
            address = "194.28.99.208";
            prefixLength = 27;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a0c:b640:10::208";
            prefixLength = 112;
          }

          {
            address = "2602:fbcf:de::1";
            prefixLength = 48;
          }
          {
            address = "2602:fbcf:df::1";
            prefixLength = 48;
          }
        ];
      };

      # LOCIX Dusseldorf
      ens19 = {
        ipv4.addresses = [
          {
            address = "185.1.155.145";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a0c:b641:701::a5:21:5207:1";
            prefixLength = 64;
          }
        ];
      };

      # LOCIX Frankfurt
      ens20 = {
        ipv4.addresses = [
          {
            address = "185.1.166.58";
            prefixLength = 23;
          }
        ];
        ipv6.addresses = [
          {
            address = "2001:7f8:f2:e1:a5:21:5207:1";
            prefixLength = 64;
          }
        ];
      };

      # Pixinko
      ens21 = {
        ipv6.addresses = [
          {
            address = "2a0c:b641:870::19";
            prefixLength = 64;
          }
        ];
      };
    };
    nameservers = [ "9.9.9.9" "1.1.1.1" ];

    defaultGateway = {
      address = "194.28.99.222";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2a0c:b640:10::ffff";
      interface = "ens18";
    };

    wireguard.enable = false;
    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.strudelWgPrivkey.path;
      ips = [
        "172.31.0.10/24"
        "fd00:215:207::1276/64"
      ];
      peers = [
        {
          name = "tulip";
          endpoint = "tulip.as215207.net:60908";
          allowedIPs = [
            "172.31.0.20/32"
            "fd00:215:207::528/128"
          ];
          publicKey = "OXdm485MJpI5923eHf5CUqcXjkkUCXkLGqRC4udLMAs=";
        }
      ];
    };
  };

  motd.location = "düsseldorf, de";

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
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
