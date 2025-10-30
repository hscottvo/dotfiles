{ config, ... }:

let
  colors = config.custom.themes.everforest.colors;
in
{
  stylix = {
    enable = true;
    # base16Scheme = {
    #   slug = "everforest-dark-hard";
    #   scheme = "Everforest Dark Hard";
    #   author = "sainnhe";
    #   base00 = colors.bg_dim;
    #   base01 = colors.bg1;
    #   base02 = colors.bg3;
    #   base03 = colors.grey1;
    #   base04 = colors.grey2;
    #   base05 = colors.fg;
    #   base06 = colors.fg;
    #   base07 = colors.bg0;
    #   base08 = colors.blue;
    #   base09 = colors.purple;
    #   base0A = colors.yellow;
    #   base0B = colors.aqua;
    #   base0C = colors.orange;
    #   base0D = colors.green;
    #   base0E = colors.red;
    #   base0F = colors.bg_visual;
    # };
    base16Scheme = {
      slug = "catppuccin-macchiato";
      scheme = "Catppuccin Macchiato";
      author = "catppuccin";
      base00 = "24273A";
      base01 = "1E2030";
      base02 = "363A4F";
      base03 = "494D64";
      base04 = "5B6078";
      base05 = "CAD3F5";
      base06 = "F4DBD6";
      base07 = "B7BDF8";
      base08 = "ED8796";
      base09 = "F5A97F";
      base0A = "EED49F";
      base0B = "A6DA95";
      base0C = "8BD5CA";
      base0D = "8AADF4";
      base0E = "C6A0F6";
      base0F = "F0C6C6";
    };
  };



}

