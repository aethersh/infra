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

  age.secrets.peteWgPrivkey.file = ../../secrets/peteWgPrivkey.age;

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
          {
            address = "2602:fbcf:d0::1";
            prefixLength = 47;
          }
          {
            address = "2602:fbcf:df::1";
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

    wireguard.enable = true;
    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.peteWgPrivkey.path;
      ips = [
        "2602:fbcf:d0:beef::/64"
      ];
      peers = [
        {
          name = "pepacton-henrik";
          publicKey = "vxl2WJhIAdV3wz2i9G+vibxjA2rWVjL6/gHtYqf31gg=";
          persistentKeepalive = 15;
          allowedIPs = [
            "2602:fbcf:d0:bee5::/64"
          ];
        }
        # {
        #   name = "pete";
        #   publicKey = "UI+GluPRk0biKO+JITUDgOy+4b2LOw7x7TbhML/lC1Q=";
        #   endpoint = "pete.as215207.net:60908";
        #   allowedIPs = [
        #     "172.31.0.5/32"
        #     "2602:fbcf:dd:d6::/64"
        #   ];
        # }
      ];
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
