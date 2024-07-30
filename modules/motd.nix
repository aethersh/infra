{ config, lib, ... }:

let
  cfg = config.motd;
in
{
  options.motd = {
    place = lib.mkOption {
      type = with lib.types; str;
      default = "Add place in motd.place";
      description = "The location of this host";
    };
  };

  config = {
    environment.etc."motd".text = ''
      ~~ welcome to the aethernet ~~
      ${config.networking.hostName}.${config.networking.domain}
      > ${cfg.place} <
      -
    '';

    services.openssh.settings = {
      PrintMotd = true;
      PrintLastLog = false;
    };
  };
}
