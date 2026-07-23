//! Recovering declared preferences from a nix-darwin activation script.
//!
//! nix-darwin emits one `defaults ... write <domain> <key> '<plist-xml>'` per
//! declared preference. Parsing that script is the authoritative way to learn
//! both the intended value and the exact domain macOS stores it under (the nix
//! attribute names, e.g. `dock` or `trackpad`, do not map to domains directly).

use std::io::Cursor;
use std::sync::LazyLock;

use regex::Regex;
use thiserror::Error;

use crate::domain::{Domain, DomainError};
use crate::pref::{DeclaredPref, PrefValue};

/// A single-quoted plist value never contains a `'` (plist XML quotes with `"`),
/// so a non-greedy match to the next `'` captures the whole multi-line value.
static WRITE_CMD: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r"(?s)defaults\s+(?:-currentHost\s+)?write\s+(\S+)\s+(\S+)\s+'(.*?)'")
        .expect("WRITE_CMD regex is valid")
});

/// Why an activation script could not be parsed into declared preferences.
#[derive(Debug, Error)]
pub enum ParseError {
    #[error("no `defaults write` commands found in activation script")]
    NoDefaults,
    #[error("invalid domain for key {key}")]
    Domain {
        key: String,
        #[source]
        source: DomainError,
    },
    #[error("could not parse plist value for {domain} {key}: {blob:?}")]
    Value {
        domain: String,
        key: String,
        blob: String,
    },
}

/// Extracts every declared preference from an activation script.
///
/// # Errors
///
/// Returns [`ParseError::NoDefaults`] if the script contains no recognizable
/// `defaults write` command, or a per-entry error if a domain or value in an
/// otherwise-matching command cannot be parsed.
pub fn parse_activation(script: &str) -> Result<Vec<DeclaredPref>, ParseError> {
    let mut prefs = Vec::new();
    for caps in WRITE_CMD.captures_iter(script) {
        let raw_domain = &caps[1];
        let key = caps[2].to_string();
        let blob = &caps[3];

        let domain = Domain::new(raw_domain).map_err(|source| ParseError::Domain {
            key: key.clone(),
            source,
        })?;
        let value = parse_plist_value(blob).ok_or_else(|| ParseError::Value {
            domain: domain.as_str().to_string(),
            key: key.clone(),
            blob: blob.to_string(),
        })?;

        prefs.push(DeclaredPref::new(domain, key, value));
    }

    if prefs.is_empty() {
        return Err(ParseError::NoDefaults);
    }
    Ok(prefs)
}

/// Parses a serialized plist scalar. Handles fully-wrapped plists via the
/// `plist` crate and falls back to a bare-fragment reader for values written
/// without a `<plist>` envelope.
fn parse_plist_value(blob: &str) -> Option<PrefValue> {
    if let Ok(value) = plist::Value::from_reader_xml(Cursor::new(blob.as_bytes())) {
        return Some(value.into());
    }
    scalar_from_fragment(blob)
}

fn scalar_from_fragment(blob: &str) -> Option<PrefValue> {
    let blob = blob.trim();
    let between = |tag: &str| -> Option<&str> {
        let start = blob.find(&format!("<{tag}>"))? + tag.len() + 2;
        let end = blob.find(&format!("</{tag}>"))?;
        (end >= start).then(|| blob[start..end].trim())
    };
    if blob.contains("<true/>") {
        Some(PrefValue::Bool(true))
    } else if blob.contains("<false/>") {
        Some(PrefValue::Bool(false))
    } else if let Some(n) = between("integer") {
        Some(PrefValue::Int(n.parse().ok()?))
    } else if let Some(r) = between("real") {
        Some(PrefValue::Real(r.parse().ok()?))
    } else {
        between("string").map(|s| PrefValue::Str(s.to_string()))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn plist(inner: &str) -> String {
        format!(
            "'<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
             <plist version=\"1.0\">\n{inner}\n</plist>'"
        )
    }

    #[test]
    fn parses_domain_key_and_value() {
        let script = format!(
            "defaults write com.apple.dock tilesize {}",
            plist("<integer>48</integer>")
        );
        let prefs = parse_activation(&script).unwrap();
        assert_eq!(prefs.len(), 1);
        assert_eq!(prefs[0].domain().as_str(), "com.apple.dock");
        assert_eq!(prefs[0].key(), "tilesize");
        assert_eq!(prefs[0].value(), &PrefValue::Int(48));
    }

    #[test]
    fn normalizes_global_domain_flag() {
        let script = format!(
            "defaults write -g KeyRepeat {}",
            plist("<integer>2</integer>")
        );
        let prefs = parse_activation(&script).unwrap();
        assert_eq!(prefs[0].domain().as_str(), "NSGlobalDomain");
    }

    #[test]
    fn parses_launchctl_wrapped_multiline_commands() {
        let script = format!(
            "launchctl asuser \"$(id -u)\" sudo -- defaults write com.apple.dock orientation {}\n\
             launchctl asuser \"$(id -u)\" sudo -- defaults write com.apple.finder ShowPathbar {}",
            plist("<string>right</string>"),
            plist("<true/>"),
        );
        let prefs = parse_activation(&script).unwrap();
        assert_eq!(prefs.len(), 2);
        assert_eq!(prefs[0].value(), &PrefValue::Str("right".into()));
        assert_eq!(prefs[1].value(), &PrefValue::Bool(true));
    }

    #[test]
    fn boolean_and_string_scalars_round_trip() {
        let script = format!(
            "defaults write -g AppleInterfaceStyle {}\n\
             defaults write -g ApplePressAndHoldEnabled {}",
            plist("<string>Dark</string>"),
            plist("<false/>"),
        );
        let prefs = parse_activation(&script).unwrap();
        assert_eq!(prefs[0].value(), &PrefValue::Str("Dark".into()));
        assert_eq!(prefs[1].value(), &PrefValue::Bool(false));
    }

    #[test]
    fn empty_script_is_an_error() {
        assert!(matches!(
            parse_activation("echo nothing to see"),
            Err(ParseError::NoDefaults)
        ));
    }
}
