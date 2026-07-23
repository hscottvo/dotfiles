//! The production [`LiveDefaults`] adapter, backed by the `defaults` CLI.

use std::cell::RefCell;
use std::collections::HashMap;
use std::io::Cursor;

use drift::compare::{LiveDefaults, LookupError};
use drift::domain::Domain;
use drift::pref::PrefValue;

/// Reads live preference values via `defaults export`, caching one export per
/// domain since a single check reads many keys from the same few domains.
#[derive(Default)]
pub struct SystemDefaults {
    cache: RefCell<HashMap<String, Option<plist::Dictionary>>>,
}

impl SystemDefaults {
    pub fn new() -> Self {
        Self::default()
    }

    fn export(&self, domain: &Domain) -> Result<Option<plist::Dictionary>, LookupError> {
        let output = std::process::Command::new("defaults")
            .args(["export", domain.as_str(), "-"])
            .output()
            .map_err(|e| LookupError::Backend {
                domain: domain.as_str().to_string(),
                source: Box::new(e),
            })?;
        if !output.status.success() || output.stdout.is_empty() {
            return Ok(None);
        }
        let value = plist::Value::from_reader_xml(Cursor::new(&output.stdout)).map_err(|e| {
            LookupError::Backend {
                domain: domain.as_str().to_string(),
                source: Box::new(e),
            }
        })?;
        Ok(value.into_dictionary())
    }
}

impl LiveDefaults for SystemDefaults {
    fn lookup(&self, domain: &Domain, key: &str) -> Result<Option<PrefValue>, LookupError> {
        if !self.cache.borrow().contains_key(domain.as_str()) {
            let exported = self.export(domain)?;
            self.cache
                .borrow_mut()
                .insert(domain.as_str().to_string(), exported);
        }
        let cache = self.cache.borrow();
        let value = cache
            .get(domain.as_str())
            .and_then(|dict| dict.as_ref())
            .and_then(|dict| dict.get(key))
            .cloned()
            .map(PrefValue::from);
        Ok(value)
    }
}
