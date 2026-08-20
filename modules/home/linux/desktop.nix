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

      services.swaync.enable = true;

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
      home.file."dotfiles/niri/theme.kdl".text = ''
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

      # Noctalia splits its configuration into separate JSON files rather than
      # supporting includes. Its wrapper points NOCTALIA_CONFIG_DIR at this
      # checkout, so replacing this generated file is detected at runtime.
      home.file."dotfiles/noctalia/colors.json".text = builtins.toJSON {
        mError = colors.base08;
        mOnError = colors.base00;
        mOnPrimary = colors.base00;
        mOnSecondary = colors.base00;
        mOnSurface = colors.base05;
        mOnSurfaceVariant = colors.base04;
        mOnTertiary = colors.base00;
        mOnHover = colors.base00;
        mOutline = colors.base03;
        mPrimary = colors.base0D;
        mSecondary = colors.base0E;
        mShadow = colors.base00;
        mSurface = colors.base00;
        mHover = colors.base02;
        mSurfaceVariant = colors.base01;
        mTertiary = colors.base0C;
      };

    };
}
