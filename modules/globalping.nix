{ ... }:

{
  virtualisation.oci-containers.containers.globalping = {
    image = "globalping/globalping-probe";
    extraOptions = [
      "--cap-add=NET_RAW"
      "--network=host"
    ];
  };
}
