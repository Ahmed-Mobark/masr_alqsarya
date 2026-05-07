import os
import sys
from datetime import datetime


def _ensure_local_deps_on_path() -> None:
    """
    We install Python deps into tools/_pydeps to avoid global/user installs.
    """
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    deps = os.path.join(root, "tools", "_pydeps")
    if os.path.isdir(deps) and deps not in sys.path:
        sys.path.insert(0, deps)


def _read_text(path: str) -> str:
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def main() -> int:
    _ensure_local_deps_on_path()

    try:
        from reportlab.lib.pagesizes import A4
        from reportlab.lib.styles import ParagraphStyle
        from reportlab.lib.units import mm
        from reportlab.platypus import Paragraph, Preformatted, SimpleDocTemplate, Spacer
    except Exception as e:  # pragma: no cover
        print(
            "Missing dependency: reportlab.\n"
            "Install it into tools/_pydeps via:\n"
            "  python3 -m pip install -t tools/_pydeps reportlab\n"
            f"\nOriginal error: {e}",
            file=sys.stderr,
        )
        return 2

    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    screens = [
        ("Login", "lib/features/auth/presentation/view/login_view.dart"),
        ("Home", "lib/features/home/presentation/view/home_view.dart"),
        ("Main Navigation", "lib/features/nav_bar/presentation/view/main_nav_view.dart"),
        ("Profile", "lib/features/profile/presentation/view/profile_view.dart"),
        ("Sessions", "lib/features/sessions/presentation/view/sessions_view.dart"),
        ("Settings", "lib/features/settings/presentation/view/settings_view.dart"),
    ]

    out_dir = os.path.join(repo_root, "artifacts")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "ip_screens_code.pdf")

    doc = SimpleDocTemplate(
        out_path,
        pagesize=A4,
        leftMargin=18 * mm,
        rightMargin=18 * mm,
        topMargin=16 * mm,
        bottomMargin=16 * mm,
        title="Masr Al-Qsariya — Screens Code Extract",
        author="Masr Al-Qsariya",
    )

    title_style = ParagraphStyle(
        name="Title",
        fontName="Helvetica-Bold",
        fontSize=16,
        leading=20,
        spaceAfter=10,
    )
    meta_style = ParagraphStyle(
        name="Meta",
        fontName="Helvetica",
        fontSize=9,
        leading=12,
        textColor="#444444",
        spaceAfter=12,
    )
    section_style = ParagraphStyle(
        name="Section",
        fontName="Helvetica-Bold",
        fontSize=12,
        leading=16,
        spaceBefore=10,
        spaceAfter=6,
    )
    code_style = ParagraphStyle(
        name="Code",
        fontName="Courier",
        fontSize=7.5,
        leading=9.2,
    )

    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    story = [
        Paragraph("Masr Al-Qsariya — Code extracts (main screens)", title_style),
        Paragraph(f"Generated: {now}", meta_style),
    ]

    for screen_title, rel_path in screens:
        abs_path = os.path.join(repo_root, rel_path)
        code = _read_text(abs_path) if os.path.exists(abs_path) else f"// Missing file: {rel_path}\n"
        story.append(Paragraph(f"{screen_title} — {rel_path}", section_style))
        story.append(Preformatted(code, code_style))
        story.append(Spacer(1, 10))

    doc.build(story)
    print(out_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

