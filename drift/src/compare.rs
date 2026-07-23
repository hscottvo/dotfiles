//! Comparing declared preferences against the live system.
//!
//! The live system is reached through the [`LiveDefaults`] port so the
//! comparison is pure and testable: production wires in an adapter that shells
//! out to `defaults`, tests wire in an in-memory map.

use thiserror::Error;

use crate::domain::Domain;
use crate::pref::{DeclaredPref, PrefValue};

/// A read-only view of the system's current preference values.
///
/// Implementors resolve `(domain, key)` to the value macOS currently holds, or
/// `None` when the key is unset.
pub trait LiveDefaults {
    fn lookup(&self, domain: &Domain, key: &str) -> Result<Option<PrefValue>, LookupError>;
}

/// A failure reading a value from the live system.
#[derive(Debug, Error)]
pub enum LookupError {
    #[error("reading defaults for domain {domain}")]
    Backend {
        domain: String,
        #[source]
        source: Box<dyn std::error::Error + Send + Sync>,
    },
}

/// How a declared preference relates to its live value.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Status {
    /// Live value matches what the config declares.
    InSync,
    /// Key is set live, but to a different value.
    Changed,
    /// Config declares the key, but it is unset live.
    Missing,
}

/// One declared preference paired with what the live system reported.
#[derive(Debug, Clone, PartialEq)]
pub struct Entry {
    pub pref: DeclaredPref,
    pub live: Option<PrefValue>,
    pub status: Status,
}

/// The outcome of comparing every declared preference against the live system.
#[derive(Debug, Clone, PartialEq)]
pub struct DriftReport {
    entries: Vec<Entry>,
}

impl DriftReport {
    pub fn entries(&self) -> &[Entry] {
        &self.entries
    }

    /// Count of preferences that diverge (changed or missing).
    pub fn drifted(&self) -> usize {
        self.entries
            .iter()
            .filter(|e| e.status != Status::InSync)
            .count()
    }
}

/// Compares each declared preference against the live system.
pub fn compare(
    declared: Vec<DeclaredPref>,
    live: &dyn LiveDefaults,
) -> Result<DriftReport, LookupError> {
    let mut entries = Vec::with_capacity(declared.len());
    for pref in declared {
        let live_value = live.lookup(pref.domain(), pref.key())?;
        let status = match &live_value {
            Some(v) if pref.value().matches(v) => Status::InSync,
            Some(_) => Status::Changed,
            None => Status::Missing,
        };
        entries.push(Entry {
            pref,
            live: live_value,
            status,
        });
    }
    Ok(DriftReport { entries })
}

#[cfg(test)]
mod tests {
    use std::collections::HashMap;

    use super::*;

    #[derive(Default)]
    struct FakeLive {
        values: HashMap<(String, String), PrefValue>,
    }

    impl FakeLive {
        fn with(mut self, domain: &str, key: &str, value: PrefValue) -> Self {
            self.values
                .insert((domain.to_string(), key.to_string()), value);
            self
        }
    }

    impl LiveDefaults for FakeLive {
        fn lookup(&self, domain: &Domain, key: &str) -> Result<Option<PrefValue>, LookupError> {
            Ok(self
                .values
                .get(&(domain.as_str().to_string(), key.to_string()))
                .cloned())
        }
    }

    fn pref(key: &str, value: PrefValue) -> DeclaredPref {
        DeclaredPref::new(Domain::new("com.apple.dock").unwrap(), key.into(), value)
    }

    #[test]
    fn matching_value_is_in_sync() {
        let live = FakeLive::default().with("com.apple.dock", "tilesize", PrefValue::Int(48));
        let report = compare(vec![pref("tilesize", PrefValue::Int(48))], &live).unwrap();
        assert_eq!(report.entries()[0].status, Status::InSync);
        assert_eq!(report.drifted(), 0);
    }

    #[test]
    fn different_live_value_is_changed() {
        let live = FakeLive::default().with("com.apple.dock", "tilesize", PrefValue::Int(64));
        let report = compare(vec![pref("tilesize", PrefValue::Int(48))], &live).unwrap();
        assert_eq!(report.entries()[0].status, Status::Changed);
        assert_eq!(report.entries()[0].live, Some(PrefValue::Int(64)));
        assert_eq!(report.drifted(), 1);
    }

    #[test]
    fn unset_live_value_is_missing() {
        let live = FakeLive::default();
        let report = compare(vec![pref("tilesize", PrefValue::Int(48))], &live).unwrap();
        assert_eq!(report.entries()[0].status, Status::Missing);
        assert_eq!(report.drifted(), 1);
    }

    #[test]
    fn bool_stored_as_int_is_in_sync() {
        let live = FakeLive::default().with("com.apple.dock", "show-recents", PrefValue::Int(0));
        let report = compare(vec![pref("show-recents", PrefValue::Bool(false))], &live).unwrap();
        assert_eq!(report.entries()[0].status, Status::InSync);
    }
}
