#!/usr/bin/env python3
"""Renders screenshots/logo.png (and a wordmark banner) from vector geometry.

Kept in sync by hand with screenshots/logo.svg — the SVG is the source of truth
for anyone editing the mark; this script exists so the raster assets can be
regenerated without an SVG toolchain installed.

Usage: python3 tool/build_logo.py
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "screenshots"

S = 4  # supersampling factor
SIZE = 1024

INK = (81, 71, 133)
INK_DEEP = (60, 52, 102)
INK_LIGHT = (107, 95, 168)
WHITE = (255, 255, 255)
ROW_TINT = (237, 234, 247)
MUTED = (201, 196, 223)
MUTED_DIM = (185, 179, 214)


def lerp(a, b, t):
    return tuple(round(x + (y - x) * t) for x, y in zip(a, b))


def diagonal_gradient(size, stops):
    """Square image with a 45-degree multi-stop gradient."""
    n = size
    grad = Image.new("RGB", (n, n))
    px = grad.load()
    for y in range(n):
        for x in range(n):
            t = (x / (n - 1) + y / (n - 1)) / 2
            for i in range(len(stops) - 1):
                p0, c0 = stops[i]
                p1, c1 = stops[i + 1]
                if p0 <= t <= p1:
                    px[x, y] = lerp(c0, c1, (t - p0) / (p1 - p0))
                    break
            else:
                px[x, y] = stops[-1][1]
    return grad


def rounded_mask(size, radius, scale=1):
    m = Image.new("L", (size[0] * scale, size[1] * scale), 0)
    ImageDraw.Draw(m).rounded_rectangle(
        (0, 0, size[0] * scale - 1, size[1] * scale - 1),
        radius=radius * scale,
        fill=255,
    )
    return m.resize(size, Image.LANCZOS)


def shadow_layer(size, boxes, blur, offset, opacity):
    layer = Image.new("L", size, 0)
    d = ImageDraw.Draw(layer)
    for box, radius in boxes:
        x0, y0, x1, y1 = box
        d.rounded_rectangle(
            (x0, y0 + offset, x1, y1 + offset), radius=radius, fill=opacity
        )
    return layer.filter(ImageFilter.GaussianBlur(blur))


def build_icon():
    """One closed field with a chevron, one open list below it.

    Deliberately simple: a single accent row and two plain rows read clearly
    at 32px, where the previous two-panel/checkmark version turned to mush.
    """
    n = SIZE * S
    base = diagonal_gradient(
        256, [(0.0, INK_LIGHT), (0.55, INK), (1.0, INK_DEEP)]
    ).resize((n, n), Image.BICUBIC)

    # Top sheen.
    sheen = Image.new("L", (1, 256))
    for y in range(256):
        sheen.putpixel((0, y), int(41 * (1 - y / 255) ** 2))
    base = Image.composite(
        Image.new("RGB", (n, n), WHITE), base, sheen.resize((n, n), Image.BICUBIC)
    )

    card = Image.new("RGBA", (n, n), (0, 0, 0, 0))
    d = ImageDraw.Draw(card)

    def sc(v):
        return round(v * S)

    # Closed field on top, open list panel below, with a clear gap between.
    field = (sc(196), sc(236), sc(828), sc(404))
    listbox = (sc(196), sc(448), sc(828), sc(812))

    sh = shadow_layer(
        (n, n),
        [(field, sc(46)), (listbox, sc(52))],
        blur=sc(20),
        offset=sc(12),
        opacity=82,
    )
    base = Image.composite(Image.new("RGB", (n, n), (28, 24, 54)), base, sh)

    d.rounded_rectangle(field, radius=sc(46), fill=WHITE)
    d.rounded_rectangle(listbox, radius=sc(52), fill=WHITE)

    # Value bar in the closed field.
    d.rounded_rectangle(
        (sc(252), sc(304), sc(596), sc(340)), radius=sc(18), fill=MUTED_DIM
    )

    # Bold chevron: the single strongest cue that this is a dropdown.
    cx, cy, half, drop = sc(742), sc(300), sc(58), sc(52)
    d.line(
        [(cx - half, cy), (cx, cy + drop), (cx + half, cy)],
        fill=INK,
        width=sc(44),
        joint="curve",
    )
    for pt in [(cx - half, cy), (cx + half, cy)]:
        r = sc(22)
        d.ellipse((pt[0] - r, pt[1] - r, pt[0] + r, pt[1] + r), fill=INK)

    # Highlighted first row of the open list, square where it meets row two.
    d.rounded_rectangle(
        (sc(196), sc(448), sc(828), sc(590)), radius=sc(52), fill=ROW_TINT
    )
    d.rectangle((sc(196), sc(538), sc(828), sc(590)), fill=ROW_TINT)

    # Three list rows: the first (selected) in solid ink, the rest muted.
    d.rounded_rectangle(
        (sc(252), sc(502), sc(650), sc(538)), radius=sc(18), fill=INK
    )
    d.rounded_rectangle(
        (sc(252), sc(646), sc(596), sc(682)), radius=sc(18), fill=MUTED
    )
    d.rounded_rectangle(
        (sc(252), sc(730), sc(688), sc(766)), radius=sc(18), fill=MUTED
    )

    icon = Image.alpha_composite(base.convert("RGBA"), card)
    icon.putalpha(rounded_mask((n, n), sc(232)))
    return icon.resize((SIZE, SIZE), Image.LANCZOS)


def on_white(img):
    bg = Image.new("RGB", img.size, WHITE)
    bg.paste(img, (0, 0), img)
    return bg


def main():
    icon = build_icon()
    icon.save(OUT / "logo.png", "PNG", optimize=True)
    print(f"wrote logo.png ({icon.width}x{icon.height})")

    small = icon.resize((256, 256), Image.LANCZOS)
    small.save(OUT / "logo_256.png", "PNG", optimize=True)
    print("wrote logo_256.png (256x256)")

    # Wordmark banner for pub.dev's screenshot strip.
    W, H = 1600, 500
    banner = Image.new("RGB", (W, H), (246, 247, 251))

    title = sub = None
    for path in [
        "/System/Library/Fonts/SFNS.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/Library/Fonts/Arial.ttf",
    ]:
        try:
            title = ImageFont.truetype(path, 104)
            sub = ImageFont.truetype(path, 42)
            break
        except OSError:
            continue
    if title is None:
        title = sub = ImageFont.load_default()

    d = ImageDraw.Draw(banner)
    mark_px, gap = 260, 56
    t_text, s_text = "Dropdown Flutter", "search · multi-select · validation"
    t_box = d.textbbox((0, 0), t_text, font=title)
    s_box = d.textbbox((0, 0), s_text, font=sub)
    text_w = max(t_box[2] - t_box[0], s_box[2] - s_box[0])

    # Center the whole lockup (mark + gap + text) on both axes.
    x = (W - (mark_px + gap + text_w)) // 2
    mark = icon.resize((mark_px, mark_px), Image.LANCZOS)
    banner.paste(mark, (x, (H - mark_px) // 2), mark)

    # Centre the two lines against each other within the text block.
    tx = x + mark_px + gap
    t_w, s_w = t_box[2] - t_box[0], s_box[2] - s_box[0]
    block_h = (t_box[3] - t_box[1]) + 26 + (s_box[3] - s_box[1])
    ty = (H - block_h) // 2
    d.text(
        (tx + (text_w - t_w) // 2 - t_box[0], ty - t_box[1]),
        t_text,
        font=title,
        fill=(34, 30, 62),
    )
    d.text(
        (
            tx + (text_w - s_w) // 2 - s_box[0],
            ty + (t_box[3] - t_box[1]) + 26 - s_box[1],
        ),
        s_text,
        font=sub,
        fill=(110, 104, 140),
    )
    banner.save(OUT / "logo_banner.png", "PNG", optimize=True)
    print(f"wrote logo_banner.png ({W}x{H})")


if __name__ == "__main__":
    main()
