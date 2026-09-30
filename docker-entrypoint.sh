#!/bin/sh
set -e

# Dynamically populate client runtime variables into /app/dist/env-config.js
if [ -d "/app/dist" ]; then
  cat <<EOF > /app/dist/env-config.js
// Runtime environment configuration injected by docker-entrypoint.sh
window.__GOOGLE_MAPS_API_KEY__ = "${GOOGLE_MAPS_API_KEY:-}";
window.__CESIUM_ION_TOKEN__ = "${CESIUM_ION_TOKEN:-}";
EOF
fi

# Ensure cache directory exists
mkdir -p /app/.gev-cache 2>/dev/null || true

# Run the requested command or default to preview server
if [ "$#" -eq 0 ]; then
  exec npx vite preview --host "${HOST:-0.0.0.0}" --port "${PORT:-4173}"
else
  exec "$@"
fi
