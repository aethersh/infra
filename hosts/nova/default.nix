{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ../../modules/common.nix

      ../../modules/blocky.nix
      ../../modules/chrony.nix
      ../../modules/pathvector.nix

      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
  
  networking = {
    hostName = "nova";

    interfaces.ens18 = {
      ipv4.addresses = [{
        address = "192.67.33.7";
        prefixLength = 26;
      }];
      ipv6.addresses = [{
        address = "2602:fa7e:14::6";
        prefixLength = 64;
      }];
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

  environment.etc."pathvector.yml".source = ./pathvector.yml;

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
