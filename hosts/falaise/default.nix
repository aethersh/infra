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

  networking = {
    hostName = "falaise";

    interfaces = {
      # Free Range Cloud
      ens18 = {
        ipv4.addresses = [
          {
            address = "23.154.81.115";
            prefixLength = 27;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fed2:fb0:68::";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway = {
      address = "23.154.81.97";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:fed2:fb0::1";
      interface = "ens18";
    };
  };

  motd.location = "vancouver, bc";

  # See options.pathvector in modules/pathvector.nix
  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
