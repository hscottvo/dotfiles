{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    xdelta
  ];

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 36;
    };
    extraConfig = ''
      enable_audio_bell no
      confirm_os_window_close 0

    '';
    # themeFile = "nord";
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        -- auto reload
        automatically_reload_config = true,
        -- Use the built-in Nord color scheme
        color_scheme = "nord",

        -- Appearance
        font = wezterm.font_with_fallback({"FiraCode Nerd Font Mono", "DejaVu Math TeX Gyre"}), -- Use the font family
        font_size = 16.0, -- Adjust the font size to your preference
        line_height = 1.1,
        enable_tab_bar = false, -- Hide tab bar when only one tab

        -- Keybindings
        keys = {
          { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
          { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
        },
      }
    '';
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
      # nord
    ];

    extraConfig = ''
      # Nord Theme - from https://github.com/arcticicestudio/nord-tmux
      set -g status-bg '#2E3440'
      set -g status-fg '#D8DEE9'
      set -g message-style 'bg=#4C566A,fg=#ECEFF4'
      set-option -g pane-border-style 'fg=#4C566A'
      set-option -g pane-active-border-style 'fg=#88C0D0'

      # Window titles with powerline-style icons
      # Active window
      set-window-option -g window-status-current-format '#[fg=#2E3440,bg=#88C0D0] #[bg=#88C0D0,fg=#2E3440]#I  #W #[fg=#88C0D0,bg=#2E3440]'

      # Inactive windows
      set-window-option -g window-status-format '#[fg=#4C566A,bg=#2E3440] #[bg=#2E3440,fg=#D8DEE9]#I  #W #[fg=#2E3440,bg=#2E3440]'

      # Separator between windows
      # set -g window-status-separator ""
      set -g window-status-current-style bg='#4C566A',fg='#ECEFF4'
      set -g window-status-style bg='#2E3440',fg='#D8DEE9'
      set -g status-left '#[bg=#88C0D0,fg=#2E3440] #S #[fg=#88C0D0,bg=#2E3440,nobold,noitalics,nounderscore]'
      set -g status-right '#[fg=#88C0D0,bg=#2E3440]#[bg=#88C0D0,fg=#2E3440] %Y-%m-%d #[fg=#2E3440,bg=#88C0D0] %H:%M #[fg=#2E3440,bg=#88C0D0]'

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
      #   
      # reload config 
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
      #
      #   # vim styles
      #   setw -g mode-keys vi
      #   bind-key h select-pane -L
      #   bind-key j select-pane -D
      #   bind-key k select-pane -U
      #   bind-key l select-pane -R
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
