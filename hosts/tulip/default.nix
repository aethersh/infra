{ ... }:

{
  imports = [
    ../../modules/common.nix

    ../../modules/blocky.nix
    ../../modules/chrony.nix
    ../../modules/globalping.nix
    ../../modules/pathvector.nix

    ./hardware-configuration.nix
  ];

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
