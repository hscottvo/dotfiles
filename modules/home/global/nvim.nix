{
  flake.homeModules.global-nvim = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      # Requirements for Neovim
      fd
      gcc
      gnumake
      lua
      luajitPackages.luarocks_bootstrap
      neovim
      nodejs_22
      python3
      ripgrep
      tree-sitter

      # bash
      bash-language-server
      shfmt

      # lua (dotfiles)
      lua-language-server
      stylua

      # markdown
      marksman
      rumdl
      markdownlint-cli2
      prettierd

      # nix (dotfiles)
      nixfmt

      # toml
      taplo

      unzip
    ];

    xdg.configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
    stylix.targets.neovim.enable = false;

    programs.lazygit = {
      enable = true;
      settings.customCommands = [
        {
          key = "C";
          context = "files";
          command = "cz commit";
          description = "Commit with Commitizen";
          loadingText = "Opening Commitizen...";
          output = "terminal";
        }
      ];
    };

    programs.yazi = {
      enable = true;
    };
    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
