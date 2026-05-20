from __future__ import annotations

from datetime import datetime
from pathlib import Path
from typing import Iterable

from PIL import Image as PILImage
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Image, PageBreak, Paragraph, Preformatted, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "README.pdf"
SCREENSHOT_CAPTIONS = [
    ("Home screen and difficulty selection", "screenshots/Screenshot_20260520_024200.png"),
    ("Active game screen", "screenshots/Screenshot_20260520_024216.png"),
    ("Near-complete game state", "screenshots/Screenshot_20260520_024524.png"),
    ("Win/result screen", "screenshots/Screenshot_20260520_024535.png"),
]

EXCLUDED_DIRS = {
    ".git",
    ".dart_tool",
    ".idea",
    ".gradle",
    "build",
    "__pycache__",
    "coverage",
    "ephemeral",
    "Pods",
    ".symlinks",
    ".pub",
    ".pub-cache",
}
EXCLUDED_FILES = {
    ".DS_Store",
    "local.properties",
    "MC_Exercise2_2026NN.pdf",
    "Generated.xcconfig",
    "GeneratedPluginRegistrant.java",
    "flutter_export_environment.sh",
    "Screenshot_20260520_024230.png",
}
EXCLUDED_SUFFIXES = {".zip", ".iml"}


def project_tree() -> str:
    lines = ["."]

    def excluded(path: Path) -> bool:
        rel = path.relative_to(ROOT)
        parts = set(rel.parts)
        if parts & EXCLUDED_DIRS:
            return True
        if path.name in EXCLUDED_FILES:
            return True
        return path.suffix in EXCLUDED_SUFFIXES

    def walk(directory: Path, prefix: str = "") -> None:
        entries = [
            path
            for path in sorted(directory.iterdir(), key=lambda p: (p.is_file(), p.name.lower()))
            if not excluded(path)
        ]
        for index, path in enumerate(entries):
            connector = "`-- " if index == len(entries) - 1 else "|-- "
            lines.append(f"{prefix}{connector}{path.name}{'/' if path.is_dir() else ''}")
            if path.is_dir():
                extension = "    " if index == len(entries) - 1 else "|   "
                walk(path, prefix + extension)

    walk(ROOT)
    return "\n".join(lines)


def bullet(items: Iterable[str], styles: dict[str, ParagraphStyle]) -> list[Paragraph]:
    return [Paragraph(f"- {item}", styles["Body"]) for item in items]


def scaled_image(path: Path, max_width: float, max_height: float) -> Image:
    with PILImage.open(path) as img:
        width, height = img.size
    scale = min(max_width / width, max_height / height)
    image = Image(str(path), width=width * scale, height=height * scale)
    image.hAlign = "CENTER"
    return image


def header_footer(canvas, doc) -> None:
    canvas.saveState()
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.HexColor("#60717A"))
    canvas.drawString(0.65 * inch, 0.38 * inch, "CS5450 Exercise 2 - Memory Matching Flutter Game")
    canvas.drawRightString(7.85 * inch, 0.38 * inch, f"Page {doc.page}")
    canvas.restoreState()


def build_pdf() -> None:
    doc = SimpleDocTemplate(
        str(OUTPUT),
        pagesize=letter,
        rightMargin=0.62 * inch,
        leftMargin=0.62 * inch,
        topMargin=0.62 * inch,
        bottomMargin=0.62 * inch,
        title="Memory Matching Flutter Game",
        author="Luqman Aadil",
    )

    base = getSampleStyleSheet()
    styles = {
        "Title": ParagraphStyle(
            "Title",
            parent=base["Title"],
            fontName="Helvetica-Bold",
            fontSize=26,
            leading=32,
            textColor=colors.HexColor("#172027"),
            alignment=TA_CENTER,
            spaceAfter=18,
        ),
        "Subtitle": ParagraphStyle(
            "Subtitle",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=11,
            leading=16,
            textColor=colors.HexColor("#172027"),
            alignment=TA_CENTER,
            spaceAfter=8,
        ),
        "H1": ParagraphStyle(
            "H1",
            parent=base["Heading1"],
            fontName="Helvetica-Bold",
            fontSize=17,
            leading=21,
            textColor=colors.HexColor("#0F7C80"),
            spaceBefore=10,
            spaceAfter=8,
        ),
        "H2": ParagraphStyle(
            "H2",
            parent=base["Heading2"],
            fontName="Helvetica-Bold",
            fontSize=13,
            leading=17,
            textColor=colors.HexColor("#172027"),
            spaceBefore=8,
            spaceAfter=5,
        ),
        "Body": ParagraphStyle(
            "Body",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=9.6,
            leading=13.5,
            textColor=colors.HexColor("#172027"),
            spaceAfter=5,
        ),
        "Small": ParagraphStyle(
            "Small",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=8,
            leading=10,
            textColor=colors.HexColor("#172027"),
        ),
        "Code": ParagraphStyle(
            "Code",
            parent=base["Code"],
            fontName="Courier",
            fontSize=6.4,
            leading=8,
            textColor=colors.HexColor("#172027"),
        ),
        "Caption": ParagraphStyle(
            "Caption",
            parent=base["BodyText"],
            fontName="Helvetica-Bold",
            fontSize=8.4,
            leading=10.5,
            textColor=colors.HexColor("#0F7C80"),
            alignment=TA_CENTER,
            spaceBefore=4,
            spaceAfter=8,
        ),
    }

    story = []

    story.append(Spacer(1, 1.2 * inch))
    story.append(Paragraph("Memory Matching Flutter Game", styles["Title"]))
    story.append(Paragraph("CS5450 Mobile Programming", styles["Subtitle"]))
    story.append(Paragraph("Exercise 2", styles["Subtitle"]))
    story.append(Spacer(1, 0.25 * inch))
    cover_data = [
        ["Instructor", "Dr. Sabah Mohammed"],
        ["Student", "Luqman Aadil"],
        ["Repository", "https://github.com/luqi101/Mobile_Programming_Exercise_2.git"],
        ["Date generated", datetime.now().strftime("%B %d, %Y")],
    ]
    cover_table = Table(cover_data, colWidths=[1.5 * inch, 4.8 * inch])
    cover_table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#0F7C80")),
                ("TEXTCOLOR", (0, 0), (0, -1), colors.white),
                ("FONTNAME", (0, 0), (-1, -1), "Helvetica-Bold"),
                ("FONTNAME", (1, 0), (1, -1), "Helvetica"),
                ("FONTSIZE", (0, 0), (-1, -1), 10),
                ("GRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#B8DCD8")),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("LEFTPADDING", (0, 0), (-1, -1), 8),
                ("RIGHTPADDING", (0, 0), (-1, -1), 8),
                ("TOPPADDING", (0, 0), (-1, -1), 7),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
            ]
        )
    )
    story.append(cover_table)
    story.append(PageBreak())

    story.append(Paragraph("Executive Overview", styles["H1"]))
    story.append(
        Paragraph(
            "Memory Match is an original Flutter/Dart memory matching game created for CS5450 Exercise 2. "
            "The user selects a difficulty, flips cards to find matching pairs, tracks time and moves, "
            "and receives a final score on completion. The implementation uses local image assets, a "
            "responsive card grid, and controller-driven game logic.",
            styles["Body"],
        )
    )

    story.append(Paragraph("Requirements Coverage", styles["H1"]))
    coverage = [
        ["Requirement", "Project coverage"],
        ["Flutter/Dart implementation", "Application source is implemented under lib/ using Flutter widgets and Dart models/controllers."],
        ["Memory matching functionality", "Cards are generated in pairs, shuffled, flipped, matched, and reset after mismatches."],
        ["Configuration and run steps", "README.md and this PDF include setup, Android, Chrome, analysis, and test commands."],
        ["Screenshots", "Real screenshots from the screenshots/ folder are included."],
        ["Exact project structure", "A generated project tree is included, excluding build/cache/IDE artifacts."],
        ["Local images/assets", "Local PNG assets are stored in assets/images and registered in pubspec.yaml."],
        ["GitHub/ZIP readiness", "The full Flutter project source, assets, tests, screenshots, and documentation are prepared for upload and packaging."],
    ]
    coverage_table = Table(coverage, colWidths=[2.1 * inch, 5.0 * inch], repeatRows=1)
    coverage_table.setStyle(table_style())
    story.append(coverage_table)

    story.append(Paragraph("Features", styles["H1"]))
    story.extend(
        bullet(
            [
                "Home screen with difficulty selection.",
                "Responsive game grid with animated card flip behavior.",
                "Two-card comparison with matched cards retained and mismatches flipped back after a delay.",
                "Input lock during mismatch delay to prevent rapid-tap errors.",
                "Timer, moves counter, matched-pair counter, restart, and new-game actions.",
                "Win/result screen with difficulty, time, moves, matched pairs, score, play again, and home actions.",
                "Original local card and background images generated for this project.",
            ],
            styles,
        )
    )

    story.append(Paragraph("Game Rules And Difficulty", styles["H1"]))
    story.append(
        Paragraph(
            "The player flips two cards at a time. Matching cards stay face up and count toward completion. "
            "Non-matching cards flip back after a short delay. A move is counted once per two-card attempt. "
            "The game finishes when every pair has been matched.",
            styles["Body"],
        )
    )
    diff_table = Table(
        [["Difficulty", "Pairs", "Cards"], ["Easy", "4", "8"], ["Medium", "6", "12"], ["Hard", "8", "16"]],
        colWidths=[2.2 * inch, 1.2 * inch, 1.2 * inch],
        repeatRows=1,
    )
    diff_table.setStyle(table_style())
    story.append(diff_table)

    story.append(Paragraph("Technical Implementation", styles["H1"]))
    story.extend(
        bullet(
            [
                "Game state is handled by GameController, a ChangeNotifier that owns deck generation, selected cards, move count, matched-pair count, timer cleanup, restart behavior, and win detection.",
                "Models are separated into Difficulty, MemoryCard, and GameResult.",
                "Scoring is isolated in lib/utils/scoring.dart and duration formatting is isolated in lib/utils/formatters.dart.",
                "Screens and reusable widgets are separated under lib/screens and lib/widgets.",
                "Assets are local PNG files under assets/images/cards and assets/images/backgrounds and are registered in pubspec.yaml.",
                "Tests cover controller behavior, matching/mismatch behavior, restart state, score calculation, and the core widget flow.",
            ],
            styles,
        )
    )

    story.append(PageBreak())
    story.append(Paragraph("Setup And Run Instructions", styles["H1"]))
    command_text = """flutter pub get
python3 tools/generate_assets.py
dart format .
flutter analyze
flutter test
flutter devices
flutter run -d <android-device-id>
flutter run -d chrome"""
    story.append(Preformatted(command_text, styles["Code"]))
    story.append(
        Paragraph(
            "For Android testing, start an emulator or connect a physical device, then replace "
            "<android-device-id> with the id shown by flutter devices. Chrome/Web is also supported.",
            styles["Body"],
        )
    )

    story.append(Paragraph("Testing And Verification", styles["H1"]))
    verification = [
        ["Command", "Latest result"],
        ["flutter clean", "Pass"],
        ["flutter pub get", "Pass"],
        ["dart format .", "Pass, no changes required"],
        ["flutter analyze", "Pass, no issues found"],
        ["flutter test", "Pass, 13 tests"],
        ["flutter devices", "Android emulator and Chrome detected"],
    ]
    verification_table = Table(verification, colWidths=[2.3 * inch, 4.8 * inch], repeatRows=1)
    verification_table.setStyle(table_style())
    story.append(verification_table)

    story.append(PageBreak())
    story.append(Paragraph("Screenshots", styles["H1"]))
    for caption, rel_path in SCREENSHOT_CAPTIONS:
        path = ROOT / rel_path
        story.append(Paragraph(caption, styles["Caption"]))
        story.append(scaled_image(path, 3.0 * inch, 5.55 * inch))
        story.append(Spacer(1, 0.16 * inch))

    story.append(PageBreak())
    story.append(Paragraph("Exact Project Structure", styles["H1"]))
    story.append(
        Paragraph(
            "The following structure is generated from the current project directory. Build outputs, cache folders, Git metadata, IDE caches, and temporary OS files are excluded.",
            styles["Body"],
        )
    )
    story.append(Preformatted(project_tree(), styles["Code"]))

    story.append(PageBreak())
    story.append(Paragraph("Final Submission Checklist", styles["H1"]))
    checklist = [
        ["Item", "Status"],
        ["Dart source files present", "Pass"],
        ["Local assets/images present", "Pass"],
        ["Real screenshots present", "Pass"],
        ["README.md present", "Pass"],
        ["README.pdf present", "Pass"],
        ["flutter analyze", "Pass"],
        ["flutter test", "Pass"],
        ["GitHub repository", "Prepared for public push to the repository URL on the cover page"],
        ["ZIP/D2L package", "Ready to package after final repository verification"],
    ]
    checklist_table = Table(checklist, colWidths=[2.6 * inch, 4.5 * inch], repeatRows=1)
    checklist_table.setStyle(table_style())
    story.append(checklist_table)

    doc.build(story, onFirstPage=header_footer, onLaterPages=header_footer)


def table_style() -> TableStyle:
    return TableStyle(
        [
            ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#0F7C80")),
            ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
            ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
            ("FONTNAME", (0, 1), (-1, -1), "Helvetica"),
            ("FONTSIZE", (0, 0), (-1, -1), 8.5),
            ("LEADING", (0, 0), (-1, -1), 10.5),
            ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#B8DCD8")),
            ("VALIGN", (0, 0), (-1, -1), "TOP"),
            ("LEFTPADDING", (0, 0), (-1, -1), 6),
            ("RIGHTPADDING", (0, 0), (-1, -1), 6),
            ("TOPPADDING", (0, 0), (-1, -1), 5),
            ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
            ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#F4F7F4")]),
        ]
    )


if __name__ == "__main__":
    build_pdf()
