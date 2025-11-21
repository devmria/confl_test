#!/bin/bash

# Hugo Watcher & Builder Script
# Automatically watches for changes and rebuilds the Hugo site

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "================================"
echo "Hugo Watcher & Builder"
echo "================================"
echo ""
echo "Starting Hugo development server..."
echo "Server will be available at: http://localhost:1313/"
echo ""
echo "Features enabled:"
echo "  ✓ Auto-rebuild on file changes"
echo "  ✓ Live reload in browser"
echo "  ✓ Draft content visible"
echo "  ✓ Debug logging"
echo ""
echo "Press Ctrl+C to stop"
echo "================================"
echo ""

# Run Hugo server with watch mode enabled
hugo server \
  --buildDrafts \
  --buildFuture \
  --disableFastRender \
  --noHTTPCache \
  --poll 700ms \
  --navigateToChanged
