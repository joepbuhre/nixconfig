{ config, pkgs, ... }:
{
    virtualisation.oci-containers.containers.whoogle = {                                                                                                                                                                                                                                      
    image = "traefik/whoami";                                                                                                                                                                                                                                                      
    ports = [ "0.0.0.0:5000:5000" ];                                                                                                                                                                                                                                                        
  };
}