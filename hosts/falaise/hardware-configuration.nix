{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a02a06a9-5c47-4915-8f8d-b88d9b1c324c";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/55c9679a-328d-4710-9a4d-a99aa47678d2"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
