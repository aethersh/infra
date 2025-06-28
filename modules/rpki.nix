{config, pkgs, lib, ...} : let 

cfg = config.ae.rpki;
in {

  options.ae.rpki = with lib; {
    enable = mkEnableOption "Enable Routinator RPKI";
    domain = mkOption {
      type = types.str;
      description = "root domain that will host the web UI";
    };
  };

  config = with lib; mkIf cfg.enable {
    services.routinator = {
      enable = true;
      settings = {
        http-listen = ["[::]:8323"];
        rtr-listen = ["[::]:3323"];
      };
    };

    networking.firewall.allowedTCPPorts = [ 3323 ];

    services.caddy.virtualHosts."${cfg.domain}".extraConfig = ''
    import cf-dns-v6
    reverse_proxy localhost:8323
    '';
  };
}