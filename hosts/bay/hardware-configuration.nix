{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "uhci_hcd"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/79a4925b-2b31-4fda-86a9-63cb5245a1f3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/e56e9470-b819-4eae-82eb-04c56d9e1754";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/c602b4b1-320d-41d9-ab6d-c0fb67eb129f"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
