#!/bin/bash
# Usage:
# cd ~/Pictures/iphone_pics
# ./convert_heic_to_jpeg.sh

# Create a single jpeg directory at the top level
mkdir -p jpeg

# Find all HEIC files in all subdirectories and convert them to JPG, placing them in the single jpeg directory
find . -type f -name "*.HEIC" | while read -r file; do
    echo "Converting $file"
    # Get the filename without the path
    filename=$(basename "$file")
    # Convert and place in the jpeg directory, changing the extension to jpg
    mogrify -path jpeg -format jpg "$file"
done

echo "Conversion completed. All JPEGs are in the 'jpeg' directory."
