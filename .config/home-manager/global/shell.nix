{ config, pkgs, ... }:

{

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 20;
    };
    extraConfig = ''
      enable_audio_bell no
      confirm_os_window_close 0

    '';
    themeFile = "Catppuccin-Frappe";
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
    envExtra = ''
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
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      catppuccin
      resurrect
    ];

    extraConfig = ''
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };


  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

}
