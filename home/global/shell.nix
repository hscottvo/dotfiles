{ pkgs, ... }:

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
      dr = "sudo darwin-rebuild --impure switch --flake ~/.dotfiles#mbp-main";
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
    '';
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
      os = {
        disabled = false;
        format = "[$symbol ]($style)";
        symbols = {
          NixOS = "";
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };
      username = {
        show_always = true;
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = false;
        format = "[@$hostname]($style) ";
      };

      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        format = "[ $path]($style)[$read_only]($read_only_style) ";
      };
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };
      nix_shell = {
        symbol = "λ";
        impure_msg = "";
      };
      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };
    };
  };

  programs.fzf = {
    enable = true;
  };

}
