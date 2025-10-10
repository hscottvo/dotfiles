{ config, ... }:

let
  colors = config.custom.themes.everforest.colors;
in
{
  stylix = {
    enable = true;
    base16Scheme = {
      slug = "everforest-dark-hard";
      scheme = "Everforest Dark Hard";
      author = "sainnhe";
      base00 = colors.bg_dim;
      base01 = colors.bg1;
      base02 = colors.bg3;
      base03 = colors.grey1;
      base04 = colors.grey2;
      base05 = colors.fg;
      base06 = colors.fg;
      base07 = colors.bg0;
      base08 = colors.blue;
      base09 = colors.purple;
      base0A = colors.yellow;
      base0B = colors.aqua;
      base0C = colors.orange;
      base0D = colors.green;
      base0E = colors.red;
      base0F = colors.bg_visual;
    };
  };



}

