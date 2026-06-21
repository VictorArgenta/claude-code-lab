"""Genera un PowerPoint de kickoff EPM con 7 diapositivas usando python-pptx.

Pensado para ser invocado desde New-KickoffPPT.ps1, que valida los parametros
y construye la llamada. Tambien puede ejecutarse de forma aislada:

    python build_kickoff_ppt.py --client "ACME" --tool OneStream \
        --date 2026-06-21 --team-lead "Victor Argenta" --output "./Kickoff-ACME.pptx"

El contenido es una plantilla profesional con placeholders editables: no
inventa datos del cliente, solo deja la estructura lista para rellenar.
"""

import argparse
import sys

from pptx import Presentation
from pptx.util import Pt, Inches
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN


# Paleta sobria corporativa, reutilizable en proyectos reales.
COLOR_PRIMARY = RGBColor(0x1F, 0x3A, 0x5F)   # azul oscuro
COLOR_ACCENT = RGBColor(0x2E, 0x86, 0xC1)    # azul medio
COLOR_TEXT = RGBColor(0x33, 0x33, 0x33)      # gris texto

# Las 7 fases EPM, coherentes con New-EPMProject.ps1.
EPM_PHASES = [
    ("Kickoff", "Arranque del proyecto: alcance, equipo, planificacion."),
    ("Functional specs", "Especificaciones funcionales y requisitos."),
    ("Data model", "Diseno del modelo de datos y dimensiones."),
    ("Testing", "Casos de prueba, UAT y evidencias."),
    ("Training", "Material y sesiones de formacion."),
    ("Go-live", "Puesta en produccion y checklist de salida."),
    ("Hypercare", "Soporte intensivo posterior al go-live."),
]

# Etiqueta legible de la herramienta EPM para mostrar en las diapositivas.
TOOL_LABELS = {
    "OneStream": "OneStream",
    "OracleEPM": "Oracle EPM",
    "Anaplan": "Anaplan",
}


def _add_title_only_slide(prs):
    """Devuelve una diapositiva en blanco para componer el contenido a mano."""
    blank_layout = prs.slide_layouts[6]
    return prs.slides.add_slide(blank_layout)


def _add_heading(slide, text):
    """Anade un titulo de seccion en la parte superior de la diapositiva."""
    box = slide.shapes.add_textbox(Inches(0.6), Inches(0.4), Inches(12.1), Inches(1.0))
    tf = box.text_frame
    tf.word_wrap = True
    p = tf.paragraphs[0]
    run = p.add_run()
    run.text = text
    run.font.size = Pt(32)
    run.font.bold = True
    run.font.color.rgb = COLOR_PRIMARY
    return box


def _add_bullets(slide, items, top=1.6, left=0.8, width=11.7, height=5.3):
    """Anade una lista de vinetas a partir de tuplas (nivel, texto)."""
    box = slide.shapes.add_textbox(Inches(left), Inches(top), Inches(width), Inches(height))
    tf = box.text_frame
    tf.word_wrap = True
    for i, (level, text) in enumerate(items):
        p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
        p.level = level
        p.space_after = Pt(8)
        run = p.add_run()
        run.text = text
        run.font.size = Pt(20) if level == 0 else Pt(16)
        run.font.color.rgb = COLOR_TEXT
        if level == 0:
            run.font.bold = True
    return box


def build_cover(prs, client, tool_label, date, team_lead):
    """Diapositiva 1: portada."""
    slide = _add_title_only_slide(prs)

    # Banda de color superior como elemento visual de portada.
    band = slide.shapes.add_shape(
        1, Inches(0), Inches(2.3), prs.slide_width, Inches(2.6)
    )
    band.fill.solid()
    band.fill.fore_color.rgb = COLOR_PRIMARY
    band.line.fill.background()

    tf = band.text_frame
    tf.word_wrap = True
    p = tf.paragraphs[0]
    p.alignment = PP_ALIGN.CENTER
    run = p.add_run()
    run.text = "Kickoff de Proyecto EPM"
    run.font.size = Pt(40)
    run.font.bold = True
    run.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)

    p2 = tf.add_paragraph()
    p2.alignment = PP_ALIGN.CENTER
    run2 = p2.add_run()
    run2.text = client
    run2.font.size = Pt(28)
    run2.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)

    # Metadatos bajo la banda.
    meta_lines = [f"Herramienta EPM: {tool_label}", f"Fecha: {date}"]
    if team_lead:
        meta_lines.append(f"Team Lead: {team_lead}")
    box = slide.shapes.add_textbox(Inches(0.6), Inches(5.2), Inches(12.1), Inches(1.5))
    mtf = box.text_frame
    mtf.word_wrap = True
    for i, line in enumerate(meta_lines):
        p = mtf.paragraphs[0] if i == 0 else mtf.add_paragraph()
        p.alignment = PP_ALIGN.CENTER
        run = p.add_run()
        run.text = line
        run.font.size = Pt(18)
        run.font.color.rgb = COLOR_ACCENT


def build_agenda(prs):
    """Diapositiva 2: agenda (refleja las propias secciones de la sesion)."""
    slide = _add_title_only_slide(prs)
    _add_heading(slide, "Agenda")
    items = [
        (0, "1. Objetivos del proyecto"),
        (0, "2. Alcance"),
        (0, "3. Equipo y roles"),
        (0, "4. Hitos y timeline"),
        (0, "5. Proximos pasos"),
    ]
    _add_bullets(slide, items)


def build_objectives(prs):
    """Diapositiva 3: objetivos (placeholders editables)."""
    slide = _add_title_only_slide(prs)
    _add_heading(slide, "Objetivos")
    items = [
        (0, "Objetivo de negocio"),
        (1, "[Describir el resultado de negocio esperado]"),
        (0, "Objetivos del proyecto"),
        (1, "[Objetivo 1]"),
        (1, "[Objetivo 2]"),
        (1, "[Objetivo 3]"),
        (0, "Criterios de exito"),
        (1, "[Como mediremos que el proyecto ha tenido exito]"),
    ]
    _add_bullets(slide, items)


def build_scope(prs):
    """Diapositiva 4: alcance (in-scope / out-of-scope)."""
    slide = _add_title_only_slide(prs)
    _add_heading(slide, "Alcance")
    items = [
        (0, "Dentro de alcance"),
        (1, "[Procesos / modulos incluidos]"),
        (1, "[Entidades / dimensiones]"),
        (1, "[Integraciones]"),
        (0, "Fuera de alcance"),
        (1, "[Lo que explicitamente NO se aborda]"),
        (0, "Supuestos y dependencias"),
        (1, "[Supuestos clave del proyecto]"),
    ]
    _add_bullets(slide, items)


def build_team(prs, team_lead):
    """Diapositiva 5: equipo y roles."""
    slide = _add_title_only_slide(prs)
    _add_heading(slide, "Equipo y roles")
    lead_text = team_lead if team_lead else "[Nombre]"
    items = [
        (0, f"Team Lead: {lead_text}"),
        (1, "Responsable de la entrega y punto de contacto principal."),
        (0, "Sponsor de cliente"),
        (1, "[Nombre / rol]"),
        (0, "Consultores funcionales"),
        (1, "[Nombres]"),
        (0, "Consultores tecnicos"),
        (1, "[Nombres]"),
        (0, "Key users de cliente"),
        (1, "[Nombres por area]"),
    ]
    _add_bullets(slide, items)


def build_timeline(prs):
    """Diapositiva 6: hitos / timeline a partir de las 7 fases EPM."""
    slide = _add_title_only_slide(prs)
    _add_heading(slide, "Hitos y timeline")
    items = []
    for idx, (name, purpose) in enumerate(EPM_PHASES, start=1):
        items.append((0, f"Fase {idx}: {name}"))
        items.append((1, f"{purpose} [Fechas: por definir]"))
    _add_bullets(slide, items, height=5.6)


def build_next_steps(prs):
    """Diapositiva 7: proximos pasos."""
    slide = _add_title_only_slide(prs)
    _add_heading(slide, "Proximos pasos")
    items = [
        (0, "Acciones inmediatas"),
        (1, "[Accion] - Owner: [nombre] - Fecha: [dd/mm]"),
        (1, "[Accion] - Owner: [nombre] - Fecha: [dd/mm]"),
        (0, "Decisiones pendientes"),
        (1, "[Decision que requiere cierre]"),
        (0, "Proxima reunion"),
        (1, "[Fecha y objetivo del siguiente checkpoint]"),
    ]
    _add_bullets(slide, items)


def build_presentation(client, tool, date, team_lead, output):
    """Construye y guarda la presentacion completa."""
    tool_label = TOOL_LABELS.get(tool, tool)

    prs = Presentation()
    # Formato panoramico 16:9.
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)

    build_cover(prs, client, tool_label, date, team_lead)
    build_agenda(prs)
    build_objectives(prs)
    build_scope(prs)
    build_team(prs, team_lead)
    build_timeline(prs)
    build_next_steps(prs)

    prs.save(output)
    return output


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Genera un PowerPoint de kickoff EPM (7 diapositivas)."
    )
    parser.add_argument("--client", required=True, help="Nombre del cliente.")
    parser.add_argument(
        "--tool",
        default="OneStream",
        choices=["OneStream", "OracleEPM", "Anaplan"],
        help="Herramienta EPM.",
    )
    parser.add_argument("--date", required=True, help="Fecha del proyecto (yyyy-MM-dd).")
    parser.add_argument("--team-lead", default="", help="Team Lead del proyecto.")
    parser.add_argument("--output", required=True, help="Ruta del .pptx de salida.")
    args = parser.parse_args(argv)

    try:
        path = build_presentation(
            args.client, args.tool, args.date, args.team_lead, args.output
        )
    except Exception as exc:  # noqa: BLE001 - reportar cualquier fallo al wrapper
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    print(path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
