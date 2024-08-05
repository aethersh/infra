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
    };

    defaultGateway = {
      address = "23.154.9.1";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:fa7e:10::1";
      interface = "ens18";
    };
  };

  motd.location = "toronto, on";
  
  metrics.node.enable = true;
  metrics.node.openFirewall = true;
  metrics.bird.enable = true;
  metrics.bird.openFirewall = true;

  # See options.pathvector in modules/pathvector.nix
  pathvector.configFile = ./pathvector.yml;

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
