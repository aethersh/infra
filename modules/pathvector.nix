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
      router id 10.0.0.1;

      protocol kernel {
        export all;     # Default is export none
        persist;                # Don't remove routes on BIRD shutdown
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
