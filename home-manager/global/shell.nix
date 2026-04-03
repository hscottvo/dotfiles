{ config, pkgs, ... }:

let
  colors = config.custom.themes.everforest.colors;
in
{

  home.packages = with pkgs; [
    commitizen
    dust
    helix
    pre-commit
    wget
    xdelta
  ];

  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "Open Pull Requests";
          filters = "is:open";
        }
        {
          title = "Closed Pull Requests";
          filters = "is:closed";
        }
        {
          title = "My Open Pull Requests";
          filters = "is:open author:@me";
        }
      ];
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 14;
    };
    extraConfig = ''
      enable_audio_bell no
      confirm_os_window_close 0

    '';
  };
  stylix.targets.kitty.enable = false;

  programs.ghostty = {
    settings = {
      font-family = "FiraCode Nerd Font";
    };
  };

  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "eza -l";
      ls = "eza";
    };
  };

  xdg.configFile."tmux/tmux.conf".source = ../../tmux/tmux.conf;
  xdg.configFile."tmux/theme.conf".text = ''
    # mode (copy mode highlight)
    set-option -g mode-style fg=#${colors.bg_dim},bg=#${colors.fg}

    # panes
    set -g window-active-style bg=#${colors.bg_dim}
    set -g pane-active-border fg=#${colors.green}

    # status bar
    set-option -g status-style bg=#${colors.bg0},fg=#${colors.fg}
    set -g status-left-length 150
    set -g status-left "\
    #[fg=#${colors.bg0}, bg=#${colors.statusline1}, bold] #(whoami) \
    #[bg=#${colors.bg0}, fg=#${colors.statusline1}]\
    #[bg=#${colors.bg0}, fg=#${colors.fg}] #S \
    #[fg=#${colors.fg}, bg=#${colors.bg0}] "

    set-option -g status-right-style none
    set -g status-right-length 150
    set -g status-right "\
    #[fg=#${colors.bg2}, bg=#${colors.bg0}]#[bg=#${colors.bg2}, fg=#${colors.fg}] %Y-%m-%d \
    #[bg=#${colors.bg2}, fg=#${colors.bg4}]#[fg=#${colors.fg}, bg=#${colors.bg4}] %H:%M  \
    #[fg=#${colors.statusline1}, bg=#${colors.bg4}]#[fg=#${colors.bg_dim}, bg=#${colors.statusline1}, bold] #h "

    # active window
    set-window-option -g window-status-current-format "\
    #[fg=#${colors.bg0}, bg=#${colors.bg5}]\
    #[fg=#${colors.fg}, bg=#${colors.bg5}] #I \
    #[fg=#${colors.fg}, bg=#${colors.bg5}, bold] #W \
    #[fg=#${colors.bg5}, bg=#${colors.bg0}]"

    # inactive window
    set-window-option -g window-status-format "\
    #[fg=#${colors.fg}, bg=#${colors.bg0}] #I \
     #W \
    #[fg=#${colors.bg0}, bg=#${colors.bg0}]"
  '';

  programs.tmux = {
    enable = true;
    secureSocket = false;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      resurrect
    ];
  };

  programs.bat = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    colors = "auto";
    icons = "auto";
    enableZshIntegration = true;
  };

  xdg.configFile."starship.toml".text = builtins.readFile ../../starship/starship.toml + ''

    [palettes.everforest]
    bg_dim = "#${colors.bg_dim}"
    bg0 = "#${colors.bg0}"
    bg1 = "#${colors.bg1}"
    bg2 = "#${colors.bg2}"
    bg3 = "#${colors.bg3}"
    bg4 = "#${colors.bg4}"
    bg5 = "#${colors.bg5}"
    bg_visual = "#${colors.bg_visual}"
    bg_red = "#${colors.bg_red}"
    bg_green = "#${colors.bg_green}"
    bg_blue = "#${colors.bg_blue}"
    bg_yellow = "#${colors.bg_yellow}"
    fg = "#${colors.fg}"
    red = "#${colors.red}"
    orange = "#${colors.orange}"
    yellow = "#${colors.yellow}"
    green = "#${colors.green}"
    aqua = "#${colors.aqua}"
    blue = "#${colors.blue}"
    purple = "#${colors.purple}"
    grey0 = "#${colors.grey0}"
    grey1 = "#${colors.grey1}"
    grey2 = "#${colors.grey2}"
    statusline1 = "#${colors.statusline1}"
    statusline2 = "#${colors.statusline2}"
    statusline3 = "#${colors.statusline3}"
  '';

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  stylix.targets.starship.enable = false;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    ignores = [
      ".direnv/"
      "devenv.local.nix"
      ".local/"
    ];
    settings = {
      user.name = "Scott Vo";
      user.email = "scott.vo@mechanical-orchard.com";
      init.defaultBranch = "main";
      core.symlinks = true;
      core.editor = "nvim";
      diff.tool = "nvimdiff";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

}
