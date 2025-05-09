# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "ahci"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8f6b5d6d-e9b1-44c9-bd6a-0310e2ae4868";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/ba84ca00-2173-4bad-b0fc-2eeba8075321"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
