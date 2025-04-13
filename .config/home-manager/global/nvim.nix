{ config, pkgs, ... }:

let
  colors = config.custom.themes.everforest.colors;
in
{
  home.packages = with pkgs; [
    # Requirements for Neovim
    cargo
    fd
    gcc
    gnumake
    lazygit
    lua
    luajitPackages.luarocks_bootstrap
    nodejs_22
    python3
    ripgrep
    rustc
    tree-sitter

    # bash
    bash-language-server

    # cpp
    clang-tools

    # go
    go
    gopls
    # lua
    lua-language-server
    stylua

    # markdown
    marksman
    markdownlint-cli2
    nodePackages.prettier


    # nix
    nil
    nixpkgs-fmt

    # prettier
    prettierd

    # python
    black
    isort
    pyright

    # rust
    rustfmt
    rust-analyzer

    # toml
    taplo

    # terraform
    terraform
    terraform-ls
    tflint

    # typescript
    eslint
    eslint_d
    typescript
    typescript-language-server
    vscode-langservers-extracted

    # vue
    vue-language-server

    # YAML
    yaml-language-server

    unzip
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.yazi = {
    enable = true;
    theme = {
      manager = {

        cwd = {
          fg = colors.green;
        };

        # Hovered
        hovered = { fg = colors.bg0; bg = colors.fg; }; # Dark background, Soft beige foreground
        preview_hovered = { underline = true; };

        # Find
        find_keyword = { fg = colors.bg_visual; bg = colors.fg; italic = true; }; # Soft beige
        find_position = { fg = colors.bg_visual; bg = colors.fg; italic = true; }; # Soft red

        # Marker
        marker_selected = { fg = colors.green; bg = colors.green; }; # Soft Green
        marker_copied = { fg = colors.fg; bg = colors.fg; }; # Soft beige
        marker_cut = { fg = colors.bg_visual; bg = colors.bg_visual; }; # Soft red

        # Tab
        tab_active = { fg = colors.bg0; bg = colors.green; }; # Dark background, Soft beige foreground
        tab_inactive = { fg = colors.fg; bg = colors.bg0; }; # Soft Green on muted dark
        tab_width = 1;

        # Border
        border_symbol = "│";
        border_style = { fg = colors.green; }; # Muted Green

        # Highlighting
        syntect_theme = "~/.config/bat/themes/Everforest-Soft.tmTheme";
      };

      mode = {
        normal_main = { fg = colors.bg0; bg = colors.statusline1; };
        normal_alt = { fg = colors.statusline1; bg = colors.bg0; };
        select_main = { fg = colors.bg0; bg = colors.statusline3; };
        select_alt = { fg = colors.statusline3; bg = colors.bg0; };
        unset_main = { fg = colors.bg0; bg = colors.statusline2; };
        unset_alt = { fg = colors.statusline2; bg = colors.bg0; };
      };


      status = {

        # Progress
        progress_label = { fg = colors.fg; bold = true; };
        progress_normal = { fg = colors.fg; bg = colors.bg1; }; # Soft beige on muted dark
        progress_error = { fg = colors.bg_visual; bg = colors.bg1; }; # Soft red on muted dark

        # Permissions
        permissions_t = { fg = colors.fg; }; # Soft beige
        permissions_r = { fg = colors.fg; }; # Soft beige
        permissions_w = { fg = colors.bg_visual; }; # Soft red
        permissions_x = { fg = colors.green; }; # Soft Green
        permissions_s = { fg = colors.bg_green; }; # Muted Green
      };


      input = {
        border = { fg = colors.fg; }; # Soft beige
        title = { };
        value = { };
        selected = { reversed = true; };
      };


      select = {
        border = { fg = colors.fg; }; # Soft beige
        active = { fg = colors.bg_visual; }; # Soft red
        inactive = { };
      };

      tasks = {
        border = { fg = colors.fg; }; # Soft beige
        title = { };
        hovered = { underline = true; };
      };

      which = {
        mask = { bg = colors.bg0; }; # Dark background
        cand = { fg = colors.green; }; # Soft Green
        rest = { fg = colors.fg; }; # Soft beige
        desc = { fg = colors.bg_visual; }; # Soft red
        separator = "  ";
        separator_style = { fg = colors.bg1; }; # Muted dark
      };

      help = {
        on = { fg = colors.bg_visual; }; # Soft red
        run = { fg = colors.green; }; # Soft Green
        desc = { fg = colors.fg; }; # Soft beige
        hovered = { bg = colors.bg1; bold = true; }; # Muted dark background
        footer = { fg = colors.bg0; bg = colors.statusline2; }; # Dark background, Soft beige foreground
      };

      filetype = {

        rules = [
          # Images
          { mime = "image/*"; fg = colors.green; } # Soft Green

          # Videos
          { mime = "video/*"; fg = colors.fg; } # Soft beige
          { mime = "audio/*"; fg = colors.fg; } # Soft beige

          # Archives
          { mime = "application/zip"; fg = colors.bg_visual; } # Soft red
          { mime = "application/gzip"; fg = colors.bg_visual; } # Soft red
          { mime = "application/x-tar"; fg = colors.bg_visual; } # Soft red
          { mime = "application/x-bzip"; fg = colors.bg_visual; } # Soft red
          { mime = "application/x-bzip2"; fg = colors.bg_visual; } # Soft red
          { mime = "application/x-7z-compressed"; fg = colors.bg_visual; } # Soft red
          { mime = "application/x-rar"; fg = colors.bg_visual; } # Soft red

          # Fallback
          { name = "*"; fg = colors.fg; } # Soft beige
          { name = "*/"; fg = colors.fg; } # Soft beige
        ];
      };
    };



  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

