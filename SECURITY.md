# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.x     | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please report it responsibly.

### How to Report

1. **Do NOT** open a public issue
2. Email security concerns to: security@oblibeny.dev
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Any suggested fixes

### What to Expect

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 7 days
- **Resolution Timeline**: Depends on severity
  - Critical: 24-72 hours
  - High: 7 days
  - Medium: 30 days
  - Low: 90 days

### Safe Harbor

We consider security research conducted in good faith to be authorized. We will not pursue legal action against researchers who:

- Make good faith efforts to avoid privacy violations
- Avoid destruction of data
- Do not exploit vulnerabilities beyond proof-of-concept
- Report findings promptly
- Allow reasonable time for remediation

## Security Design Principles

ObliFS is designed with security as a foundational concern:

1. **Capability-Based Access**: No entity can be accessed without valid capability tokens
2. **Consent-Based Channels**: Both parties must agree before communication
3. **Type-Enforced Boundaries**: Turing-incomplete types prevent escape from designated roles
4. **Audit by Construction**: All operations are logged by design
5. **Reversibility**: State changes can be undone

## Dependencies

We minimize dependencies and prefer:

- Memory-safe languages (Rust, ReScript)
- Formally verified components where available
- Reproducible builds via Nix

## Supply Chain Security

- All dependencies are pinned in `flake.lock`
- SPDX headers on all source files
- Signed commits required for maintainers
