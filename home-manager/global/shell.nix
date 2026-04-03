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

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    secureSocket = false;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      resurrect
      # continuum
    ];

    extraConfig = ''
      set -g @continuum-boot 'on'

      set -g status-interval 2

      # mouse works as expected
      set-option -g mouse on

      # terminal colors
      set-option -g default-terminal "screen-256color"
      set-option -a terminal-features 'xterm-256color:RGB'
      set-option -g focus-events on

      # window menu
      set-option -g mode-style fg=#${colors.bg_dim},bg=#${colors.fg}

      # pane background
      set -g window-active-style bg=#${colors.bg_dim}
      set -g pane-active-border fg=#${colors.green}

      # status bar
      set-option -g status-style bg=#${colors.bg0}
      set-option -ag status-style fg=#${colors.fg}
      set -g status-left-length 150
      set -g status-left "\
      #[fg=#${colors.bg0}, bg=#${colors.statusline1}, bold] #(whoami) \
      #[bg=#${colors.bg0}, fg=#${colors.statusline1}]\
      #[bg=#${colors.bg0}, fg=#${colors.fg}] #S \
      #[fg=#${colors.fg}, bg=#${colors.bg0}] "

      set-option -g status-right-style none
      set -g status-right-length 150
      set -g status-right "\
      #[fg=#${colors.bg2}, bg=#${colors.bg0}]#[bg=#${colors.bg2}, fg=#${colors.fg}] %Y-%m-%d \
      #[bg=#${colors.bg2}, fg=#${colors.bg4}]#[fg=#${colors.fg}, bg=#${colors.bg4}] %H:%M  \
      #[fg=#A7C080, bg=#${colors.bg4}]#[fg=#${colors.bg_dim}, bg=#A7C080, bold] #h "

      set-window-option -g window-status-current-format "\
      #[fg=#${colors.bg0}, bg=#${colors.bg5}]\
      #[fg=#${colors.fg}, bg=#${colors.bg5}] #I \
      #[fg=#${colors.fg}, bg=#${colors.bg5}, bold] #W \
      #[fg=#${colors.bg5}, bg=#${colors.bg0}]"

      set-window-option -g window-status-format "\
      #[fg=#${colors.fg}, bg=#${colors.bg0}] #I \
       #W \
      #[fg=#${colors.bg0}, bg=#${colors.bg0}]"

      # splitting
      bind '"' split-window -h -c "#{pane_current_path}"
      bind % split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # reload config 
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

    '';
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$os$username$directory$git_branch$git_state$git_status$nix_shell$character";
      add_newline = false;
      palette = "everforest";
      os = {
        disabled = false;
        format = "[$symbol ]($style)";
        style = "fg:grey2";
        symbols = {
          NixOS = "";
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };
      username = {
        show_always = true;
        style_root = "fg:red";
        style_user = "fg:blue";
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = false;
        style = "fg:blue";
        format = "[@$hostname]($style) ";
      };

      directory = {
        style = "fg:orange";
        read_only_style = "fg_orange";
        truncation_length = 3;
        truncation_symbol = "…/";
        format = "[ $path]($style)[$read_only]($read_only_style) ";
      };
      git_branch = {
        style = "fg:green";
        symbol = " ";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };
      nix_shell = {
        symbol = "λ";
        impure_msg = "";
      };
      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };
      palettes = {
        everforest = {
          bg_dim = "#${colors.bg_dim}";
          bg0 = "#${colors.bg0}";
          bg1 = "#${colors.bg1}";
          bg2 = "#${colors.bg2}";
          bg3 = "#${colors.bg3}";
          bg4 = "#${colors.bg4}";
          bg5 = "#${colors.bg5}";
          bg_visual = "#${colors.bg_visual}";
          bg_red = "#${colors.bg_red}";
          bg_green = "#${colors.bg_green}";
          bg_blue = "#${colors.bg_blue}";
          bg_yellow = "#${colors.bg_yellow}";

          fg = "#${colors.fg}";
          red = "#${colors.red}";

          orange = "#${colors.orange}";
          yellow = "#${colors.yellow}";
          green = "#${colors.green}";
          aqua = "#${colors.aqua}";
          blue = "#${colors.blue}";
          purple = "#${colors.purple}";
          grey0 = "#${colors.grey0}";
          grey1 = "#${colors.grey1}";
          grey2 = "#${colors.grey2}";
          statusline1 = "#${colors.statusline1}";
          statusline2 = "#${colors.statusline2}";
          statusline3 = "#${colors.statusline3}";
        };
      };
    };
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
