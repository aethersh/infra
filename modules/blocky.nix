{ pkgs, ... }: {
  networking = { nameservers = [ "127.0.0.1" "::1" ]; };

  services.blocky = {
    enable = true;
    settings = {
      upstreams.groups.default = [
        "https://ordns.he.net/dns-query"
        "https://dns.quad9.net/dns-query"
        "https://security.cloudflare-dns.com/dns-query"
        "https://base.dns.mullvad.net/dns-query"
        "https://freedns.controld.com/p2"
        "https://dns.adguard-dns.com/dns-query"
      ];
      bootstrapDns = {
        upstream = "https://ordns.he.net/dns-query";
        ips = [ "74.82.42.42" "2001:470:20::2" ];
      };
      caching.prefetching = true;
    };
  };
}
