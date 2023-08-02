{ config, pkgs, ... }:
{

  system.activationScripts.mkNetIuvox = let
      docker = config.virtualisation.oci-containers.backend;
      dockerBin = "${pkgs.${docker}}/bin/${docker}";
      netName = "iuvox";
    in ''
      ${dockerBin} network inspect ${netName} >/dev/null 2>&1 || ${dockerBin} network create ${netName}

      mkdir -p /services/iuvox/

  '';

  virtualisation.oci-containers.containers = {
    # Directus
    iuvox-admin = {                                                                                                                                                                                                                                      
      image = "directus/directus:9.2.2";
      environmentFiles = [
        "/home/jbuhre/nixconfig/services/iuvox/iuvox.env"
      ];
      extraOptions = [
        "--network=iuvox"
        "--network=mssql"
      ];
    };

    # Caching for Directus
    iuvox-redis = {
      image = "redis:6";
      extraOptions = [
        "--network=iuvox"
      ];
    };

    # Frontend Iuvox
    iuvox-frontend = {
      image = "traefik/whoami";
      ports = [
        "127.0.0.1:8081:80"
      ];
      extraOptions = [
        "--network=iuvox"
      ];
    };

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
                url = "http://localhost:8081";
              }
            ];
          };
        };
      };
    };
  };
}