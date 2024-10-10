{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay  # Add cowsay to your environment
    rofi
    neofetch
    nwg-look

  ];

  gtk = with pkgs; {
    enable = true;
    theme.name = "gruvbox-dark";
    theme.package = gruvbox-dark-gtk;

    iconTheme.name = "";
    iconTheme.package = arc-icon-theme;

    # theme.name = "Everforest";
    # theme.package = everforest-gtk-theme;


  };

}

