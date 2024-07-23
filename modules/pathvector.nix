{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    bgpq4
    bird
    pathvector
  ];

  services.bird2 = {
    enable = true;
    checkConfig = true;
    config = ''
      protocol kernel {
              scan time 20;           # Scan kernel routing table every 20 seconds
      }

      protocol device {
              scan time 10;           # Scan interfaces every 10 seconds
      }
    '';
  };

  systemd.services.pathvector = {
    description = "Run pathvector and regenerate on config change";
    wantedBy = [ "multi-user.target" ];
    reloadTriggers = [ config.environment.etc."pathvector.yml".source ];
    requires = [ "bird2.service" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.pathvector}/bin/pathvector generate";
      ExecReload = "${pkgs.pathvector}/bin/pathvector generate";
    };
  };
}
