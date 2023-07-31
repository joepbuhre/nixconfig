{ config, pkgs, ... }:    
{
    # Define Traefik here!
    services.traefik.enable = true;

    # Configure Traefik, for example:
    services.traefik.group = "traefik";

    services.traefik.staticConfigOptions = {
        api = { 
            dashboard = true;
        };
        entryPoints = {
            web = {
                address = ":80";
                http = {
                    redirections = {
                        entrypoint = {
                            to = "websecure";
                            scheme = "https";
                        };
                    };
                };
            };
            websecure = {
                address = ":443";
            };
        };
    };
}