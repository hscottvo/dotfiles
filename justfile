# Dotfiles tasks. Run `just` for the list.

drift_crate := "drift/Cargo.toml"
drift := "cargo run --quiet --release --manifest-path " + drift_crate + " --"

_default:
    @just --list

# Detect drift between the nix config and this machine (OS-aware, all layers).
drift:
    {{drift}} all

# Layer 3 only: nix-darwin system.defaults vs live macOS prefs.
drift-defaults:
    {{drift}} defaults

# Darwin: system closure + homebrew + system.defaults (macOS).
drift-darwin:
    {{drift}} darwin

# NixOS system closure (Linux).
drift-nixos:
    {{drift}} nixos

# Home-manager closure drift.
drift-home:
    {{drift}} home

# Flake input freshness + uncommitted-config check.
drift-nix:
    {{drift}} nix

# Unit-test the drift tool.
drift-test:
    cargo test --manifest-path {{drift_crate}}
