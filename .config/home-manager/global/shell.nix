{ config, pkgs, ... }:

let
  colors = config.custom.themes.everforest.colors;
in
{

  home.packages = with pkgs; [
    act
    bacon
    commitizen
    dust
    pre-commit
    wget
    xdelta
  ];

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
      neofetch = "fastfetch";
    };
    oh-my-zsh = {

      enable = true;
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
    envExtra = ''
      source <(fzf --zsh)
      eval $(keychain --quiet --eval --agents ssh ~/.ssh/git)
    '';
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
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
  };
  stylix.targets.starship.enable = false;

  programs.fzf = {
    enable = true;
  };

}
