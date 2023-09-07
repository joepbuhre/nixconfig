{ config, pkgs, ... }:    
{
    networking.hosts = {
        "127.0.0.1" = [ "foo.bar.baz" ];
        "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
    };
}
