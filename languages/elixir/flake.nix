{
  description = "Elixir dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    expert.url = "github:elixir-lang/expert";
  };

  outputs =
    { nixpkgs, expert, ... }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ] (
          system: f nixpkgs.legacyPackages.${system} system
        );
    in
    {
      devShells = forAllSystems (
        pkgs: system: {
          default = pkgs.mkShell {
            packages = [
              pkgs.elixir
              expert.packages.${system}.default
            ];
          };
        }
      );
    };
}
