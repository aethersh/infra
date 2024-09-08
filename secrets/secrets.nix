# This file need not be imported by anything, as it exists purely for agenix to figure shit out
let

  # --------- Henrik's Public Keys ---------
  # Fetch public key from https://henrikvt.com/id_ed25519.pub
  henrik_pubkey = builtins.readFile (builtins.fetchurl "https://henrikvt.com/id_ed25519.pub");
  tibs_pubkey = builtins.readFile (builtins.fetchurl "https://tibinonest.me/tibs_ssh.pub");

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

  systems = [
    bay
    pete
    nova
    falaise
    maple
    strudel
    tulip
  ];
in
{
  # Reference age files here

}
