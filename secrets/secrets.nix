# This file need not be imported by anything, as it exists purely for agenix to figure shit out
let

  # --------- Administrator Public Keys ---------
  # Fetch public keys from websites
  henrik_pubkey = builtins.readFile (builtins.fetchurl "https://henrikvt.com/id_ed25519.pub");
  tibs_pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ";

  admins = [
    henrik_pubkey
    tibs_pubkey
  ];

  # --------- Systems ---------
  bay = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4wM00C6tQ1AjruqiVH0rocMHqNTxr0h3cH+2jFWCM/";
  pete = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRcjBzPsvnAqzXN1OzhxZ5BvcF9x4y9i8/W4bwozyeX";
  nova = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPFkB1Osr6ubWKtoRijZtoHvREHLxJ0l7QYk7f5Ywldv";
  falaise = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILOpPSujmS9FnpiMUk/i9h3Vm5ah7Tsz27iiMNgOKWRB";
  maple = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/6/dLkSuShIpDFwBracmNTlkQ8cVydyp7/MWzfaUnI";
  strudel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNv4kECzICnM9thkHa5X7R9tqgjrsacXJS0LWqUdKKC";
  tulip = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBs7AtmcMc0uTJxGXAllWTcD3c79bePDgzo4sLMi+gP";
  yeehaw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINO9YN+k1oz2fdWQd6lrqUI/8lOJKIiRAMQaBkLXhiAo";
  kier = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPaZuJVKquPjPZ+Sv4Dovg1ixxtPxNnjlHrQn6cv8K2E";
  systems = [
    bay
    pete
    nova
    falaise
    maple
    strudel
    tulip
    yeehaw
    kier
  ];
in
{
  # API Keys
  "cfDnsKey.age".publicKeys = systems ++ admins;

  # Admin public keys for WireGuard
  "henrikWgPubkey.age".publicKeys = systems ++ admins;
  # "tibsWgPubkey.age".publicKeys = systems ++ admins;

  # Machine public keys for WireGuard
  "bayWgPubkey.age".publicKeys = systems ++ admins;
  "peteWgPubkey.age".publicKeys = systems ++ admins;
  # "novaWgPubkey.age".publicKeys = [ nova ] ++ admins;
  "falaiseWgPubkey.age".publicKeys = systems ++ admins;
  "mapleWgPubkey.age".publicKeys = systems ++ admins;
  "strudelWgPubkey.age".publicKeys = systems ++ admins;
  "tulipWgPubkey.age".publicKeys = systems ++ admins;
  "yeehawWgPubkey.age".publicKeys = systems ++ admins;

  # Machine private keys for WireGuard
  "bayWgPrivkey.age".publicKeys = [ bay ] ++ admins;
  "peteWgPrivkey.age".publicKeys = [ pete ] ++ admins;
  # "novaWgPrivkey.age".publicKeys = [ nova ] ++ admins;
  "falaiseWgPrivkey.age".publicKeys = [ falaise ] ++ admins;
  "mapleWgPrivkey.age".publicKeys = [ maple ] ++ admins;
  "strudelWgPrivkey.age".publicKeys = [ strudel ] ++ admins;
  "tulipWgPrivkey.age".publicKeys = [ tulip ] ++ admins;
  "yeehawWgPrivkey.age".publicKeys = [ yeehaw ] ++ admins;

  # wgautomesh Gossip Key
  "wgautomeshGossipKey.age".publicKeys = systems ++ admins;
}
