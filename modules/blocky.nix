{ ... }:

{
  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
  };

  services.blocky = {
    enable = true;
    settings = {
      upstreams.groups.default = [
        "https://ordns.he.net/dns-query"
        "https://dns10.quad9.net/dns-query"
        "https://cloudflare-dns.com/dns-query"
        "https://dns.google/dns-query"
        "https://dns.mullvad.net/dns-query"
        "https://freedns.controld.com/p0"
        "https://unfiltered.adguard-dns.com/dns-query"
        "https://wikimedia-dns.org/dns-query"
      ];
      bootstrapDns = [
        {
          upstream = "https://ordns.he.net/dns-query";
          ips = [
            "74.82.42.42"
            "2001:470:20::2"
          ];
        }
        {
          upstream = "https://dns10.quad9.net/dns-query";
          ips = [
            "9.9.9.10"
            "149.112.112.10"
            "2620:fe::10"
            "2620:fe::fe:10"
          ];
        }
      ];
      caching.prefetching = true;
    };
  };

  systemd.services.blocky = {
    description = "A DNS proxy and ad-blocker for the local network";
    requires = [ "network-online.target" ];
  };

  services.cron.systemCronJobs = ["0 0,12 * * * systemctl restart blocky.service"];
}
