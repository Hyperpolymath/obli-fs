# SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
# SPDX-FileCopyrightText: 2024 Jonathan

{
  description = "ObliFS - Typed Actor Coordination Over Storage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "obli-fs-dev";

          buildInputs = with pkgs; [
            # Core tools
            git
            just

            # ReScript toolchain
            nodejs_20
            nodePackages.npm

            # Deno runtime
            deno

            # WASM tooling
            wasm-pack
            binaryen
            wabt

            # Rust (for WASM modules)
            rustc
            cargo
            rustfmt
            clippy

            # Container runtime (Podman, not Docker)
            podman

            # Documentation
            asciidoctor

            # Linting and formatting
            nodePackages.prettier

            # Security
            reuse  # SPDX compliance checker
          ];

          shellHook = ''
            echo "ObliFS Development Environment"
            echo "================================"
            echo ""
            echo "Available commands:"
            echo "  just        - Show all available tasks"
            echo "  just check  - Run all checks"
            echo "  just build  - Build the project"
            echo "  just test   - Run tests"
            echo ""
            echo "Tools available:"
            echo "  - Deno $(deno --version | head -1)"
            echo "  - Node $(node --version)"
            echo "  - Rust $(rustc --version)"
            echo "  - Podman $(podman --version)"
            echo ""

            # Set up npm/node for ReScript
            export NPM_CONFIG_PREFIX="$PWD/.npm-global"
            export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
            mkdir -p "$NPM_CONFIG_PREFIX"
          '';
        };

        packages = {
          # Documentation build
          docs = pkgs.stdenv.mkDerivation {
            pname = "obli-fs-docs";
            version = "0.1.0";
            src = ./.;

            buildInputs = [ pkgs.asciidoctor ];

            buildPhase = ''
              mkdir -p $out/html
              asciidoctor -D $out/html README.adoc
              asciidoctor -D $out/html spec/*.adoc
              asciidoctor -D $out/html outreach/*.adoc
            '';

            installPhase = "true";  # Already done in buildPhase
          };
        };

        # Checks for CI
        checks = {
          format = pkgs.runCommand "check-format" {
            buildInputs = [ pkgs.nodePackages.prettier ];
          } ''
            cd ${self}
            prettier --check "**/*.{json,yaml,yml}" || exit 1
            touch $out
          '';

          spdx = pkgs.runCommand "check-spdx" {
            buildInputs = [ pkgs.reuse ];
          } ''
            cd ${self}
            reuse lint || echo "SPDX check (informational)"
            touch $out
          '';
        };
      }
    );
}
