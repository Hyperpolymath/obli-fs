// SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
// SPDX-FileCopyrightText: 2024 Jonathan

//! ObliFS WASM Module
//!
//! Performance-critical operations for ObliFS, compiled to WebAssembly.

use sha2::{Sha256, Digest};
use wasm_bindgen::prelude::*;

/// Initialize panic hook for better error messages
#[wasm_bindgen(start)]
pub fn init() {
    #[cfg(feature = "console_error_panic_hook")]
    console_error_panic_hook::set_once();
}

/// Compute SHA-256 hash of content for content-addressable references
#[wasm_bindgen]
pub fn content_hash(data: &[u8]) -> String {
    let mut hasher = Sha256::new();
    hasher.update(data);
    let result = hasher.finalize();
    format!("sha256:{}", hex::encode(result))
}

/// Verify that a hash matches content
#[wasm_bindgen]
pub fn verify_hash(data: &[u8], expected_hash: &str) -> bool {
    let computed = content_hash(data);
    computed == expected_hash
}

/// Entity type discriminator
#[wasm_bindgen]
#[derive(Clone, Copy, Debug, PartialEq)]
pub enum EntityType {
    Manifest = 0,
    Actor = 1,
    Channel = 2,
    Router = 3,
    Workflow = 4,
    Archive = 5,
}

/// Validate entity type bounds
#[wasm_bindgen]
pub fn validate_entity_type(type_code: u8) -> bool {
    type_code <= 5
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_content_hash() {
        let data = b"hello world";
        let hash = content_hash(data);
        assert!(hash.starts_with("sha256:"));
        assert_eq!(hash.len(), 7 + 64); // "sha256:" + 64 hex chars
    }

    #[test]
    fn test_verify_hash() {
        let data = b"hello world";
        let hash = content_hash(data);
        assert!(verify_hash(data, &hash));
        assert!(!verify_hash(b"different", &hash));
    }

    #[test]
    fn test_entity_type_validation() {
        assert!(validate_entity_type(0));
        assert!(validate_entity_type(5));
        assert!(!validate_entity_type(6));
    }
}
