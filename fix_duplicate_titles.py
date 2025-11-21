#!/usr/bin/env python3
"""
Fix duplicate titles in Hugo markdown files.
Removes H1 headings from content if they match the frontmatter title.
"""

import os
import re
from pathlib import Path

def extract_frontmatter_title(content):
    """Extract title from YAML frontmatter."""
    frontmatter_match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if frontmatter_match:
        frontmatter = frontmatter_match.group(1)
        title_match = re.search(r'^title:\s*(.+)$', frontmatter, re.MULTILINE)
        if title_match:
            return title_match.group(1).strip().strip("'\"")
    return None

def remove_duplicate_h1(file_path):
    """Remove H1 heading from markdown if it duplicates the frontmatter title."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract title from frontmatter
    title = extract_frontmatter_title(content)
    if not title:
        return False

    # Split content into frontmatter and body
    parts = content.split('---\n', 2)
    if len(parts) < 3:
        return False

    frontmatter = f"---\n{parts[1]}---\n"
    body = parts[2]

    # Find and remove H1 heading that matches title (with optional leading/trailing whitespace)
    # Look for # Title at the start of the body content
    h1_pattern = rf'^\s*#\s+{re.escape(title)}\s*\n+'
    new_body = re.sub(h1_pattern, '', body, count=1)

    # Check if anything changed
    if new_body != body:
        new_content = frontmatter + new_body
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True

    return False

def process_directory(content_dir):
    """Process all markdown files in the content directory."""
    fixed_count = 0

    for root, dirs, files in os.walk(content_dir):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                try:
                    if remove_duplicate_h1(file_path):
                        print(f"✓ Fixed: {file_path}")
                        fixed_count += 1
                    else:
                        print(f"  Skipped: {file_path}")
                except Exception as e:
                    print(f"✗ Error processing {file_path}: {e}")

    return fixed_count

if __name__ == '__main__':
    content_dir = '/Users/maki/Documents/Prompt_test_py/hugo-site/content'

    print("Fixing duplicate titles in Hugo markdown files...")
    print(f"Content directory: {content_dir}\n")

    fixed_count = process_directory(content_dir)

    print(f"\n{'='*60}")
    print(f"Done! Fixed {fixed_count} file(s)")
