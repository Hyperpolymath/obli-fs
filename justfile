# SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
# SPDX-FileCopyrightText: 2024 Jonathan

# ObliFS Build Automation
# Run `just` to see all available commands

# Default recipe - show help
default:
    @just --list

# === Development ===

# Enter development shell (if not already in one)
shell:
    nix develop

# Install dependencies
deps:
    @echo "Installing ReScript dependencies..."
    cd src && npm install
    @echo "Checking Deno cache..."
    deno cache src/runtime/mod.ts || true

# === Building ===

# Build everything
build: build-rescript build-wasm
    @echo "Build complete."

# Build ReScript sources
build-rescript:
    @echo "Building ReScript..."
    cd src && npm run build

# Build WASM modules
build-wasm:
    @echo "Building WASM modules..."
    cd src/wasm && wasm-pack build --target web

# Build documentation
build-docs:
    @echo "Building documentation..."
    mkdir -p dist/docs
    asciidoctor -D dist/docs README.adoc
    asciidoctor -D dist/docs spec/*.adoc
    asciidoctor -D dist/docs outreach/*.adoc

# === Testing ===

# Run all tests
test: test-unit test-integration
    @echo "All tests complete."

# Run unit tests
test-unit:
    @echo "Running unit tests..."
    deno test --allow-read src/

# Run integration tests
test-integration:
    @echo "Running integration tests..."
    deno test --allow-all tests/integration/

# === Code Quality ===

# Run all checks
check: lint fmt-check test
    @echo "All checks passed."

# Run linter
lint:
    @echo "Running linter..."
    deno lint src/
    cd src && npm run lint || true

# Check formatting (no changes)
fmt-check:
    @echo "Checking formatting..."
    deno fmt --check src/
    prettier --check "**/*.{json,yaml,yml,adoc}"

# Format code
fmt:
    @echo "Formatting code..."
    deno fmt src/
    prettier --write "**/*.{json,yaml,yml}"

# === SPDX Compliance ===

# Check SPDX headers
spdx-check:
    @echo "Checking SPDX compliance..."
    reuse lint

# Add SPDX headers to files (interactive)
spdx-add:
    @echo "Use: reuse annotate --license 'MIT AND LicenseRef-Palimpsest-0.8' --copyright 'Jonathan' <file>"

# === Container ===

# Build container image with Podman
container-build:
    @echo "Building container with Podman..."
    podman build -t obli-fs:latest .

# Run container
container-run:
    @echo "Running container..."
    podman run --rm -it obli-fs:latest

# === Documentation ===

# Serve documentation locally
docs-serve: build-docs
    @echo "Serving documentation at http://localhost:8000"
    cd dist/docs && python3 -m http.server 8000

# === Cleanup ===

# Clean build artifacts
clean:
    @echo "Cleaning build artifacts..."
    rm -rf dist/
    rm -rf src/node_modules/.cache
    rm -rf src/wasm/target
    rm -rf src/wasm/pkg

# Deep clean (including dependencies)
clean-all: clean
    @echo "Removing all dependencies..."
    rm -rf src/node_modules
    rm -rf .npm-global

# === Release ===

# Prepare release (run all checks, build, create changelog entry)
release-prep VERSION:
    @echo "Preparing release {{VERSION}}..."
    just check
    just build
    @echo "Remember to update CHANGELOG.adoc with version {{VERSION}}"
