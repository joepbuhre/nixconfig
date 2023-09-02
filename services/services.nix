{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./traefik.nix
      ./docker-networks.nix
    ];
}
