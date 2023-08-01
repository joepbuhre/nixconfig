{ config, pkgs, ... }:
{
  virtualisation.oci-containers.containers.whoogle2 = {                                                                                                                                                                                                                                      
    image = "traefik/whoami";                                                                                                                                                                                                                                                      
    ports = [ "127.0.0.1:5001:80" ];                                                                                                                                                                                                                                                        
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers = {
        joepbuhre = {
          rule = "Host(`joepbuhre.nl`)";
          service = "joepbuhre";
        };
      };
      services = {
        joepbuhre = {
          loadBalancer = {
            servers = [
              {
                url = "http://localhost:8080";
              }
            ];
          };
        };
      };
    };
  };
}