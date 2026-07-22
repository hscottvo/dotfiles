{
  description = "scott's dotfiles: NixOS, nix-darwin, and home-manager in one flake";

  # Every input is declared once here and shared by every configuration, so
  # there is a single flake.lock to update (`nix flake update`, or the
  # `bump-locks` shell alias).
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Dendritic wiring: flake-parts gives us the module system for flake
    # outputs; import-tree turns every *.nix file under ./modules into a
    # flake-parts module automatically (no central import list to maintain).
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # cl-nix-lite override keeps mac-app-util building on darwin. Pinned to a
    # known-good rev: newer mac-app-util pulls an SBCL/lisp stack that fails to
    # build fare-quasiquote-readtable. Bump only after checking it builds.
    mac-app-util.url = "github:hraban/mac-app-util/4747968574ea58512c5385466400b2364c85d2d0";
    mac-app-util.inputs.cl-nix-lite.url = "github:r4v3n6101/cl-nix-lite/url-fix";

    stylix.url = "github:danth/stylix";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # noctalia-shell wrapper, used by the niri feature.
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  # import-tree ./modules loads every module under modules/. To add config,
  # drop a new *.nix file in the matching directory; it is picked up on the
  # next rebuild with no edit here.
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
