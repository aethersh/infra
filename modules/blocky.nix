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
      ];
      caching.prefetching = true;
    };
  };
}
