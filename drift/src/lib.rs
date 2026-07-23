//! Pure domain logic for detecting `system.defaults` drift: parse a nix-darwin
//! activation script into declared preferences, then compare them against a
//! [`compare::LiveDefaults`] view of the running system.
//!
//! Everything here is free of I/O and is unit-tested. The binary supplies the
//! adapter that reads the real system and handles the other drift layers
//! (store closures, homebrew, flake freshness).

pub mod compare;
pub mod domain;
pub mod parse;
pub mod pref;
