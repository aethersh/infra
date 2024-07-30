{ config, lib, ... }:

let
  cfg = config.motd;
in
{
  options.motd = {
    location = lib.mkOption {
      type = with lib.types; str;
      default = "Add location in motd.location";
      description = "The location of this host";
    };
  };

  config = {
    environment.etc."motd".text = ''
      ~~ welcome to the aethernet ~~
      ${config.networking.hostName}.${config.networking.domain}
      > ${cfg.location} <
      -
    '';

    services.openssh.settings = {
      PrintMotd = true;
      PrintLastLog = false;
    };
  };
}
