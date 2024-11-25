{ config, ... }:

{
  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  age.secrets.wgPrivkey = ../../secrets/tulipWgPrivkey.age;

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

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wgPrivkey.path;
      ips = [
        "172.31.0.11/24"
        "2602:fbcf:dd:db::/48"
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
    # {
    #   endpoint = "tulip.as215207.net:51820";
    #   address = "172.31.0.11";
    #   pubkey = builtins.readFile config.age.secrets.tulipWgPubkey.path;
    # }
    {
      endpoint = "yeehaw.as215207.net:51820";
      address = "172.31.0.12";
      pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    }
  ];

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
