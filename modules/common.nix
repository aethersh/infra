{ lib, pkgs, ... }:

{
  imports = [
    ./prometheus.nix
    ./motd.nix
  ];

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
    iperf3.enable = true;

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

    # Cleaner Bash prompt
    bash.promptInit = ''
      PS1="\[\e[32;1m\]\u\[\e[36;1m\]@\[\e[32;1m\]\h \[\e[34m\]\w\[\e[m\] \\$ "
    '';
  };

  environment.systemPackages = with pkgs; [
    btop
    ldns # drill
    neofetch
    wget
    inetutils
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "bird"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCtfd78i5iR0RCJnzXp1sg6/+RsHcD90EJjUPoruzM0"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINimhbJZN+MLdXbtk3Mrb5dca7P+LKy399OqqYZ122Ml"
    ];
  };
}
