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

  age.secrets.wgPrivkey = ../../secrets/mapleWgPrivkey.age;

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
      privateKeyFile = config.age.secrets.wgPrivkey.path;
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
      pubkey = "R6XggQejbqHF/l9rvgTJx5a/89Zw0Grd0pJ8OKwkXUE=";
    }
    {
      endpoint = "falaise.as215207.net:51820";
      address = "172.31.0.7";
      pubkey = "F80L40pvu3N7pP9EXGS+SbP20NH6z+rHbcOHYBnQwg8=";
    }
    # {
    #   endpoint = "maple.as215207.net:51820";
    #   address = "172.31.0.8";
    #   pubkey = "FcSTiNO/GrPeTqfIcHrpOGQks324suM4QcdbGOM1igc=";
    # }
    {
      endpoint = "pete.as215207.net:51820";
      address = "172.31.0.9";
      pubkey = "UI+GluPRk0biKO+JITUDgOy+4b2LOw7x7TbhML/lC1Q=";
    }
    {
      endpoint = "strudel.as215207.net:51820";
      address = "172.31.0.10";
      pubkey = "Q/uu+7+gMFT57LkFH4tu1bMrfQSuYiR/OALmR/oJaBY=";
    }
    {
      endpoint = "tulip.as215207.net:51820";
      address = "172.31.0.11";
      pubkey = "OXdm485MJpI5923eHf5CUqcXjkkUCXkLGqRC4udLMAs=";
    }
    {
      endpoint = "yeehaw.as215207.net:51820";
      address = "172.31.0.12";
      pubkey = "BWvxchKyCm2LrXKkVFInjgGWqRVOTyUcKYDGcPpUdR4=";
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
