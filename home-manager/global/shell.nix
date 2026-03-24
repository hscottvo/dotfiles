{ config, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  colors = config.lib.stylix.colors.withHashtag;
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
      command = "tmux new-session -A -s main";
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

  home.file."dotfiles/tmux/theme.conf".text = ''
    # mode (copy mode highlight)
    set-option -g mode-style fg=${colors.base00},bg=${colors.base05}

    # panes
    set -g window-active-style bg=${colors.base00}
    set -g pane-active-border fg=${colors.base0B}

    # status bar
    set-option -g status-style bg=${colors.base01},fg=${colors.base05}
    set -g status-left-length 150
    set -g status-left "\
    #[fg=${colors.base01}, bg=${colors.base0D}, bold] #(whoami)\
      #[bg=${colors.base01}, fg=${colors.base0D}]\
      #[bg=${colors.base01}, fg=${colors.base05}]#S\
      #[fg=${colors.base05}, bg=${colors.base01}]"

    set-option -g status-right-style none
    set -g status-right-length 150
    set -g status-right "\
      #[fg=${colors.base03}, bg=${colors.base01}]#[bg=${colors.base03}, fg=${colors.base05}] %Y-%m-%d\
      #[bg=${colors.base03}, fg=${colors.base02}]#[fg=${colors.base0D}, bg=${colors.base02}] %H:%M\
      #[fg=${colors.base0D}, bg=${colors.base02}]#[fg=${colors.base00}, bg=${colors.base0D}, bold] #h "

    # active window
    set-window-option -g window-status-current-format "\
      #[fg=${colors.base01}, bg=${colors.base0D}]\
      #[fg=${colors.base01}, bg=${colors.base0D}]#I\
      #[fg=${colors.base01}, bg=${colors.base0D}, bold]#W\
      #[fg=${colors.base0D}, bg=${colors.base01}]"

    # inactive window
    set-window-option -g window-status-format "\
      #[fg=${colors.base01}, bg=${colors.base01}]\
      #[fg=${colors.base05}, bg=${colors.base01}]#I\
      #W\
      #[fg=${colors.base01}, bg=${colors.base01}]"
  '';
  programs.tmux = {
    enable = true;
    secureSocket = false;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      resurrect
    ];
    extraConfig = ''
      source-file ${dotfilesDir}/tmux/tmux.conf
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
        format = "[ $path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        style = "fg:green";
        symbol = "[ ](bold red)";
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

      # inject Stylix-generated palette
      # palettes.everforest = everforestPalette;
    };
  };
  stylix.targets.starship.enable = true;

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
