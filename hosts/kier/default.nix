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

  motd.location = "kansas city";

  networking = {
    hostName = "kier";
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "23.143.82.38";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2602:fc26:12:1::38";
          prefixLength = 48;
        }
        
        {
          address = "2602:fbcf:df::1";
          prefixLength = 48;
        }
        {
          address = "2602:fbcf:d4::1";
          prefixLength = 48;
        }
      ];
    };

    defaultGateway = {
      address = "23.143.82.1";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:fc26:12::1";
      interface = "ens18";
    };
  };

  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.11";
  # ======================== DO NOT CHANGE THIS ========================
}
