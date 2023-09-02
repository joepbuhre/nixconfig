{ config, pkgs, ... }:
{
  services.traefik.dynamicConfigOptions = {
    http = {
      routers = {
        traefik = {
          rule = "Host(`traefik.iuvox.nl`)";
          service = "traefik";
        };
      };
      services = {
        traefik = {
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