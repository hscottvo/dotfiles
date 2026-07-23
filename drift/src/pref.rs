//! Preference values and the declared-preference record.

use std::fmt;

use crate::domain::Domain;

/// A preference value, normalized away from `plist`'s representation so the rest
/// of the crate never depends on that crate's types or equality semantics.
///
/// `Other` holds the debug rendering of anything that isn't a scalar (arrays,
/// dicts, dates); nix-darwin's `system.defaults` only ever writes scalars, so in
/// practice it is a rarely-hit fallback that still lets comparison and display
/// work without panicking.
#[derive(Debug, Clone, PartialEq)]
pub enum PrefValue {
    Bool(bool),
    Int(i64),
    Real(f64),
    Str(String),
    Other(String),
}

impl PrefValue {
    /// Whether two values represent the same setting.
    ///
    /// This is looser than `==`: macOS may persist a boolean as the integer 0 or
    /// 1 while nix-darwin writes a real boolean, so `Bool(true)` and `Int(1)` are
    /// treated as a match. Without this, every boolean pref would be a spurious
    /// drift.
    pub fn matches(&self, other: &PrefValue) -> bool {
        if self == other {
            return true;
        }
        match (self.as_bool(), other.as_bool()) {
            (Some(a), Some(b)) => a == b,
            _ => false,
        }
    }

    fn as_bool(&self) -> Option<bool> {
        match self {
            PrefValue::Bool(b) => Some(*b),
            PrefValue::Int(0) => Some(false),
            PrefValue::Int(1) => Some(true),
            _ => None,
        }
    }
}

impl From<plist::Value> for PrefValue {
    fn from(value: plist::Value) -> Self {
        match value {
            plist::Value::Boolean(b) => PrefValue::Bool(b),
            plist::Value::Integer(i) => match i.as_signed() {
                Some(n) => PrefValue::Int(n),
                None => PrefValue::Other(format!("{i:?}")),
            },
            plist::Value::Real(r) => PrefValue::Real(r),
            plist::Value::String(s) => PrefValue::Str(s),
            other => PrefValue::Other(format!("{other:?}")),
        }
    }
}

impl fmt::Display for PrefValue {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            PrefValue::Bool(b) => write!(f, "{b}"),
            PrefValue::Int(i) => write!(f, "{i}"),
            PrefValue::Real(r) => write!(f, "{r}"),
            PrefValue::Str(s) => f.write_str(s),
            PrefValue::Other(s) => f.write_str(s),
        }
    }
}

/// A single preference the nix config declares: which domain and key it targets,
/// and the value it should hold.
#[derive(Debug, Clone, PartialEq)]
pub struct DeclaredPref {
    domain: Domain,
    key: String,
    value: PrefValue,
}

impl DeclaredPref {
    pub fn new(domain: Domain, key: String, value: PrefValue) -> Self {
        Self { domain, key, value }
    }

    pub fn domain(&self) -> &Domain {
        &self.domain
    }

    pub fn key(&self) -> &str {
        &self.key
    }

    pub fn value(&self) -> &PrefValue {
        &self.value
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn bool_and_equivalent_int_match() {
        assert!(PrefValue::Bool(false).matches(&PrefValue::Int(0)));
        assert!(PrefValue::Bool(true).matches(&PrefValue::Int(1)));
        assert!(PrefValue::Int(1).matches(&PrefValue::Bool(true)));
    }

    #[test]
    fn bool_does_not_match_unrelated_int() {
        assert!(!PrefValue::Bool(true).matches(&PrefValue::Int(2)));
        assert!(!PrefValue::Bool(false).matches(&PrefValue::Int(1)));
    }

    #[test]
    fn scalars_match_only_when_equal() {
        assert!(PrefValue::Int(48).matches(&PrefValue::Int(48)));
        assert!(!PrefValue::Int(48).matches(&PrefValue::Int(64)));
        assert!(PrefValue::Str("Dark".into()).matches(&PrefValue::Str("Dark".into())));
        assert!(!PrefValue::Str("Dark".into()).matches(&PrefValue::Str("Light".into())));
    }

    #[test]
    fn converts_from_plist_scalars() {
        assert_eq!(
            PrefValue::from(plist::Value::Boolean(true)),
            PrefValue::Bool(true)
        );
        assert_eq!(
            PrefValue::from(plist::Value::Integer(48.into())),
            PrefValue::Int(48)
        );
        assert_eq!(
            PrefValue::from(plist::Value::String("Nlsv".into())),
            PrefValue::Str("Nlsv".into())
        );
    }

    #[test]
    fn displays_as_bare_scalar() {
        assert_eq!(PrefValue::Bool(false).to_string(), "false");
        assert_eq!(PrefValue::Int(48).to_string(), "48");
        assert_eq!(PrefValue::Str("right".into()).to_string(), "right");
    }
}
