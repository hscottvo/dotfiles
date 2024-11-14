{ config, pkgs, ... }:

{
  home.username = "scott";
  home.homeDirectory = "/home/scott";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    keychain
    xclip
    p7zip

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.zsh = {
    enable = true;
    # autosuggestion.enable = true;
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
      # gruvbox
      nord
      # mode-indicator
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

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/scott/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
