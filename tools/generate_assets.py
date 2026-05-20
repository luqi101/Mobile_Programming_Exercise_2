from pathlib import Path
from math import cos, pi, sin

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[1]
CARDS_DIR = ROOT / "assets" / "images" / "cards"
BACKGROUNDS_DIR = ROOT / "assets" / "images" / "backgrounds"


def font(size: int) -> ImageFont.ImageFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
        "/Library/Fonts/Arial Bold.ttf",
        "/System/Library/Fonts/Supplemental/Arial.ttf",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    return ImageFont.load_default()


def lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def vertical_gradient(size: tuple[int, int], top: tuple[int, int, int], bottom: tuple[int, int, int]) -> Image.Image:
    width, height = size
    image = Image.new("RGB", size, top)
    pixels = image.load()
    for y in range(height):
        t = y / max(1, height - 1)
        color = tuple(lerp(top[i], bottom[i], t) for i in range(3))
        for x in range(width):
            pixels[x, y] = color
    return image.convert("RGBA")


def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((0, 0, size[0] - 1, size[1] - 1), radius=radius, fill=255)
    return mask


def save_card(name: str, image: Image.Image) -> None:
    output = Image.new("RGBA", image.size, (0, 0, 0, 0))
    output.paste(image, mask=rounded_mask(image.size, 34))
    output.save(CARDS_DIR / name)


def draw_label(draw: ImageDraw.ImageDraw, text: str, fill: tuple[int, int, int] = (255, 255, 255)) -> None:
    label_font = font(42)
    bbox = draw.textbbox((0, 0), text, font=label_font)
    x = (512 - (bbox[2] - bbox[0])) / 2
    draw.rounded_rectangle((48, 420, 464, 478), radius=18, fill=(12, 24, 32, 155))
    draw.text((x, 429), text, fill=fill, font=label_font)


def star_points(cx: float, cy: float, outer: float, inner: float, count: int = 5) -> list[tuple[float, float]]:
    points = []
    for i in range(count * 2):
        angle = -pi / 2 + i * pi / count
        radius = outer if i % 2 == 0 else inner
        points.append((cx + cos(angle) * radius, cy + sin(angle) * radius))
    return points


def make_card_back() -> None:
    image = vertical_gradient((512, 512), (17, 32, 39), (15, 124, 128))
    draw = ImageDraw.Draw(image, "RGBA")
    for offset, color in [(0, (243, 182, 74, 180)), (34, (225, 111, 77, 145)), (68, (110, 198, 188, 155))]:
        draw.arc((70 + offset, 74 + offset, 442 - offset, 446 - offset), 205, 515, fill=color, width=12)
    for x in range(-60, 560, 72):
        draw.line((x, 520, x + 230, -20), fill=(255, 255, 255, 28), width=8)
    draw.rounded_rectangle((108, 108, 404, 404), radius=44, outline=(255, 255, 255, 150), width=8)
    draw.polygon(star_points(256, 256, 82, 36), fill=(243, 182, 74, 230))
    draw.ellipse((226, 226, 286, 286), fill=(255, 255, 255, 230))
    save_card("card_back.png", image)


def make_aurora() -> None:
    image = vertical_gradient((512, 512), (11, 22, 46), (18, 66, 72))
    draw = ImageDraw.Draw(image, "RGBA")
    for y in range(92, 226, 26):
        draw.line(
            [(30, y + 30), (138, y - 42), (260, y + 22), (386, y - 32), (504, y + 12)],
            fill=(95, 235, 178, 95),
            width=16,
        )
        draw.line(
            [(20, y + 68), (156, y - 8), (286, y + 56), (430, y - 4), (530, y + 48)],
            fill=(206, 105, 224, 70),
            width=11,
        )
    for x, y in [(86, 70), (182, 124), (410, 84), (338, 148), (260, 62)]:
        draw.ellipse((x, y, x + 5, y + 5), fill=(255, 255, 255, 210))
    draw.polygon([(0, 402), (116, 292), (238, 410)], fill=(22, 56, 62, 245))
    draw.polygon([(132, 406), (268, 250), (452, 408)], fill=(26, 70, 75, 245))
    draw.polygon([(0, 408), (512, 408), (512, 512), (0, 512)], fill=(14, 44, 47, 255))
    draw_label(draw, "Aurora")
    save_card("card_aurora.png", image)


def make_canoe() -> None:
    image = vertical_gradient((512, 512), (247, 194, 95), (47, 134, 138))
    draw = ImageDraw.Draw(image, "RGBA")
    for y in range(260, 408, 28):
        draw.arc((-60, y - 20, 570, y + 60), 8, 172, fill=(255, 255, 255, 92), width=5)
    draw.polygon([(72, 294), (440, 294), (384, 350), (130, 350)], fill=(125, 58, 42, 255))
    draw.polygon([(108, 305), (404, 305), (366, 330), (146, 330)], fill=(225, 111, 77, 255))
    draw.line((150, 276, 228, 392), fill=(61, 44, 33, 255), width=8)
    draw.line((344, 276, 270, 392), fill=(61, 44, 33, 255), width=8)
    draw.ellipse((342, 72, 426, 156), fill=(250, 222, 118, 220))
    draw.polygon([(0, 392), (512, 392), (512, 512), (0, 512)], fill=(28, 96, 106, 255))
    draw_label(draw, "Canoe")
    save_card("card_canoe.png", image)


def make_compass() -> None:
    image = vertical_gradient((512, 512), (235, 245, 231), (110, 198, 188))
    draw = ImageDraw.Draw(image, "RGBA")
    draw.ellipse((88, 70, 424, 406), fill=(255, 255, 255, 205), outline=(23, 32, 39, 210), width=10)
    draw.ellipse((132, 114, 380, 362), outline=(15, 124, 128, 210), width=7)
    draw.line((256, 102, 256, 374), fill=(23, 32, 39, 175), width=4)
    draw.line((120, 238, 392, 238), fill=(23, 32, 39, 175), width=4)
    draw.polygon([(256, 126), (292, 240), (256, 350), (220, 240)], fill=(225, 111, 77, 235))
    draw.polygon([(256, 126), (220, 240), (256, 218), (292, 240)], fill=(243, 182, 74, 240))
    draw.ellipse((232, 214, 280, 262), fill=(23, 32, 39, 245))
    draw.text((240, 84), "N", fill=(23, 32, 39), font=font(34))
    draw_label(draw, "Compass", fill=(23, 32, 39))
    save_card("card_compass.png", image)


def make_lantern() -> None:
    image = vertical_gradient((512, 512), (28, 38, 48), (110, 66, 54))
    glow = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow, "RGBA")
    glow_draw.ellipse((108, 72, 404, 390), fill=(255, 196, 79, 110))
    image = Image.alpha_composite(image, glow.filter(ImageFilter.GaussianBlur(26)))
    draw = ImageDraw.Draw(image, "RGBA")
    draw.arc((174, 54, 338, 190), 190, 350, fill=(235, 230, 204, 240), width=10)
    draw.rounded_rectangle((158, 160, 354, 368), radius=34, fill=(63, 74, 74, 245), outline=(240, 230, 190, 200), width=7)
    draw.rounded_rectangle((196, 188, 316, 334), radius=30, fill=(255, 184, 74, 235))
    draw.rectangle((176, 126, 336, 174), fill=(38, 52, 56, 255))
    draw.rectangle((176, 360, 336, 392), fill=(38, 52, 56, 255))
    draw_label(draw, "Lantern")
    save_card("card_lantern.png", image)


def make_lake() -> None:
    image = vertical_gradient((512, 512), (103, 177, 197), (28, 100, 116))
    draw = ImageDraw.Draw(image, "RGBA")
    draw.ellipse((62, 78, 154, 170), fill=(250, 215, 104, 230))
    draw.polygon([(0, 260), (132, 132), (260, 264)], fill=(58, 106, 99, 245))
    draw.polygon([(146, 264), (326, 112), (512, 266)], fill=(48, 91, 94, 250))
    draw.polygon([(0, 278), (512, 278), (512, 512), (0, 512)], fill=(34, 115, 132, 255))
    for y in range(308, 405, 30):
        draw.line((45, y, 468, y + 10), fill=(255, 255, 255, 80), width=5)
    draw_label(draw, "Lake")
    save_card("card_lake.png", image)


def make_mountain() -> None:
    image = vertical_gradient((512, 512), (205, 228, 218), (96, 148, 143))
    draw = ImageDraw.Draw(image, "RGBA")
    draw.polygon([(28, 392), (168, 136), (316, 392)], fill=(60, 84, 88, 255))
    draw.polygon([(162, 392), (336, 96), (498, 392)], fill=(39, 70, 80, 255))
    draw.polygon([(128, 210), (168, 136), (210, 212), (176, 198)], fill=(245, 247, 238, 235))
    draw.polygon([(292, 170), (336, 96), (382, 172), (342, 154)], fill=(245, 247, 238, 235))
    draw.rectangle((0, 392, 512, 512), fill=(34, 89, 79, 255))
    for x in range(30, 500, 58):
        draw.polygon([(x, 404), (x + 22, 348), (x + 44, 404)], fill=(25, 70, 56, 255))
        draw.rectangle((x + 18, 400, x + 26, 434), fill=(31, 65, 42, 255))
    draw_label(draw, "Mountain")
    save_card("card_mountain.png", image)


def make_pine() -> None:
    image = vertical_gradient((512, 512), (222, 238, 218), (86, 153, 130))
    draw = ImageDraw.Draw(image, "RGBA")
    draw.rectangle((238, 302, 274, 406), fill=(93, 58, 37, 255))
    for top, width in [(82, 108), (148, 150), (222, 196)]:
        draw.polygon(
            [(256, top), (256 - width, top + 128), (256 + width, top + 128)],
            fill=(25, 104, 67, 255),
        )
    draw.polygon([(0, 396), (512, 396), (512, 512), (0, 512)], fill=(54, 118, 82, 255))
    for x, y in [(82, 112), (402, 156), (130, 230), (380, 276)]:
        draw.polygon(star_points(x, y, 12, 5), fill=(243, 182, 74, 180))
    draw_label(draw, "Pine")
    save_card("card_pine.png", image)


def make_star() -> None:
    image = vertical_gradient((512, 512), (22, 26, 56), (62, 74, 121))
    draw = ImageDraw.Draw(image, "RGBA")
    for x, y, size in [(74, 94, 7), (430, 118, 9), (106, 242, 5), (388, 270, 7), (248, 88, 5)]:
        draw.polygon(star_points(x, y, size, size / 2.4), fill=(255, 255, 255, 210))
    draw.polygon(star_points(256, 236, 130, 56), fill=(243, 182, 74, 245))
    draw.polygon(star_points(256, 236, 72, 30), fill=(255, 237, 153, 250))
    draw.polygon([(0, 398), (512, 398), (512, 512), (0, 512)], fill=(18, 31, 48, 255))
    draw_label(draw, "Star")
    save_card("card_star.png", image)


def make_background(name: str, game_variant: bool) -> None:
    image = vertical_gradient((1600, 1200), (19, 39, 55), (29, 113, 118))
    draw = ImageDraw.Draw(image, "RGBA")
    draw.ellipse((1120, 120, 1320, 320), fill=(243, 182, 74, 190))
    for y, color in [(250, (110, 198, 188, 70)), (315, (225, 111, 77, 55)), (380, (165, 95, 205, 52))]:
        draw.line([(0, y), (360, y - 95), (780, y + 28), (1180, y - 70), (1600, y + 14)], fill=color, width=34)
    draw.polygon([(0, 720), (280, 430), (590, 720)], fill=(36, 81, 83, 235))
    draw.polygon([(390, 735), (800, 350), (1220, 735)], fill=(26, 62, 72, 245))
    draw.polygon([(910, 730), (1210, 460), (1600, 730)], fill=(45, 97, 91, 230))
    draw.rectangle((0, 730, 1600, 1200), fill=(26, 94, 108, 245))
    for y in range(790, 1060, 64):
        draw.arc((-120, y - 35, 1720, y + 82), 6, 174, fill=(255, 255, 255, 34 if game_variant else 48), width=7)
    for x in range(-40, 1650, 95):
        h = 130 + (x % 260)
        draw.polygon([(x, 760), (x + 42, 760 - h), (x + 84, 760)], fill=(17, 66, 54, 210))
        draw.rectangle((x + 36, 758, x + 48, 835), fill=(27, 53, 39, 230))
    if game_variant:
        overlay = Image.new("RGBA", image.size, (244, 247, 244, 72))
        image = Image.alpha_composite(image, overlay)
    image.save(BACKGROUNDS_DIR / name)


def main() -> None:
    CARDS_DIR.mkdir(parents=True, exist_ok=True)
    BACKGROUNDS_DIR.mkdir(parents=True, exist_ok=True)
    make_card_back()
    make_aurora()
    make_canoe()
    make_compass()
    make_lantern()
    make_lake()
    make_mountain()
    make_pine()
    make_star()
    make_background("home_background.png", game_variant=False)
    make_background("game_background.png", game_variant=True)


if __name__ == "__main__":
    main()
