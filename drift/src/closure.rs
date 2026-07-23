//! Store-closure drift: build a configuration without activating it, then diff
//! its closure against the live generation. A non-empty diff means the config
//! was edited (or its inputs bumped) but never switched.

use std::path::Path;

use eyre::{Result, WrapErr};

use crate::config::Role;
use crate::util::{CHECK, CROSS, dim, green, red, run, section};

fn build(flake_dir: &Path, attr: &str) -> Result<String> {
    let target = format!("{}#{attr}", flake_dir.display());
    let out = run("nix", &["build", "--no-link", "--print-out-paths", &target])
        .wrap_err_with(|| format!("building {target}"))?;
    Ok(out.trim().to_string())
}

fn diff(current: &Path, built: &str, apply_hint: &str) -> Result<usize> {
    let current = std::fs::canonicalize(current)
        .wrap_err_with(|| format!("resolving {}", current.display()))?;
    let current = current.to_string_lossy();

    if current == built {
        println!("  {} {}", green(CHECK), dim("in sync"));
        return Ok(0);
    }

    let out = run("nix", &["store", "diff-closures", &current, built])?;
    let lines: Vec<&str> = out.lines().filter(|l| !l.trim().is_empty()).collect();
    if lines.is_empty() {
        println!("  {} {}", green(CHECK), dim("in sync"));
        return Ok(0);
    }

    println!("  {} {}", red(CROSS), red("closure differs:"));
    for line in &lines {
        println!("    {line}");
    }
    println!("  {}", dim(&format!("apply: {apply_hint}")));
    Ok(1)
}

/// nix-darwin system closure vs `/run/current-system`.
pub fn darwin(repo: &Path, role: Role) -> Result<usize> {
    section("darwin system closure");
    let attr = role.darwin_attr();
    let built = build(repo, &format!("darwinConfigurations.{attr}.system"))?;
    diff(
        Path::new("/run/current-system"),
        &built,
        &format!("sudo darwin-rebuild switch --flake ~/dotfiles#{attr}"),
    )
}

/// NixOS system closure vs `/run/current-system`.
pub fn nixos(repo: &Path, host: &str) -> Result<usize> {
    section("nixos system closure");
    let built = build(
        repo,
        &format!("nixosConfigurations.{host}.config.system.build.toplevel"),
    )?;
    diff(
        Path::new("/run/current-system"),
        &built,
        &format!("sudo nixos-rebuild switch --flake ~/dotfiles#{host}"),
    )
}

/// Home-manager closure vs the current home-manager profile generation.
pub fn home_manager(repo: &Path, attr: &str, profile: &Path) -> Result<usize> {
    section("home-manager closure");
    let built = build(
        repo,
        &format!("homeConfigurations.{attr}.activationPackage"),
    )?;
    diff(
        profile,
        &built,
        &format!("home-manager switch --flake ~/dotfiles#{attr}"),
    )
}
