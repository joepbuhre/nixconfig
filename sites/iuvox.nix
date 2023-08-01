{ config, pkgs, ... }:
{
  virtualisation.oci-containers.containers.whoogle = {                                                                                                                                                                                                                                      
    image = "traefik/whoami";                                                                                                                                                                                                                                                      
    ports = [ "127.0.0.1:5000:80" ];                                                                                                                                                                                                                                                        
  };
  services.traefik.dynamicConfigOptions = {
    http = {
      routers = {
        iuvox = {
          rule = "Host(`iuvox.nl`)";
          service = "iuvox";
        };
      };
      services = {
        iuvox = {
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