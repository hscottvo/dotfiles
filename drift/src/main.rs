//! `drift` — detect divergence between the declared nix config and this
//! machine's live state. On macOS it checks the nix-darwin system, its
//! homebrew casks, and its `system.defaults`; on NixOS it checks the system
//! closure. Everywhere it checks the home-manager closure and flake hygiene:
//!   1. store closure   (nix-darwin / NixOS system, home-manager) — "edited, not switched"
//!   2. homebrew        (declared casks/brews vs installed)          [macOS]
//!   3. system.defaults (nix-darwin's fire-and-forget macOS prefs)   [macOS]
//!   + flake-input freshness and an uncommitted-config warning.
//!
//! The config is one flake at the repo root; which system/home attribute to
//! check is selected by machine: the Mac role (personal/work) comes from
//! `~/.config/drift/config.toml` or `--role`, the NixOS host from the config.

mod brew;
mod closure;
mod config;
mod defaults;
mod nixlock;
mod system;
mod util;

use std::path::{Path, PathBuf};

use clap::{Parser, Subcommand};
use eyre::{Result, WrapErr, eyre};

use config::{Config, Role};
use system::SystemDefaults;
use util::{CROSS, bold, dim, green, red, run};

/// True on macOS (nix-darwin), false on NixOS. Decides which layers `all` runs.
const IS_MACOS: bool = cfg!(target_os = "macos");

/// In aggregate modes, a single layer failing to evaluate shouldn't abort the
/// rest. Report the failure under its already-printed section and count it as
/// one drift item so the run still exits non-zero.
fn guarded(result: Result<usize>) -> usize {
    match result {
        Ok(n) => n,
        Err(e) => {
            println!("  {} {}", red(CROSS), red(&format!("check errored: {e}")));
            1
        }
    }
}

#[derive(Parser)]
#[command(
    name = "drift",
    about = "Detect drift between your nix config and this machine"
)]
struct Cli {
    /// Dotfiles repo root (the flake).
    #[arg(long, default_value = "~/dotfiles", global = true)]
    repo: String,

    /// Override the configured Mac role (personal|work).
    #[arg(long, global = true)]
    role: Option<Role>,

    #[command(subcommand)]
    command: Option<Command>,
}

#[derive(Subcommand)]
enum Command {
    /// Run every check that applies to this OS (the default).
    All,
    /// Darwin: system closure, homebrew, and system.defaults (macOS only).
    Darwin,
    /// NixOS: system closure (Linux only).
    Nixos,
    /// Only the system.defaults comparison (layer 3, macOS only).
    Defaults {
        /// Build a fresh system from the flake instead of reading the live one.
        #[arg(long)]
        build: bool,
        /// Compare against a specific activation script instead of the live one.
        #[arg(long)]
        activate_file: Option<PathBuf>,
    },
    /// Home-manager closure.
    Home,
    /// Flake-input freshness and uncommitted-config warning.
    Nix,
}

/// Resolved paths for a run: the flake root and the live home-manager profile.
struct Paths {
    repo: PathBuf,
    hm_profile: PathBuf,
}

impl Paths {
    fn resolve(repo: &str) -> Self {
        Self {
            repo: expand_tilde(repo),
            hm_profile: expand_tilde("~/.local/state/nix/profiles/home-manager"),
        }
    }
}

fn expand_tilde(path: &str) -> PathBuf {
    match (path.strip_prefix("~/"), std::env::var_os("HOME")) {
        (Some(rest), Some(home)) => PathBuf::from(home).join(rest),
        _ => PathBuf::from(path),
    }
}

/// The Mac role, from `--role` or the config file. Errors with a pointer to the
/// fix when neither supplies one (only reached on the Mac layers).
fn require_role(cli_role: Option<Role>, cfg: &Config) -> Result<Role> {
    cli_role.or(cfg.role).ok_or_else(|| {
        eyre!(
            "no Mac role set — add `role = \"personal\"` (or \"work\") to {} or pass --role",
            config::path().display()
        )
    })
}

/// The home-manager attribute to check: the Mac role's on macOS, `scott-linux`
/// on NixOS.
fn home_attr(cli_role: Option<Role>, cfg: &Config) -> Result<String> {
    if IS_MACOS {
        Ok(require_role(cli_role, cfg)?.home_attr())
    } else {
        Ok("scott-linux".to_string())
    }
}

/// The activation script to compare against: the live generation, or a freshly
/// built one when `--build` is passed.
fn activate_path(repo: &Path, role: Role, build: bool) -> Result<PathBuf> {
    if !build {
        return Ok(PathBuf::from("/run/current-system/activate"));
    }
    let target = format!(
        "{}#darwinConfigurations.{}.system",
        repo.display(),
        role.darwin_attr()
    );
    let out = run("nix", &["build", "--no-link", "--print-out-paths", &target])
        .wrap_err_with(|| format!("building {target}"))?;
    Ok(PathBuf::from(out.trim()).join("activate"))
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let cli = Cli::parse();
    let cfg = config::load()?;
    let paths = Paths::resolve(&cli.repo);
    let live = SystemDefaults::new();

    let drifted = match cli.command.unwrap_or(Command::All) {
        Command::Defaults {
            build,
            activate_file,
        } => {
            let path = match activate_file {
                Some(path) => path,
                None => activate_path(&paths.repo, require_role(cli.role, &cfg)?, build)?,
            };
            defaults::check(&path, &live)?
        }
        Command::Darwin => darwin_layers(&paths, require_role(cli.role, &cfg)?, &live),
        Command::Nixos => closure::nixos(&paths.repo, &cfg.nixos_host)?,
        Command::Home => {
            closure::home_manager(&paths.repo, &home_attr(cli.role, &cfg)?, &paths.hm_profile)?
        }
        Command::Nix => nixlock::check(&paths.repo, &cfg)?,
        Command::All => {
            let mut n = 0;
            if IS_MACOS {
                n += darwin_layers(&paths, require_role(cli.role, &cfg)?, &live);
            } else {
                n += guarded(closure::nixos(&paths.repo, &cfg.nixos_host));
            }
            n += guarded(closure::home_manager(
                &paths.repo,
                &home_attr(cli.role, &cfg)?,
                &paths.hm_profile,
            ));
            n + guarded(nixlock::check(&paths.repo, &cfg))
        }
    };

    println!();
    if drifted == 0 {
        println!("{}", green(&bold("✓ no drift detected")));
        Ok(())
    } else {
        println!(
            "{} {}",
            red(&bold(&format!("✗ {drifted} item(s) drifted"))),
            dim("— see sections above")
        );
        std::process::exit(1);
    }
}

/// The three macOS layers: system closure, homebrew, and system.defaults.
fn darwin_layers(paths: &Paths, role: Role, live: &dyn drift::compare::LiveDefaults) -> usize {
    guarded(closure::darwin(&paths.repo, role))
        + guarded(brew::check(&paths.repo, role))
        + guarded(
            activate_path(&paths.repo, role, false).and_then(|path| defaults::check(&path, live)),
        )
}
