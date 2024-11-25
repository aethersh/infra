{ config, ... }:

{
  imports = [
    ../../modules/common.nix

    ./hardware-configuration.nix
  ];

  age.secrets.wgPrivkey = ../../secrets/strudelWgPrivkey.age;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "strudel";

    interfaces = {
      # Servperso Systems
      ens18 = {
        ipv4.addresses = [
          {
            address = "194.28.99.208";
            prefixLength = 27;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a0c:b640:10::208";
            prefixLength = 112;
          }
        ];
      };

      # LOCIX Dusseldorf
      ens19 = {
        ipv4.addresses = [
          {
            address = "185.1.155.145";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a0c:b641:701::a5:21:5207:1";
            prefixLength = 64;
          }
        ];
      };

      # LOCIX Frankfurt
      ens20 = {
        ipv4.addresses = [
          {
            address = "185.1.166.58";
            prefixLength = 23;
          }
        ];
        ipv6.addresses = [
          {
            address = "2001:7f8:f2:e1:a5:21:5207:1";
            prefixLength = 64;
          }
        ];
      };

      # Pixinko
      ens21 = {
        ipv6.addresses = [
          {
            address = "2a0c:b641:870::19";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway = {
      address = "194.28.99.222";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2a0c:b640:10::ffff";
      interface = "ens18";
    };

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wgPrivkey.path;
      ips = [
        "172.31.0.10/24"
        "2602:fbcf:dd:de::/48"
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
    # {
    #   endpoint = "strudel.as215207.net:51820";
    #   address = "172.31.0.10";
    #   pubkey = builtins.readFile config.age.secrets.strudelWgPubkey.path;
    # }
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

  motd.location = "düsseldorf, de";

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
