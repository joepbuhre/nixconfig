{ config, pkgs, ... }:    
{
    imports =
        [ # Include the results of the hardware scan.
        ./sites/iuvox.nix
        ./sites/joepbuhre.nix
        ];
    # https://github.com/bradparker/bradparker.com/blob/main/bradparker.com/usr/local/src/bradparker.com/module.nix
    # Check this over here!
    
    # Define Traefik here!
    services.traefik.enable = true;

    # Configure Traefik, for example:
    services.traefik.group = "traefik";

    services.traefik.staticConfigOptions = {
        api = { 
            dashboard = true;
            insecure = true;
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