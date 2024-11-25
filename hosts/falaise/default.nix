{ config, ... }:

{
  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  age.secrets.wgPrivKey = ../../secrets/falaiseWgPrivKey.age;

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

      # Unmetered Exchange
      ens19 = {
        ipv4.addresses = [
          {
            address = "192.34.27.132";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:ffb1:0200:0:192:34:27:132";
            prefixLength = 48;
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

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wgPrivKey.path;
      ips = [
        "172.31.0.7/24"
        "2602:fbcf:dd:d9::/48"
      ];
    };
  };

  services.wgautomesh.settings.peers = [
    {
      endpoint = "bay.as215207.net:51820";
      address = "172.31.0.6";
      pubkey = builtins.readFile config.age.secrets.bayWgPubkey.path;
    }
    # {
    #   endpoint = "falaise.as215207.net:51820";
    #   address = "172.31.0.7";
    #   pubkey = builtins.readFile config.age.secrets.falaiseWgPubkey.path;
    # }
    {
      endpoint = "maple.as215207.net:51820";
      address = "172.31.0.8";
      pubkey = builtins.readFile config.age.secrets.mapleWgPubkey.path;
    }
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
