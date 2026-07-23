//! A macOS user-defaults domain.

use std::fmt;

use thiserror::Error;

/// The canonical name for the global domain. The activation script and the
/// `defaults` CLI accept several aliases (`-g`, `-globalDomain`) for it; we
/// collapse them here so downstream code compares a single spelling.
const GLOBAL_DOMAIN: &str = "NSGlobalDomain";

/// A preferences domain such as `com.apple.dock`, guaranteed non-empty and with
/// the global-domain aliases normalized to a single canonical spelling.
///
/// Constructing a `Domain` is the only way to obtain one, so any `Domain` in the
/// program is already valid: no downstream code re-checks or re-normalizes.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct Domain(String);

/// Why a domain string could not be turned into a [`Domain`].
#[derive(Debug, Clone, PartialEq, Eq, Error)]
pub enum DomainError {
    #[error("domain is empty")]
    Empty,
}

impl Domain {
    /// Parses a domain token, normalizing global-domain aliases.
    ///
    /// ```
    /// # use drift::domain::Domain;
    /// assert_eq!(Domain::new("-g")?.as_str(), "NSGlobalDomain");
    /// assert_eq!(Domain::new("com.apple.dock")?.as_str(), "com.apple.dock");
    /// # Ok::<(), drift::domain::DomainError>(())
    /// ```
    ///
    /// # Errors
    ///
    /// Returns [`DomainError::Empty`] if `raw` is empty.
    pub fn new(raw: &str) -> Result<Self, DomainError> {
        if raw.is_empty() {
            return Err(DomainError::Empty);
        }
        let canonical = match raw {
            "-g" | "-globalDomain" | "NSGlobalDomain" => GLOBAL_DOMAIN,
            other => other,
        };
        Ok(Self(canonical.to_string()))
    }

    /// Borrows the normalized domain name, e.g. for passing to `defaults`.
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl fmt::Display for Domain {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.0)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn global_domain_aliases_normalize_to_one_spelling() {
        for alias in ["-g", "-globalDomain", "NSGlobalDomain"] {
            assert_eq!(Domain::new(alias).unwrap().as_str(), "NSGlobalDomain");
        }
    }

    #[test]
    fn normalized_aliases_compare_equal() {
        assert_eq!(
            Domain::new("-g").unwrap(),
            Domain::new("NSGlobalDomain").unwrap()
        );
    }

    #[test]
    fn ordinary_domain_is_preserved() {
        assert_eq!(
            Domain::new("com.apple.dock").unwrap().as_str(),
            "com.apple.dock"
        );
    }

    #[test]
    fn empty_is_rejected() {
        assert_eq!(Domain::new(""), Err(DomainError::Empty));
    }
}
