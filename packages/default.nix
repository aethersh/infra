{ pkgs, ... }:
{
  caddy = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
    hash = "sha256-UwrkarDwfb6u+WGwkAq+8c+nbsFt7sVdxVAV9av0DLo=";
  };
}