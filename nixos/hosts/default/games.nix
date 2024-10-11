# /etc/nixos/games.nix
{ lib, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tree
  ];
}
