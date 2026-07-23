//! Flake-input freshness and uncommitted-config drift.
//!
//! In `upstream` mode each direct input's locked rev is compared against its
//! upstream ref (a network fetch), reporting how far behind it is; any per-input
//! failure (offline, non-github source) falls back to reporting the input's
//! age. In `age` mode only the offline age heuristic runs. Inputs pinned to an
//! explicit rev are reported as pinned and never flagged.
//!
//! We also flag a dirty working tree: the darwin config stamps `dirtyRev`, so
//! an uncommitted flake means the applied generation isn't reproducible from
//! git.

use std::path::Path;
use std::time::{SystemTime, UNIX_EPOCH};

use eyre::{Result, WrapErr};
use serde_json::Value;

use crate::config::{Config, Freshness};
use crate::util::{CHECK, CROSS, WARN, capture, dim, green, red, run, section, yellow};

const SECONDS_PER_DAY: u64 = 86_400;

fn now_unix() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_secs())
        .unwrap_or(0)
}

/// Queries an input's upstream ref for its current tip, returning
/// `(rev, lastModified)`. Errors (offline, unknown source) trigger age fallback.
fn upstream_tip(url: &str) -> Result<(String, u64)> {
    let out = run("nix", &["flake", "metadata", "--json", "--refresh", url])
        .wrap_err_with(|| format!("nix flake metadata {url}"))?;
    let meta: Value = serde_json::from_str(&out).wrap_err("parsing upstream metadata")?;
    let rev = meta["locked"]["rev"]
        .as_str()
        .ok_or_else(|| eyre::eyre!("no rev for {url}"))?;
    let last_modified = meta["locked"]["lastModified"]
        .as_u64()
        .ok_or_else(|| eyre::eyre!("no lastModified for {url}"))?;
    Ok((rev.to_string(), last_modified))
}

/// Reconstructs a queryable flake URL for a github `original`, or `None` for
/// sources we don't know how to check upstream.
fn github_url(original: &Value) -> Option<String> {
    if original["type"].as_str()? != "github" {
        return None;
    }
    let owner = original["owner"].as_str()?;
    let repo = original["repo"].as_str()?;
    let mut url = format!("github:{owner}/{repo}");
    if let Some(git_ref) = original["ref"].as_str() {
        url.push('/');
        url.push_str(git_ref);
    }
    Some(url)
}

/// Prints one line for an input judged only by the age of its locked rev.
fn report_age(name: &str, locked_modified: u64, now: u64, stale_days: u64, note: &str) {
    let days = now.saturating_sub(locked_modified) / SECONDS_PER_DAY;
    if days >= stale_days {
        println!(
            "  {} {name:<16} {}{note}",
            yellow(WARN),
            yellow(&format!("{days}d old"))
        );
    } else {
        println!(
            "  {} {name:<16} {}{note}",
            green(CHECK),
            dim(&format!("{days}d old"))
        );
    }
}

/// Reports one direct input, choosing pinned / upstream / age as appropriate.
fn report_input(name: &str, node: &Value, mode: Freshness, stale_days: u64, now: u64) {
    let locked = &node["locked"];
    let original = &node["original"];

    let Some(locked_modified) = locked["lastModified"].as_u64() else {
        println!("  {} {name:<16} {}", dim(WARN), dim("no timestamp"));
        return;
    };

    // Intentionally pinned to a rev (e.g. mac-app-util): not drift.
    if original.get("rev").and_then(Value::as_str).is_some() {
        println!("  {} {name:<16} {}", green(CHECK), dim("pinned"));
        return;
    }

    if mode == Freshness::Age {
        report_age(name, locked_modified, now, stale_days, "");
        return;
    }

    // Upstream mode: compare against the ref's current tip, else fall back.
    let locked_rev = locked["rev"].as_str().unwrap_or_default();
    match github_url(original).map(|url| upstream_tip(&url)) {
        Some(Ok((upstream_rev, _))) if upstream_rev == locked_rev => {
            println!("  {} {name:<16} {}", green(CHECK), dim("up to date"));
        }
        Some(Ok((_, upstream_modified))) => {
            let behind = upstream_modified.saturating_sub(locked_modified) / SECONDS_PER_DAY;
            println!(
                "  {} {name:<16} {}",
                yellow(WARN),
                yellow(&format!("{behind}d behind upstream"))
            );
        }
        _ => report_age(
            name,
            locked_modified,
            now,
            stale_days,
            dim(" (age; upstream unavailable)").as_str(),
        ),
    }
}

/// Advisory only: reports each direct flake input. Freshness measures distance
/// from upstream, not config-vs-system drift, so it never gates the exit code.
fn freshness(flake_dir: &Path, mode: Freshness, stale_days: u64) -> Result<()> {
    let out = run(
        "nix",
        &[
            "flake",
            "metadata",
            "--json",
            &flake_dir.display().to_string(),
        ],
    )
    .wrap_err_with(|| format!("nix flake metadata {}", flake_dir.display()))?;
    let meta: Value = serde_json::from_str(&out).wrap_err("parsing flake metadata")?;

    let nodes = &meta["locks"]["nodes"];
    let now = now_unix();

    for (name, node_ref) in nodes["root"]["inputs"].as_object().into_iter().flatten() {
        let Some(node_key) = node_ref.as_str() else {
            continue; // a `follows` entry, not an independent input
        };
        report_input(name, &nodes[node_key], mode, stale_days, now);
    }
    Ok(())
}

fn dirty(repo: &Path) -> Result<usize> {
    let out = capture(
        "git",
        &["-C", &repo.display().to_string(), "status", "--porcelain"],
    )?;
    let changed: Vec<&str> = out
        .stdout
        .lines()
        .filter(|line| {
            let file = line.get(3..).unwrap_or_default();
            file.ends_with(".nix") || file.ends_with("flake.lock")
        })
        .collect();

    if changed.is_empty() {
        println!(
            "  {} {}",
            green(CHECK),
            dim("working tree clean (nix/lock)")
        );
        return Ok(0);
    }
    println!(
        "  {} {}",
        red(CROSS),
        red(&format!(
            "{} uncommitted nix/lock change(s):",
            changed.len()
        ))
    );
    for entry in &changed {
        println!("    {}", entry.trim());
    }
    Ok(1)
}

/// Reports the single root flake's input freshness (advisory) and returns the
/// count of hard drift: uncommitted nix/lock changes.
pub fn check(repo: &Path, cfg: &Config) -> Result<usize> {
    let label = match cfg.freshness {
        Freshness::Upstream => "flake input freshness vs upstream (advisory)",
        Freshness::Age => "flake input age (advisory)",
    };
    section(label);
    freshness(repo, cfg.freshness, cfg.stale_days)?;

    section("uncommitted config");
    dirty(repo)
}
