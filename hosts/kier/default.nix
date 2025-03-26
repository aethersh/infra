{...}: {

  imports = [ ../../modules/common.nix
  
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  motd.location = "kansas city";

  networking = {
    hostName = "kier";
    interfaces.ens10 = {
              ipv4.addresses = [
          {
            address = "23.143.82.38";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fc26:12:1::38";
            prefixLength = 48;
          }
        ];
    };

    defaultGateway = {
      address = "23.143.82.1";
      interface = "ens10";
    };
    defaultGateway6 = {
      address = "2602:fc26:12::1";
      interface = "ens10";
    };
  };

}