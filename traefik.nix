{ config, pkgs, ... }:    
{
    # Define Traefik here!
    services.traefik.enable = true;

    # Configure Traefik, for example:
    services.traefik.group = "traefik";

    services.traefik.staticConfigOptions = {
        api = { };
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