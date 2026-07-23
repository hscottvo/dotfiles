//! Terminal helpers for the binary: TTY-aware color and a small command runner.

use std::io::IsTerminal;
use std::process::Command;
use std::sync::OnceLock;

use eyre::{Result, eyre};

pub const CHECK: &str = "\u{2713}";
pub const CROSS: &str = "\u{2717}";
pub const WARN: &str = "\u{2022}";

fn use_color() -> bool {
    static ON: OnceLock<bool> = OnceLock::new();
    *ON.get_or_init(|| std::io::stdout().is_terminal() && std::env::var_os("NO_COLOR").is_none())
}

fn paint(code: &str, text: &str) -> String {
    if use_color() {
        format!("\x1b[{code}m{text}\x1b[0m")
    } else {
        text.to_string()
    }
}

pub fn green(text: &str) -> String {
    paint("32", text)
}
pub fn red(text: &str) -> String {
    paint("31", text)
}
pub fn yellow(text: &str) -> String {
    paint("33", text)
}
pub fn dim(text: &str) -> String {
    paint("2", text)
}
pub fn bold(text: &str) -> String {
    paint("1", text)
}

pub fn section(title: &str) {
    println!("\n{}", bold(&format!("── {title}")));
}

/// Output of a finished child process.
pub struct Output {
    pub success: bool,
    pub stdout: String,
    pub stderr: String,
}

/// Runs a command and returns its stdout, treating a non-zero exit as an error.
pub fn run(program: &str, args: &[&str]) -> Result<String> {
    let out = capture(program, args)?;
    if !out.success {
        return Err(eyre!(
            "`{program} {}` failed: {}",
            args.join(" "),
            out.stderr.trim()
        ));
    }
    Ok(out.stdout)
}

/// Runs a command and returns its full [`Output`], where a non-zero exit is an
/// expected, informative result rather than an error (e.g. `git status`, `brew`).
pub fn capture(program: &str, args: &[&str]) -> Result<Output> {
    let out = Command::new(program)
        .args(args)
        .output()
        .map_err(|e| eyre!("spawning `{program}`: {e}"))?;
    Ok(Output {
        success: out.status.success(),
        stdout: String::from_utf8_lossy(&out.stdout).into_owned(),
        stderr: String::from_utf8_lossy(&out.stderr).into_owned(),
    })
}
