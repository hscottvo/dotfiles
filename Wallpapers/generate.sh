nix build --impure --expr '(builtins.getFlake "github:lunik1/nix-wallpaper").packages.${builtins.currentSystem}.default.override { preset = "gruvbox-dark-rainbow"; width=1980; height = 1080;}'
