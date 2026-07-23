//! Layer 3 orchestration: read an activation script, compare its declared
//! preferences against the live system, and print the result. The parsing and
//! comparison live in the `drift` library; this module only does I/O and output.

use std::path::Path;

use eyre::{Result, WrapErr};

use drift::compare::{LiveDefaults, Status, compare};
use drift::parse::parse_activation;

use crate::util::{CHECK, CROSS, dim, green, red, section};

/// Compares the preferences declared in `activate_path` against `live`.
pub fn check(activate_path: &Path, live: &dyn LiveDefaults) -> Result<usize> {
    section(&format!("system.defaults ({})", activate_path.display()));

    let script = std::fs::read_to_string(activate_path)
        .wrap_err_with(|| format!("reading {}", activate_path.display()))?;
    let declared = parse_activation(&script)?;
    let report = compare(declared, live)?;

    for entry in report.entries() {
        let label = format!("{} {}", entry.pref.domain(), entry.pref.key());
        match entry.status {
            Status::InSync => {
                let value = entry
                    .live
                    .as_ref()
                    .map(ToString::to_string)
                    .unwrap_or_default();
                println!("  {} {label:<50} {}", green(CHECK), dim(&value));
            }
            Status::Changed => {
                let live = entry
                    .live
                    .as_ref()
                    .map(ToString::to_string)
                    .unwrap_or_default();
                println!(
                    "  {} {label:<50} declared={} live={}",
                    red(CROSS),
                    entry.pref.value(),
                    red(&live)
                );
            }
            Status::Missing => {
                println!(
                    "  {} {label:<50} declared={} live={}",
                    red(CROSS),
                    entry.pref.value(),
                    red("<unset>")
                );
            }
        }
    }

    Ok(report.drifted())
}
