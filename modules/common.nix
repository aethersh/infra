{ lib, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "admin" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    domain = "as215207.net";
    networkmanager.enable = false;
    useDHCP = false;
    tempAddresses = "disabled";
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  programs = {
    htop.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  environment.systemPackages = with pkgs; [
    iperf3
    neofetch
    pciutils
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCtfd78i5iR0RCJnzXp1sg6/+RsHcD90EJjUPoruzM0"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINimhbJZN+MLdXbtk3Mrb5dca7P+LKy399OqqYZ122Ml"
    ];
  };
}
