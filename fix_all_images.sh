#!/bin/bash

echo "=================================================="
echo "🖼️  Hugo Image Fixer - Complete Solution"
echo "=================================================="
echo ""

cd "$(dirname "$0")/content" || exit 1

# Find all markdown files with corresponding -images folders
find . -type d -name "*-images" | while read images_dir; do
    # Get the base name without -images
    base_name=$(basename "$images_dir" | sed 's/-images$//')
    parent_dir=$(dirname "$images_dir")

    echo "📁 Found images folder: $images_dir"

    # Look for corresponding .md file
    md_file="$parent_dir/$base_name.md"
    index_file="$parent_dir/index.md"

    if [ -f "$md_file" ]; then
        echo "   📄 Processing: $md_file"

        # Rename .md to index.md
        mv "$md_file" "$index_file"
        echo "   ✓ Renamed to index.md"

        # Move images to parent directory
        mv "$images_dir"/* "$parent_dir/" 2>/dev/null
        echo "   ✓ Moved images to page bundle"

        # Remove empty images directory
        rmdir "$images_dir" 2>/dev/null
        echo "   ✓ Removed empty images folder"

        # Fix image paths in markdown
        sed -i '' "s|$base_name-images/||g" "$index_file"
        echo "   ✓ Fixed image paths"

        # Split images on separate lines and remove **  **
        python3 << EOF
import re
with open("$index_file", 'r') as f:
    content = f.read()
# Remove ** ** patterns
content = re.sub(r'\*\*\s+\*\*', '', content)
# Split images
content = re.sub(r'(\!\[[^\]]*\]\([^\)]+\))(\!\[)', r'\1\n\n\2', content)
with open("$index_file", 'w') as f:
    f.write(content)
EOF
        echo "   ✅ Done!"
        echo ""
    fi
done

echo "=================================================="
echo "✅ All images fixed!"
echo "=================================================="
echo ""
echo "💡 Now your images will display correctly in Hugo"
echo "   Visit: http://localhost:1313/"
