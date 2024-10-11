# /etc/nixos/games.nix
{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
  ];

  programs.gamemode.enable = true;

  # You can add any other configuration you want to test
}

