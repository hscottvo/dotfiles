{
  # Systems that perSystem outputs (devShells, packages, formatter) are built
  # for. The actual host configurations pin their own platform; this list only
  # governs the per-system outputs.
  systems = [
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  # `nix fmt` formats the whole repo.
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt;
    };
}
