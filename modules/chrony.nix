{ pkgs, ... }:

{
  services.chrony = {
    enable = true;
    servers = [
      "pool.ntp.org"
      "clock.nyc.he.net"
      "time.nist.gov"
      "time.cloudflare.com"
    ];
  };
}
