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

  age.secrets.mapleWgPrivkey.file = ../../secrets/mapleWgPrivkey.age;

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

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.mapleWgPrivkey.path;
      ips = [
        "172.31.0.11/24"
        "2602:fbcf:dd:d8::/48"
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
            "172.31.0.12/32"
            "2602:fbcf:dd:d9::/64"
          ];
        }
        # {
        #   name = "maple";
        #   publicKey = builtins.readFile config.age.secrets.mapleWgPubkey.path;
        #   endpoint = "maple.as215207.net:51820";
        #   allowedIPs = [
        #     "172.31.0.11/32"
        #     "2602:fbcf:dd:d8::/64"
        #   ];
        # }
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
        {
          name = "tulip";
          endpoint = "tulip.as215207.net:51820";
          allowedIPs = [
            "172.31.0.14/32"
            "2602:fbcf:dd:db::/64"
          ];
          publicKey = builtins.readFile config.age.secrets.tulipWgPubkey.path;
        }
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

  motd.location = "toronto, on";

  metrics.node.enable = true;
  metrics.node.openFirewall = true;
  metrics.bird.enable = true;
  metrics.bird.openFirewall = true;

  # See options.pathvector in modules/pathvector.nix
  services.pathvector = {
    enable = true;
    configFile = ./pathvector.yml;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
