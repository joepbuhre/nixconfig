{ config, pkgs, ... }:    
{
    # Define Traefik here!
    services.traefik.enable = true;

    # Configure Traefik, for example:
    services.traefik.group = "docker";

    services.traefik.dataDir = "/services/traefik";

    services.traefik.staticConfigOptions = {
        providers = {
            docker = {
                exposedbydefault = false;
                network = "traefik_proxy";
            };
        };
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
        certificateResolvers = {
            transipDNS = {
                email = "joep@iuvox.nl";
                storage = "/services/traefik/transipDNS.json";
                dnsChallenge = {
                    provider = "transip";
                    delayBeforeCheck = 0;
                };
            };
        };
    };

    # Define necessary acme env variables
    environment.variables = {
        DOMAIN = "example.com";
        dkim = "$( cat /services/traefik/test )";
    };
}