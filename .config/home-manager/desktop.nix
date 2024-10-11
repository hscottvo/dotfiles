{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay  # Add cowsay to your environment
    rofi
    neofetch
    fastfetch
    nwg-look

    (nerdfonts.override {fonts = [ "Iosevka" "JetBrainsMono" ]; })

  ];

  gtk = with pkgs; {
    enable = true;
    theme.name = "gruvbox-dark";
    theme.package = gruvbox-dark-gtk;

    iconTheme.name = "";
    iconTheme.package = arc-icon-theme;
  };


}

