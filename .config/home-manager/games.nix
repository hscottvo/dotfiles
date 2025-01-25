# games.nix 
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # fuse
    bottles
    lutris
    protonup
    SDL2
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    LD_LIBRARY_PATH = "\$\{LD_LIBRARY_PATH\}:${ pkgs.lib.makeLibraryPath [ pkgs.vulkan-loader ] }";
  };
}

