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

  age.secrets.wgPrivKey = ../../secrets/peteWgPrivKey.age;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "pete";

    interfaces = {
      ens3 = {
        # Neptune Networks
        ipv4.addresses = [
          {
            address = "172.82.22.167";
            prefixLength = 26;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fe2e:4:8e:5c:52ff:fe90:c106";
            prefixLength = 48;
          }
        ];
      };
    };

    defaultGateway = {
      address = "172.82.22.129";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "fe80::216:3eff:fe71:5ecb";
      interface = "ens3";
    };

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wgPrivKey.path;
      ips = [ "172.31.0.9/24" ];
    };
  };

  motd.location = "new york, ny";

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
