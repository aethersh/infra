{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/common.nix

    ../../modules/blocky.nix
    ../../modules/chrony.nix
    ../../services/pathvector

    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "nova";

    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "192.67.33.7";
          prefixLength = 26;
        }
      ];
      ipv6.addresses = [
        {
          address = "2602:fa7e:14::6";
          prefixLength = 64;
        }
      ];
    };

    defaultGateway = {
      address = "192.67.33.1";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "2602:fa7e:14::1";
      interface = "ens18";
    };
  };

  services.pathvector = {
    enable = true;
    config = {
      asn = 215207;
      router-id = "192.67.33.7";
      source4 = "192.67.33.7";
      source6 = "2602:fa7e:14::6";
      prefixes = [
        "2602:fbcf:d0::/44"
        "2a0f:85c1:3aa::/48"
      ];

      templates = {
        upstream = {
          announce = [ "215207:0:15" ];
          allow-local-as = true;
          remove-all-communities = 215207;
          local-pref = 80;
          import-limit4 = 1500000;
          import-limit6 = 500000;
          add-on-import = [ "215207:0:15" ];
        };

        routeserver = {
          announce = [ "215207:0:13" ];
          add-on-import = [ "215207:0:13" ];
          auto-import-limits = true;
          remove-all-communities = 215207;
          local-pref = 90;
          enforce-peer-nexthop = false;
          enforce-first-as = false;
          filter-transit-asns = true;
        };
      };

      peers = {
        "Paradox Networks" = {
          asn = 215207;
          template = "upstream";
          neighbors = [
            "192.67.33.1"
            "2602:fa7e:14::1"
          ];
        };

        "NVIX Route Servers" = {
          asn = 57369;
          template = "routeserver";
          neighbors = [
            "2001:504:125:e2::1"
            "2001:504:125:e2::2"
          ];
        };
      };
    };
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
