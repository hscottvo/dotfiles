//! Homebrew drift. With `onActivation.cleanup = "uninstall"` the next switch
//! already reconciles this, so the check just surfaces it ahead of time:
//! declared casks/brews (read from the evaluated darwin config) vs installed.

use std::collections::BTreeSet;
use std::path::Path;

use eyre::{Result, WrapErr};

use crate::config::Role;
use crate::util::{CHECK, CROSS, capture, dim, green, red, run, section};

fn declared(repo: &Path, role: Role, attr: &str) -> Result<BTreeSet<String>> {
    let target = format!(
        "{}#darwinConfigurations.{}.config.homebrew.{attr}",
        repo.display(),
        role.darwin_attr()
    );
    // nix-darwin normalizes casks/brews into submodules ({ name = ...; ... }),
    // so project each entry down to its package name (a bare string stays as-is).
    let apply = "x: map (e: if builtins.isString e then e else e.name) x";
    let out = run("nix", &["eval", "--json", "--apply", apply, &target])
        .wrap_err_with(|| format!("nix eval {target}"))?;
    let names: Vec<String> = serde_json::from_str(&out).wrap_err("parsing homebrew list")?;
    Ok(names.into_iter().collect())
}

/// Names from a `brew` listing; an empty set if brew is absent or errors.
fn installed(args: &[&str]) -> BTreeSet<String> {
    match capture("brew", args) {
        Ok(out) if out.success => out.stdout.split_whitespace().map(str::to_string).collect(),
        _ => BTreeSet::new(),
    }
}

fn report(kind: &str, declared: &BTreeSet<String>, installed: &BTreeSet<String>) -> usize {
    let missing: Vec<_> = declared.difference(installed).collect();
    let extra: Vec<_> = installed.difference(declared).collect();

    for name in &missing {
        println!(
            "  {} {kind} {name:<26} {}",
            red(CROSS),
            dim("declared, not installed")
        );
    }
    for name in &extra {
        println!(
            "  {} {kind} {name:<26} {}",
            red(CROSS),
            dim("installed, uninstalled on next switch")
        );
    }
    if missing.is_empty() && extra.is_empty() {
        println!(
            "  {} {kind} {}",
            green(CHECK),
            dim(&format!("{} in sync", declared.len()))
        );
    }
    missing.len() + extra.len()
}

/// Compares declared homebrew casks and brews against what's installed.
pub fn check(repo: &Path, role: Role) -> Result<usize> {
    section("homebrew");
    let mut drift = 0;

    let casks = declared(repo, role, "casks")?;
    drift += report("cask", &casks, &installed(&["list", "--cask", "-1"]));

    // `brew leaves` lists top-level formulae, the fair comparison to declared brews.
    let brews = declared(repo, role, "brews")?;
    if !brews.is_empty() {
        drift += report("brew", &brews, &installed(&["leaves"]));
    }

    Ok(drift)
}
