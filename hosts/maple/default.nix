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

  age.secrets.wgPrivKey = ../../secrets/mapleWgPrivKey.age;

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
      privateKeyFile = config.age.secrets.wgPrivKey.path;
      ips = [
        "172.31.0.8/24"
        "2602:fbcf:dd:d8::/48"
      ];
    };
  };

  services.wgautomesh.settings.peers = [
    {
      endpoint = "bay.as215207.net:51820";
      address = "172.31.0.6";
      pubkey = builtins.readFile config.age.secrets.bayWgPubkey.path;
    }
    {
      endpoint = "falaise.as215207.net:51820";
      address = "172.31.0.7";
      pubkey = builtins.readFile config.age.secrets.falaiseWgPubkey.path;
    }
    # {
    #   endpoint = "maple.as215207.net:51820";
    #   address = "172.31.0.8";
    #   pubkey = builtins.readFile config.age.secrets.mapleWgPubkey.path;
    # }
    {
      endpoint = "pete.as215207.net:51820";
      address = "172.31.0.9";
      pubkey = builtins.readFile config.age.secrets.peteWgPubkey.path;
    }
    {
      endpoint = "strudel.as215207.net:51820";
      address = "172.31.0.10";
      pubkey = builtins.readFile config.age.secrets.strudelWgPubkey.path;
    }
    {
      endpoint = "tulip.as215207.net:51820";
      address = "172.31.0.11";
      pubkey = builtins.readFile config.age.secrets.tulipWgPubkey.path;
    }
    {
      endpoint = "yeehaw.as215207.net:51820";
      address = "172.31.0.12";
      pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    }
  ];

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
