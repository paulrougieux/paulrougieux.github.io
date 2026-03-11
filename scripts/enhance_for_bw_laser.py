"""
Enhance a photo of a drawing for black & white laser printing.

Removes background color cast, whitens the background, and darkens
the lines for crisp printing.

Usage
-----
    python3 enhance_for_bw_laser.py input.jpeg output.jpeg

Parameters
----------
input : str
    Path to the source image (photo of a drawing).
output : str
    Path to save the enhanced image.

Example
-------

    cd directory 
    python3 enhance_for_bw_laser.py source.jpeg destination.jpeg

"""

import sys
from PIL import Image
import numpy as np


def enhance(input_path: str, output_path: str) -> None:
    """
    Enhance a drawing photo for black & white laser printing.

    Parameters
    ----------
    input_path : str
        Path to the source image.
    output_path : str
        Path to save the enhanced image.
    """
    img = Image.open(input_path).convert("RGB")
    arr = np.array(img, dtype=np.float32)

    # --- White enhancement ---
    # Normalize each channel so the background (98th percentile) maps to white,
    # removing any color cast (e.g. yellowish wood or paper tint).
    p98 = np.percentile(arr, 98, axis=(0, 1))
    arr_norm = arr / p98 * 255.0
    arr_norm = np.clip(arr_norm, 0, 255)

    # Convert to grayscale
    gray = 0.299 * arr_norm[:, :, 0] + 0.587 * arr_norm[:, :, 1] + 0.114 * arr_norm[:, :, 2]

    # --- Black enhancement ---
    # Apply a power curve to the inverted image to darken lines
    # while keeping near-white areas bright.
    inv = 1.0 - gray / 255.0
    inv_strong = np.power(inv, 2.0)
    gray2 = (1.0 - inv_strong) * 255.0

    # Hard threshold: push anything above 195 to pure white,
    # and darken the remaining (line) pixels toward black.
    result = np.where(gray2 < 195, gray2 * 0.4, 255.0)
    result = np.clip(result, 0, 255).astype(np.uint8)

    out_arr = np.stack([result, result, result], axis=2)
    Image.fromarray(out_arr).save(output_path, quality=95)
    print(f"Saved: {output_path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 enhance_for_bw_laser.py input.jpeg output.jpeg")
        sys.exit(1)
    enhance(sys.argv[1], sys.argv[2])
