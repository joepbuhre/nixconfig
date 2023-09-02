{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./docker-networks.nix
    ];
}
