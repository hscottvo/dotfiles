{ config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
in
{
  xdg.enable = true;
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim";
  home.stateVersion = "26.05";
  stylix = {
    enable = true;
    # base16Scheme = {
    #   slug = "everforest-dark-hard";
    #   scheme = "Everforest dark, hard";
    #   author = "Sainnhe Park (sainnhe@gmail.com)";
    #
    #   base00 = "2b3339"; # Default Background
    #   base01 = "323c41"; # Lighter Background (Used for status bars, line number and folding marks)
    #   base02 = "503946"; # Selection Background
    #   base03 = "868d80"; # Comments, Invisibles, Line Highlighting
    #   base04 = "d3c6aa"; # Dark Foreground (Used for status bars)
    #   base05 = "d3c6aa"; # Default Foreground, Caret, Delimiters, Operators
    #   base06 = "e9e8d2"; # Light Foreground (Not often used)
    #   base07 = "fff9e8"; # Light Background (Not often used)
    #   base08 = "7fbbb3"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    #   base09 = "d699b6"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    #   base0A = "83c092"; # Classes, Markup Bold, Search Text Background
    #   base0B = "dbbc7f"; # Strings, Inherited Class, Markup Code, Diff Inserted
    #   base0C = "e69875"; # Support, Regular Expressions, Escape Characters, Markup Quotes
    #   base0D = "a7c080"; # Functions, Methods, Attribute IDs, Headings
    #   base0E = "e67e80"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
    #   base0F = "d699b6"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    # };
    base16Scheme = {
      slug = "catppuccin-macchiato";
      scheme = "Catppuccin Macchiato";
      author = "catppuccin";
      base00 = "24273A"; # base
      base01 = "1E2030"; # mantle
      base02 = "363A4F"; # surface0
      base03 = "494D64"; # surface1
      base04 = "5B6078"; # surface2
      base05 = "CAD3F5"; # text
      base06 = "F4DBD6"; # rosewater
      base07 = "B7BDF8"; # lavender
      base08 = "ED8796"; # red
      base09 = "F5A97F"; # peach
      base0A = "EED49F"; # yellow
      base0B = "A6DA95"; # green
      base0C = "8BD5CA"; # teal
      base0D = "8AADF4"; # blue
      base0E = "C6A0F6"; # mauve
      base0F = "F0C6C6"; # flamingo
      # scheme: "Catppuccin Macchiato"
      # author: "https://github.com/catppuccin/catppuccin"
    };
  };

}
