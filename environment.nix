{ config, pkgs, ... }:    
{
    # Setting environmental variables
    environment.variables = {
        NIXPKGS_ALLOW_UNFREE = "1";
    };
}
