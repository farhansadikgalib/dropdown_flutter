#!/usr/bin/env python3
"""Turns the raw device captures in screenshots/raw into the published set.

Each raw frame is a full 1080x2424 device screenshot. This script trims the
empty background below the last piece of content so no screenshot ships with
half a screen of dead space, then writes the final PNG/JPG assets plus a
side-by-side preview composite.

Usage: python3 tool/build_screenshots.py
"""
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "screenshots" / "raw"
OUT = ROOT / "screenshots"

# Top of the app bar: everything above is empty inset on this device.
TOP_INSET = 96
# Keep a little breathing room under the last content row.
BOTTOM_PAD = 48


def background_of(img):
    """Sample the page background from a pixel just under the app bar."""
    return img.getpixel((8, img.height - 8))


def content_bottom(img, bg, tolerance=10):
    """Last row that differs from the page background."""
    px = img.load()
    step = max(1, img.width // 120)
    for y in range(img.height - 1, TOP_INSET, -1):
        for x in range(0, img.width, step):
            p = px[x, y]
            if any(abs(p[i] - bg[i]) > tolerance for i in range(3)):
                return y
    return img.height - 1


def trim(path):
    img = Image.open(path).convert("RGB")
    bg = background_of(img)
    bottom = min(img.height, content_bottom(img, bg) + BOTTOM_PAD)
    return img.crop((0, TOP_INSET, img.width, bottom))


def snap_to_gutter(img, target, search=180):
    """Move `target` to the middle of the nearest all-background band.

    The banner crops each frame to a fixed height; landing mid-card looks like
    a torn edge, so nudge the cut into the gutter between two cards.
    """
    bg = img.getpixel((8, 8))
    lo = max(1, target - search)
    hi = min(img.height - 1, target + search)
    band = img.crop((0, lo, img.width, hi + 1))
    # Max per-row deviation from the page background, computed band-wide.
    rows = []
    for y in range(band.height):
        row = band.crop((0, y, band.width, y + 1))
        extrema = row.getextrema()  # per channel (min, max)
        rows.append(
            max(max(abs(mn - c), abs(mx - c)) for (mn, mx), c in zip(extrema, bg))
        )

    best = None
    y = 0
    while y < len(rows):
        if rows[y] <= 8:
            start = y
            while y < len(rows) and rows[y] <= 8:
                y += 1
            if y - start >= 6:
                mid = lo + (start + y - 1) // 2
                if best is None or abs(mid - target) < abs(best - target):
                    best = mid
        else:
            y += 1
    return best or target


def main():
    frames = sorted(RAW.glob("*.png"))
    if not frames:
        raise SystemExit(f"no raw frames in {RAW}")

    trimmed = {}
    for f in frames:
        img = trim(f)
        trimmed[f.stem] = img
        print(f"{f.stem}: {img.width}x{img.height}")

    # Published assets, named for what they show.
    mapping = {
        "01_overview": "ss_1.jpg",
        "02_single_open": "ss_2.jpg",
        "05_multi_select": "ss_3.jpg",
        "06_grouped": "ss_4.jpg",
        "07_highlight": "ss_5.jpg",
        "08_dark": "ss_6.jpg",
    }
    for stem, name in mapping.items():
        if stem not in trimmed:
            continue
        img = trimmed[stem]
        img.save(OUT / name, "JPEG", quality=90, optimize=True)
        print(f"wrote {name}")

    # Preview banner: the top of three representative frames, side by side.
    # Only the upper portion is used — a full 2.2:1 phone shrunk to banner
    # width is unreadable, and the interesting UI is all above the fold.
    picks = ["02_single_open", "06_grouped", "08_dark"]
    picks = [p for p in picks if p in trimmed]
    gap = 36
    margin = 36
    radius = 28
    # Show roughly the top 3:2 of each phone: enough for the app bar, the tab
    # row and the open dropdown, without the empty lower cards. Snap the cut to
    # a gutter between cards so no frame ends mid-card.
    target = min(int(trimmed[p].width * 1.5) for p in picks)
    crop_h = min(target, min(trimmed[p].height for p in picks))
    # Snap against each frame and keep the shallowest result, so the shared
    # cut lands in a gutter for every panel rather than only the first.
    crop_h = min(snap_to_gutter(trimmed[p], crop_h) for p in picks)

    shots = []
    for p in picks:
        img = trimmed[p].crop((0, 0, trimmed[p].width, crop_h))
        # Round the corners so each frame reads as a device, not a raw crop.
        mask = Image.new("L", img.size, 0)
        ImageDraw.Draw(mask).rounded_rectangle(
            (0, 0, img.width - 1, img.height - 1), radius=radius, fill=255
        )
        img.putalpha(mask)
        shots.append(img)

    width = sum(s.width for s in shots) + gap * (len(shots) - 1)
    canvas = Image.new(
        "RGBA", (width + margin * 2, crop_h + margin * 2), (246, 247, 251, 255)
    )
    x = margin
    for img in shots:
        canvas.alpha_composite(img, (x, margin))
        x += img.width + gap
    canvas.thumbnail((1600, 1600), Image.LANCZOS)
    canvas.convert("RGB").save(OUT / "preview.png", "PNG", optimize=True)
    print(f"wrote preview.png ({canvas.width}x{canvas.height})")


if __name__ == "__main__":
    main()
