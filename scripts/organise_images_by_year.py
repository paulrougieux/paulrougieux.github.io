"""Organise images by year based on the metadata

Usage in a specific directory:

    penv
    ipython ~/rp/paulrougieux.github.io/scripts/organise_images_by_year.py -- ~/Pictures/iphone_pics jpg

"""
from PIL import Image
from PIL.ExifTags import TAGS
import os
import pathlib
import shutil
import sys

def get_image_year(file_path):
    """Read image metadata to get the year the picture was taken."""
    try:
        with Image.open(file_path) as img:
            exif_data = {
                TAGS[k]: v
                for k, v in img._getexif().items()
                if k in TAGS
            }
            date_str = exif_data.get('DateTimeOriginal', exif_data.get('DateTimeDigitized'))
            if date_str:
                return date_str.split(':')[0]
    except (AttributeError, KeyError, IndexError):
        pass  # No EXIF data or date not found
    return None

def organize_images(source_dir, extension):
    """Move images to the year directory"""
    source_path = pathlib.Path(source_dir)
    if not source_path.is_dir():
        msg = f"The directory '{source_dir}' does not exist."
        raise FileNotFoundError(msg)
    for file_path in source_path.rglob('*'):
        if file_path.suffix.lower() == f'.{extension}':
            year = get_image_year(file_path)
            if year is None:
                year = 'unknown_year'
            year_dir = source_path / year
            year_dir.mkdir(exist_ok=True)
            dest_file_path = year_dir / file_path.name
            if dest_file_path.exists():
                print(f"Skipping {file_path} as {dest_file_path} already exists.")
                continue
            print(f"Moving {file_path.name} to {year_dir}")
            file_path.rename(dest_file_path)


if __name__ == "__main__":
    if len(sys.argv) > 1:
        source_dir = sys.argv[1]
        extention = sys.argv[2]

    organize_images(source_dir, extention)
    print("Images have been organized into year directories.")
