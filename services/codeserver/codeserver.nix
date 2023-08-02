{ config, pkgs, ... }:
{
  virtualisation.oci-containers.containers.codeserver = {                                                                                                                                                                                                                                      
    image = "lscr.io/linuxserver/code-server:4.13.0";                                                                                                                                                                                                                                                      
    ports = [ "8443:8443" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Amsterdam";
      SUDO_PASSWORD = "root";
    }; 
    volumes = [
      "/services/code-server/ssh:/config/.ssh"
      "/home/jbuhre/:/home-jbuhre"
    ];                                                                                                                                                                                                                                           
  };
  # services.traefik.dynamicConfigOptions = {
  #   http = {
  #     routers = {
  #       iuvox = {
  #         rule = "Host(`iuvox.nl`)";
  #         service = "iuvox";
  #       };
  #     };
  #     services = {
  #       iuvox = {
  #         loadBalancer = {
  #           servers = [
  #             {
  #               url = "http://localhost:8080";
  #             }
  #           ];
  #         };
  #       };
  #     };
  #   };
  # };
}
