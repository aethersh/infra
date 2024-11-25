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

  age.secrets.wgPrivkey = ../../secrets/peteWgPrivkey.age;

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
      privateKeyFile = config.age.secrets.wgPrivkey.path;
      ips = [
        "172.31.0.9/24"
        "2602:fbcf:dd:d0::/48"
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
    {
      endpoint = "maple.as215207.net:51820";
      address = "172.31.0.8";
      pubkey = "FcSTiNO/GrPeTqfIcHrpOGQks324suM4QcdbGOM1igc=";
    }
    # {
    #   endpoint = "pete.as215207.net:51820";
    #   address = "172.31.0.9";
    #   pubkey = "UI+GluPRk0biKO+JITUDgOy+4b2LOw7x7TbhML/lC1Q="";
    # }
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
