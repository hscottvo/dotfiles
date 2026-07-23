//! Per-machine drift configuration, read from `~/.config/drift/config.toml`.
//!
//! The file is written declaratively by home-manager (the mac-personal /
//! mac-work / linux modules each know their role and host), so it can't
//! disagree with what was actually built. Every field has a default, so a
//! missing file is fine — except that the Mac layers need a role, which must
//! come from the file or the `--role` flag.

use std::path::PathBuf;

use eyre::{Result, WrapErr};
use serde::Deserialize;

/// Which Mac configuration this machine builds. Selects the darwin and
/// home-manager attributes the Mac layers check against.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, clap::ValueEnum)]
#[serde(rename_all = "lowercase")]
#[clap(rename_all = "lowercase")]
pub enum Role {
    Personal,
    Work,
}

impl Role {
    /// The `darwinConfigurations.<attr>` name (`personal` / `work`).
    pub fn darwin_attr(self) -> &'static str {
        match self {
            Role::Personal => "personal",
            Role::Work => "work",
        }
    }

    /// The `homeConfigurations.<attr>` name (`scott-mac-personal` / `-work`).
    pub fn home_attr(self) -> String {
        format!("scott-mac-{}", self.darwin_attr())
    }
}

/// How input freshness is judged in the `nix` layer.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Freshness {
    /// Compare each locked input against its upstream ref (needs network),
    /// falling back to age on any per-input error.
    #[default]
    Upstream,
    /// Report only the age of each locked input; never touches the network.
    Age,
}

/// Machine-local drift settings. All fields default, so an absent config file
/// is equivalent to `Config::default()`.
#[derive(Debug, Clone, PartialEq, Eq, Deserialize)]
#[serde(default, deny_unknown_fields)]
pub struct Config {
    /// Mac role; `None` means "not a Mac, or not configured" (Mac layers then
    /// require `--role`).
    pub role: Option<Role>,
    /// NixOS host attribute to check on Linux.
    pub nixos_host: String,
    /// Freshness strategy for the `nix` layer.
    pub freshness: Freshness,
    /// Age past which an input is flagged stale (age mode, or upstream
    /// fallback).
    pub stale_days: u64,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            role: None,
            nixos_host: "main".to_string(),
            freshness: Freshness::Upstream,
            stale_days: 21,
        }
    }
}

/// Where the config file lives, honoring `XDG_CONFIG_HOME` then `HOME`.
pub fn path() -> PathBuf {
    let base = std::env::var_os("XDG_CONFIG_HOME")
        .map(PathBuf::from)
        .or_else(|| std::env::var_os("HOME").map(|h| PathBuf::from(h).join(".config")))
        .unwrap_or_default();
    base.join("drift").join("config.toml")
}

/// Loads the config, treating a missing file as defaults.
///
/// # Errors
///
/// Returns an error if the file exists but can't be read or is invalid TOML.
pub fn load() -> Result<Config> {
    let p = path();
    match std::fs::read_to_string(&p) {
        Ok(text) => toml::from_str(&text).wrap_err_with(|| format!("parsing {}", p.display())),
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => Ok(Config::default()),
        Err(e) => Err(e).wrap_err_with(|| format!("reading {}", p.display())),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn empty_toml_is_all_defaults() {
        let cfg: Config = toml::from_str("").unwrap();
        assert_eq!(cfg, Config::default());
    }

    #[test]
    fn parses_role_and_freshness() {
        let cfg: Config = toml::from_str("role = \"work\"\nfreshness = \"age\"\n").unwrap();
        assert_eq!(cfg.role, Some(Role::Work));
        assert_eq!(cfg.freshness, Freshness::Age);
    }

    #[test]
    fn home_attr_follows_role() {
        assert_eq!(Role::Personal.home_attr(), "scott-mac-personal");
        assert_eq!(Role::Work.darwin_attr(), "work");
    }

    #[test]
    fn unknown_key_is_rejected() {
        assert!(toml::from_str::<Config>("nonsense = 1\n").is_err());
    }
}
