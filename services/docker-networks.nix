{ config, pkgs, ... }:

let 
    docker = config.virtualisation.oci-containers.backend;
    dockerBin = "${pkgs.${docker}}/bin/${docker}";
      
in {
  system.activationScripts.mkNetIuvox = let
      netName = "iuvox";
    in ''
      ${dockerBin} network inspect ${netName} >/dev/null 2>&1 || ${dockerBin} network create ${netName}

      mkdir -p /services/iuvox/
  '';

  system.activationScripts.mkNetTraefik = let
      netName = "traefik";
    in ''
      ${dockerBin} network inspect ${netName} >/dev/null 2>&1 || ${dockerBin} network create ${netName}
  '';
}