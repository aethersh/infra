{ ... }:
{

  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  motd.location = "amsterdam, nl";

  networking = {
    hostName = "canal";
    interfaces.ens3 = {
      ipv4.addresses = [
        {
          address = "45.90.186.44";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a14:3f87:6ba0:21::a";
          prefixLength = 64;
        }

        {
          address = "2602:fbcf:df::1";
          prefixLength = 48;
        }
        {
          address = "2602:fbcf:dd::1";
          prefixLength = 48;
        }
      ];
    };

    defaultGateway = {
      address = "45.90.186.1";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "2a14:3f87:6ba0::1";
      interface = "ens3";
    };
  };

  ae = {
    caddy.enable = true;
    rpki = {
      enable = true;
      domain = "rpki.as215207.net";
    };
  };

  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "25.05";
  # ======================== DO NOT CHANGE THIS ========================
}
