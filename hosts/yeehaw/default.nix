{ config, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];

  age.secrets.wgPrivkey = ../../secrets/yeehawWgPrivkey.age;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "yeehaw";

    interfaces = {
      # F4 Networks
      ens18 = {
        ipv4.addresses = [
          {
            address = "23.150.41.166";
            prefixLength = 27;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:02b7:40:65::166";
            prefixLength = 128;
          }
        ];
      };
      # F4IX
      ens19 = {
        ipv6.addresses = [
          {
            address = "2602:fa3d:f4:1::bf";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway = {
      address = "23.150.41.161";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:02b7:40:65::1";
      interface = "ens18";
    };

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wgPrivkey.path;
      ips = [
        "172.31.0.12/24"
        "2602:fbcf:dd:d4::/48"
      ];
    };
  };

  services.wgautomesh.settings.peers = [
    {
      endpoint = "bay.as215207.net:51820";
      address = "172.31.0.6";
      pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    }
    {
      endpoint = "falaise.as215207.net:51820";
      address = "172.31.0.7";
      pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    }
    {
      endpoint = "maple.as215207.net:51820";
      address = "172.31.0.8";
      pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    }
    {
      endpoint = "pete.as215207.net:51820";
      address = "172.31.0.9";
      pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    }
    {
      endpoint = "strudel.as215207.net:51820";
      address = "172.31.0.10";
      pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    }
    {
      endpoint = "tulip.as215207.net:51820";
      address = "172.31.0.11";
      pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    }
    # {
    #   endpoint = "yeehaw.as215207.net:51820";
    #   address = "172.31.0.12";
    #   pubkey = builtins.readFile config.age.secrets.yeehawWgPubkey.path;
    # }
  ];

  motd.location = "kansas city, us";

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
  system.stateVersion = "23.05";
  # ======================== DO NOT CHANGE THIS ========================
}
