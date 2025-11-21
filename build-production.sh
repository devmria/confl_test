#!/bin/bash

# Hugo Production Build Script
# Builds the static site for production deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "================================"
echo "Hugo Production Build"
echo "================================"
echo ""

# Clean previous build
if [ -d "public" ]; then
  echo "🧹 Cleaning previous build..."
  rm -rf public
fi

echo "🔨 Building site for production..."
echo ""

# Build the site
hugo \
  --minify \
  --cleanDestinationDir \
  --gc

echo ""
echo "================================"
echo "✅ Build complete!"
echo "================================"
echo ""
echo "Output directory: public/"
echo "Total files built: $(find public -type f | wc -l)"
echo ""
echo "To preview production build:"
echo "  cd public && python3 -m http.server 8080"
echo ""
