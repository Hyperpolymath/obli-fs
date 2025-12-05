# SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
# SPDX-FileCopyrightText: 2024 Jonathan

# ObliFS Container Image
# Build with: podman build -t obli-fs:latest .

FROM docker.io/denoland/deno:alpine AS runtime

LABEL org.opencontainers.image.title="ObliFS"
LABEL org.opencontainers.image.description="Typed Actor Coordination Over Storage"
LABEL org.opencontainers.image.source="https://github.com/Hyperpolymath/obli-fs"
LABEL org.opencontainers.image.licenses="MIT AND LicenseRef-Palimpsest-0.8"

WORKDIR /app

# Copy runtime files
COPY src/runtime/ ./runtime/
COPY src/core/*.mjs ./core/ 2>/dev/null || true
COPY src/entities/*.mjs ./entities/ 2>/dev/null || true
COPY src/wasm/pkg/ ./wasm/ 2>/dev/null || true

# Cache Deno dependencies
RUN deno cache runtime/mod.ts

# Run as non-root user
USER deno

# Default command
CMD ["deno", "run", "--allow-read", "--allow-write", "runtime/mod.ts"]
