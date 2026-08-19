import os

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "resized.png")

MIPMAPS = {
    "mdpi": 48,
    "hdpi": 72,
    "xhdpi": 96,
    "xxhdpi": 144,
    "xxxhdpi": 192,
}


def main() -> None:
    img = Image.open(SRC).convert("RGBA")
    print(f"source: {img.size[0]}x{img.size[1]} @ {SRC}")

    for name, size in MIPMAPS.items():
        out = os.path.join(
            ROOT, "android", "app", "src", "main", "res", f"mipmap-{name}", "ic_launcher.png"
        )
        img.resize((size, size), Image.LANCZOS).save(out)
        print(f"{name}: {size}x{size} -> {out}")

    store = os.path.join(ROOT, "store_icon_512.png")
    img.resize((512, 512), Image.LANCZOS).save(store)
    print(f"store: 512x512 -> {store}")


if __name__ == "__main__":
    main()