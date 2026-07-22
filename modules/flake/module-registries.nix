{ lib, flake-parts-lib, ... }:
{
  # flake-parts core already declares `flake.nixosModules` as a mergeable
  # attribute set of modules, which is why the NixOS files can each register
  # into it. It does NOT declare darwinModules/homeModules, so declare them here
  # as the same kind of mergeable registry. Without this, two files both setting
  # e.g. flake.darwinModules.* fail with "defined multiple times".
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    darwinModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
      description = "nix-darwin modules exposed by this flake.";
    };
    homeModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
      description = "home-manager modules exposed by this flake.";
    };
  };
}
