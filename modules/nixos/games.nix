# /etc/nixos/games.nix
{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
  ];

  programs.gamemode.enable = true;

}

