# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./services/traefik.nix
      ./services/services.nix
      ./sites/traefik.nix
    ];
  
  virtualisation.oci-containers.backend = "docker";


  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-23.05/";

  # Bootloader.
  boot.loader.grub.devices = [ "/dev/sda" ];

  networking.hostName = "buhrecompany"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Allow docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "jbuhre" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    gh
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jbuhre = {
    isNormalUser = true;
    description = "Joep Buhre";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Setup networking
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "ens3"; # either ens3 (amd64) or enp1s0 (arm64)
    networkConfig.DHCP = "ipv4";
    address = [
      # replace this address with the one assigned to your instance
      "2a01:4f8:1c1e:ef48::/64"
    ];
    routes = [
      { routeConfig.Gateway = "fe80::1"; }
    ];
  };  

  # Initial empty root password for easy login:
  users.users.root.initialHashedPassword = "";
  # services.openssh.settings.PermitRootLogin = "prohibit-password";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
  };

  users.users.jbuhre.openssh.authorizedKeys.keys = [
    # Replace this by your SSH pubkey!
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFh8A1fO0ByWQyBZd8cfTdQzbsPvE1VdRnCsU5+X7Rivs10a/fgwNYhSnaOAKhR8VL1IdsK53A3JrgCngz8Rmg2bAopLSPYoAOvreQCn4QHk+6yW3udqou5pK8k8mUF5VuG5m048ClxHP9LxY+tuq67HYwihvfSjUwf0o6lICj2bOQ7mjflYwgcPa7xdSPzNJQroTioFbQODh6kZnAWsgm3aIa/TnIl5ziLEYmPlfZv28K65v2ksA7qvnIo6nz0nFGzw2oTO5Vzyb+zuEMjmqO9KjcgFewVmsUeyIQttGM4foT8Y3sfj/GwDwyH3dSMH9HPJWP7dxq1Pp1uXof+Tam6nXalA5tdt/xJiDH4MkJQOBSXyx7JkkzdzLlxQbVFm2TLEjOEQHAfm3mhgAaPFVCvof0L/uN629HoGUpVIrtrFhy33d/jipEYgTwJA9lZkqfX64ASjWiGgCbPS90nDzYqj27oluSFr65iOhgzOxDMLTzq07CjCe+XKPp8T5P3Js="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDk2KmS3XlLHthcEJWtEvlZY9RywJKa7BwnNDvGdstw3/TJ9L7BLjEvuAei88Em8WsXNaKr+8rpOxtMbF8sQeEqJLS8zUQm0XbmgEXrqRS/A0P4ohZojiC/RU9//a0lVzKaYVnTZwc0lJdx2hGrk4iLO9U+oSng2iKjItPIKNIimOIqAci9NhdJSeAKnnjoGtoERfegQ8VzCQbt5Bcc+icLLSYsmzWXgkaQfAket8Fj+hOu2XwfauZ+cYHacAQNz/V3WUYdjjCKtelI1ktnWLWjxIOeKAtVt21XEa7y/FNI4LKLdDUTVckdSf3EC0jFNGju1RdK5Ffrm+LxRt/ljT9lo+Erjh8deRUd5smBOJ8oQpAvQM/vh0LjF1lhweYc4fngUU+GYz3bJDK4VMg5JeSADPBk6Gv4Gvj+0PaYcjixavPtkltuhC2rSO+GULEcIj1FANOS40p2tknIqNg8T78avC3qWESHHRncp2DA5dtwfvhpz9oCgeNIPvBunz79HS0= jbuhre@buhrecompany"
  ];


  # Firewall rules
  networking.firewall.enable = true;
 networking.firewall.extraCommands = ''
    iptables -A INPUT -m state --state NEW -j LOG --log-prefix "New Connection: "
 '';
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
