{
  # Linux-only Neovim extras (on top of global-nvim).
  flake.homeModules.linux-nvim =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ libgcc ];
    };
}
