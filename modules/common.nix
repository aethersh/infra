{ lib, pkgs, ... }:

{
  imports = [
    ./prometheus.nix
    ./motd.nix
    ./pathvector.nix
    ./blocky.nix
    ./chrony.nix
    ./globalping.nix
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
      allowed-users = [ "admin" ];
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
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        51820
      ];
      allowedUDPPorts = [ 51820 ];
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding"= 1;
    "net.ipv6.conf.all.accept_ra" = 0;
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
    fail2ban = {
      enable = true;
      ignoreIP = [
        # Whitelist RFC1918 addresses
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        # UVM
        "132.198.0.0/16"
        "2620:104:e000::/40"
        # AetherNet
        "2602:fbcf:d0::/44"
      ];
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
    wireguard-tools
    q
  ];

  security.sudo.wheelNeedsPassword = false;
  services.cron.enable = true;

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "bird"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINimhbJZN+MLdXbtk3Mrb5dca7P+LKy399OqqYZ122Ml"
    ];
  };
}
