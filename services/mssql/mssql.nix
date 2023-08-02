{ config, pkgs, ... }:
{

  system.activationScripts.mkNetMssql = let
      docker = config.virtualisation.oci-containers.backend;
      dockerBin = "${pkgs.${docker}}/bin/${docker}";
      netName = "mssql";
    in ''
      ${dockerBin} network inspect ${netName} >/dev/null 2>&1 || ${dockerBin} network create ${netName}

      mkdir -p /services/mssql/data

  '';

  virtualisation.oci-containers.containers = {
    # MSSQL Admin
    mssql = {                                                                                                                                                                                                                                      
      user = "root";
      image = "mcr.microsoft.com/mssql/server:2019-latest";
      ports = [
        "1433:1433"
      ];
      volumes = [
        "/services/mssql/data:/var/opt/mssql/data"
      ];
      environmentFiles = [
        "/home/jbuhre/nixconfig/services/mssql/mssql.env"
      ];
      extraOptions = [
        "--network=mssql"
      ];
    };

  };
}