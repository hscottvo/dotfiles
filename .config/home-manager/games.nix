# games.nix 
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    protonup
	SDL2
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}

