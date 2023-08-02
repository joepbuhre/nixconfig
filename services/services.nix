{ config, pkgs, ... }:
{
    imports = [
	./codeserver/codeserver.nix
        ./iuvox/iuvox.nix
        ./mssql/mssql.nix
    ];
    system.activationScripts.mkServicesData = ''
        chown -R jbuhre /services
    '';
}
