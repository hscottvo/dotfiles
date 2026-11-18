{
  # Linux desktop environment: GTK theming, notification daemon, and the niri
  # config symlink.
  flake.homeModules.linux-desktop =
    { pkgs, config, ... }:
    let
      colors = config.lib.stylix.colors.withHashtag;
    in
    {
      home.packages = with pkgs; [
        blueman
        google-chrome
        fastfetch
        flatpak
        gparted
        nwg-look
        pavucontrol
        wl-clipboard
        thunar
        thunar-volman
      ];

      services.swaync.enable = false;

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus";
        };
      };

      # Keep the main config writable so Niri can reload it on every save.
      # Theme values are generated separately below and included by config.kdl.
      xdg.configFile."niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "/home/scott/dotfiles/niri/config.kdl";

      # Keep the hand-written Niri config modular, like tmux/tmux.conf:
      # config.kdl includes this Nix-generated Stylix theme fragment.
      xdg.configFile."niri/theme.kdl".text = ''
        layout {
            border {
                active-color "${colors.base0D}"
                inactive-color "${colors.base03}"
                urgent-color "${colors.base08}"
            }

            shadow {
                color "${colors.base00}70"
            }
        }
      '';

      home.file."dotfiles/noctalia/palettes/stylix.json".text = builtins.toJSON {
        version = 2;
        dark = {
          error = colors.base08;
          on_error = colors.base00;
          on_primary = colors.base00;
          on_secondary = colors.base00;
          on_surface = colors.base05;
          on_surface_variant = colors.base04;
          on_tertiary = colors.base00;
          on_hover = colors.base00;
          outline_variant = colors.base03;
          primary = colors.base0D;
          secondary = colors.base0E;
          shadow = colors.base00;
          surface = colors.base00;
          hover = colors.base02;
          surface_container = colors.base01;
          tertiary = colors.base0C;
        };
      };

      programs.mpvpaper.enable = true;
    };

}
