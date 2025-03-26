{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
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
    # themeFile = "nord";
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Everforest Dark - Hard";
    };
  };

  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
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
      if [ -x "$(command -v tmux)" ] && [ -n "$DISPLAY" ] && [ -z "$TMUX" ]; then
          # Check for existing tmux sessions
          if tmux list-sessions 2>/dev/null | grep -q "^[^:]*:"; then
              # Attach to the last session
              exec tmux attach-session -t "$(tmux list-sessions | awk 'NR==1{print $1}' | sed 's/:$//')" >/dev/null 2>&1
          else
              # Create a new session
              exec tmux new-session -s "$USER" >/dev/null 2>&1
          fi
      fi
    '';
    # ZSH_CUSTOM=$HOME/.config/oh-my-zsh
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      resurrect
    ];

    extraConfig = ''
      ## COLORSCHEME: everforest dark medium
      set -g @everforest_bg_dim '#232a2e'
      set -g @everforest_bg0 '#2d353b'
      set -g @everforest_bg1 '#343f44'
      set -g @everforest_bg2 '#3d484d'
      set -g @everforest_bg3 '#475258'
      set -g @everforest_bg4 '#4f585e'
      set -g @everforest_bg5 '#56635f'
      set -g @everforest_bg_visual '#543a48'
      set -g @everforest_bg_red '#514045'
      set -g @everforest_bg_green '#425047'
      set -g @everforest_bg_blue '#3a515d'
      set -g @everforest_bg_yellow '#4d4c43'
  
      set -g @everforest_fg '#d3c6aa'
      set -g @everforest_red '#e67e80'
      set -g @everforest_orange '#e69875'
      set -g @everforest_yellow '#dbbc7f'
      set -g @everforest_green '#a7c080'
      set -g @everforest_aqua '#83c092'
      set -g @everforest_blue '#7fbbb3'
      set -g @everforest_purple '#d699b6'
      set -g @everforest_grey0 '#7a8478'
      set -g @everforest_grey1 '#859289'
      set -g @everforest_grey2 '#9da9a0'
      set -g @everforest_statusline1 '#a7c080'
      set -g @everforest_statusline2 '#d3c6aa'
      set -g @everforest_statusline3 '#e67e80'
  
      set-option -g status "on"
      set -g status-interval 2
  
      set-option -g status-fg '#d3c6aa' # fg (No idea why I can't use variables here)
      set-option -g status-bg '#2d353b' # bg0
  
      set-option -g mode-style fg='#{@everforest_purple}',bg='#{@everforest_bg_red}' # fg=purple, bg=bg_visual
  
      # default statusbar colors
      set-option -g status-style fg='#{@everforest_fg}',bg='#{@everforest_bg_dim}',default # fg=fg bg=bg_dim
  
      # ---- Windows ----
      # default window title colors
      set-window-option -g window-status-style fg='#{@everforest_bg5}',bg='#{@everforest_bg0}' # fg=yellow bg=bg0
  
      # default window with an activity alert
      set-window-option -g window-status-activity-style 'bg=#{@everforest_bg1},fg=#{@everforest_bg3}' # bg=bg1, fg=fg3
  
      # active window title colors
      set-window-option -g window-status-current-style fg='#{@everforest_fg}',bg='#{@everforest_bg_green}' # fg=fg bg=bg_green
  
      # ---- Pane ----
      # pane borders
      set-option -g pane-border-style fg='#{@everforest_bg1}' # fg=bg1
      set-option -g pane-active-border-style 'fg=#{@everforest_blue}' # fg=blue
  
      # pane number display
      set-option -g display-panes-active-colour '#7fbbb3' # blue
      set-option -g display-panes-colour '#e69875' # orange
  
      # ---- Command ----
      # message info
      set-option -g message-style fg='#{@everforest_statusline3}',bg='#{@everforest_bg_dim}' # fg=statusline3 bg=bg_dim
  
      # writing commands inactive
      set-option -g message-command-style 'fg=#{@everforest_bg3},bg=#{@everforest_bg1}' # bg=fg3, fg=bg1
  
      # ---- Miscellaneous ----
      # clock
      set-window-option -g clock-mode-colour '#7fbbb3' #blue
  
      # bell
      set-window-option -g window-status-bell-style fg='#{@everforest_bg0}',bg='#{@everforest_statusline3}' # fg=bg, bg=statusline3
  
      # ---- Formatting ----
      set-option -g status-left-style none
      set -g status-left-length 60
      set -g status-left '#[fg=#{@everforest_bg_dim},bg=#{@everforest_green},bold] #S #[fg=#{@everforest_green},bg=#{@everforest_bg2},nobold]#[fg=#{@everforest_green},bg=#{@everforest_bg2},bold] #(whoami) #[fg=#{@everforest_bg2},bg=#{@everforest_bg0},nobold]'
  
      set-option -g status-right-style none
      set -g status-right-length 150
      set -g status-right '#[fg=#{@everforest_bg2}]#[fg=#{@everforest_fg},bg=#{@everforest_bg2}] #[fg=#{@everforest_fg},bg=#{@everforest_bg2}]%Y-%m-%d  %H:%M #[fg=#{@everforest_aqua},bg=#{@everforest_bg2},bold]#[fg=#{@everforest_bg_dim},bg=#{@everforest_aqua},bold] #h '
  
      set -g window-status-separator '#[fg=#{@everforest_grey2},bg=#{@everforest_bg0}] '
      set -g window-status-format "#[fg=#{@everforest_grey0},bg=#{@everforest_bg0}] #I  #[fg=#{@everforest_grey0},bg=#{@everforest_bg0}]#W "
      set -g window-status-current-format "#[fg=#{@everforest_bg0},bg=#{@everforest_bg_green}]#[fg=#{@everforest_fg},bg=#{@everforest_bg_green}] #I  #[fg=#{@everforest_fg},bg=#{@everforest_bg_green},bold]#W #[fg=#{@everforest_bg_green},bg=#{@everforest_bg0},nobold]"

      set-option -g default-terminal "screen-256color"
      set-option -a terminal-features 'xterm-256color:RGB'
      set-option -g focus-events on


      #   set -ga terminal-overrides ",*256col*:Tc"
      #   set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      #
      # Mouse works as expected
      set-option -g mouse on
      #   
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # reload config 
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
    '';
  };

  programs.bat = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # settings = {
    #   # Add your Starship configuration here.
    #   prompt_order = [
    #     "username"
    #     "hostname"
    #     "directory"
    #     "git_status"
    #     "cmd_duration"
    #     "line_break"
    #     "jobs"
    #     "character"
    #   ];
    #   add_newline = true;
    # };
  };

  programs.fzf = {
    enable = true;
  };

}
