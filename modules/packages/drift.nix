{
  # The `drift` CLI (source in ../../drift). Exposed as a per-system package so
  # it can be `nix run .#drift` and installed onto PATH via home.packages (see
  # ../home/configurations.nix). Runtime deps (nix, git, defaults, brew) are
  # expected on PATH, not wrapped in.
  perSystem =
    { pkgs, ... }:
    {
      packages.drift = pkgs.rustPlatform.buildRustPackage {
        pname = "drift";
        version = "0.1.0";
        src = ../../drift;
        cargoLock.lockFile = ../../drift/Cargo.lock;
        meta.mainProgram = "drift";
      };
    };
}
