{
  # `nix develop` (and direnv via .envrc) drops into this shell with the repo's
  # Nix/Lua tooling. Per-language shells live in ../../languages/*, separate.
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt
          stylua
          lua-language-server
          nil
        ];
      };
    };
}
