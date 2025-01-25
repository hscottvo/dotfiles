# /etc/nixos/games.nix
{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    protonup
  ];

  programs.gamemode.enable = true;

}

