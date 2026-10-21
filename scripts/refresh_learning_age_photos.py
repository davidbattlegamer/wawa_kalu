"""Corrige las fotografías que no corresponden al juego o grupo de edad.

Fotos descargadas de archivos identificados en Wikimedia Commons. No altera
la composición de las tarjetas, el código de Flutter ni las demás fotos.
"""
from __future__ import annotations

import hashlib
import io
import pathlib
import re
import time
import urllib.parse
import urllib.request

from PIL import Image, ImageOps
from import_learning_photos import choose_file

DEST = pathlib.Path("assets/images/learning")
CREDITS = DEST / "FUENTES_FOTOGRAFIAS.md"
UA = "WawaKaluLearning/1.0 (public Wikimedia Commons pictures; educational family app)"

# Título de Commons, autor, licencia, justificación de edad y juego.
UPDATES = {
    "ropa": (
        "Jeans and brown shirt folded.jpg", "Ejdowning00",
        "CC BY-SA 4.0", "https://creativecommons.org/licenses/by-sa/4.0/",
        "Prendas plegadas y ordenadas, tarea segura y accesible para 24–35 meses con acompañamiento. No muestra niños de mayor edad.",
    ),
    "cuento": (
        "McConnell incorporates '6 by 6' 121023-F-EP111-016.jpg", "Senior Airman Katrina Brisbin (U.S. Air Force)",
        "Dominio público", "",
        "Lectura compartida de cuentos con niños de edad preescolar, apropiada como referencia de 36–47 meses.",
    ),
    "torres": (
        "Child playing with large Mega Bloks.jpg", "MHV",
        "Dominio público", "",
        "Bloques grandes pensados para menores de 2 años, etapa de 12 a 23 meses.",
    ),
    "cojines": (
        "A ln American toddler plays at home in 2023.jpg", "Tenley235",
        "CC BY-SA 4.0", "https://creativecommons.org/licenses/by-sa/4.0/",
        "Niño pequeño jugando en casa: referencia de motricidad doméstica a los 2–3 años; no muestra específicamente el recorrido con cojines.",
    ),
    "patrones": (
        "A symmetrical pattern block design created by eight year olds.jpg", "Annielogue",
        "CC BY-SA 4.0", "https://creativecommons.org/licenses/by-sa/4.0/",
        "Fotografía de una secuencia/patrón de bloques como referencia para juego de patrones a los 4–5 años; el modelo fotografiado es avanzado.",
    ),
    "emociones": (
        "Emotions , Children Girls, هیجان، دختر بچه 12.jpg", "Mostafameraji",
        "CC BY-SA 4.0", "https://creativecommons.org/licenses/by-sa/4.0/",
        "Niña de cinco años y medio mostrando una emoción mediante su expresión corporal o facial.",
    ),
    "leer_imagenes": (
        "Picturebook1.JPG", "Brams",
        "Dominio público", "",
        "Fotografía de un niño de dos años explorando un libro de imágenes.",
    ),
    "turnos_conversacion": (
        "The conversation.jpg", "Armup Media",
        "CC BY-SA 4.0", "https://creativecommons.org/licenses/by-sa/4.0/",
        "Madre e hijo conversando frente a su casa; fotografía de interacción verbal.",
    ),
    "nombrar_objetos": (
        "Infant explores colorful toy while seated in a high chair, showcasing sensory play and fine motor development.jpg",
        "Shixart1985", "CC BY 2.0", "https://creativecommons.org/licenses/by/2.0/",
        "Niño pequeño explorando un objeto de colores, etapa inicial del vocabulario.",
    ),
}


def download(url: str) -> bytes:
    last_exc = None
    for n in range(3):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": UA})
            with urllib.request.urlopen(req, timeout=75) as fp:
                return fp.read()
        except Exception as exc:
            last_exc = exc
            time.sleep(n + 1)
    raise RuntimeError(f"Fallo al descargar {url}: {last_exc}")


def commons_original_url(title: str) -> str:
    file = title.replace(" ", "_")
    md5 = hashlib.md5(file.encode("utf-8")).hexdigest()
    url = urllib.parse.quote(file, safe="(),'")
    return f"https://upload.wikimedia.org/wikipedia/commons/{md5[0]}/{md5[:2]}/{url}"


def download_photo(title: str) -> Image.Image:
    original = commons_original_url(title)
    name = title.replace(" ", "_")
    md5 = hashlib.md5(name.encode("utf-8")).hexdigest()
    # Pedir primero miniatura, sin descargar originales de decenas de MB.
    thumb = original.replace(
        "/wikipedia/commons/", "/wikipedia/commons/thumb/"
    ) + "/960px-" + urllib.parse.quote(name, safe="(),'")
    for url in [thumb, original]:
        try:
            data = download(url)
            if len(data) < 4000:
                continue
            with Image.open(io.BytesIO(data)) as img:
                return ImageOps.exif_transpose(img).convert("RGB")
        except Exception as exc:
            print(f"Probando descarga alternativa para {title}: {exc}")
    # Las URL originales pueden rechazarse; la API de Commons ofrece
    # miniaturas con URL canónica, más fiables para títulos antiguos.
    try:
        item = choose_file(title)
        if item:
            link = item["info"].get("thumburl") or item["info"]["url"]
            payload = download(link)
            with Image.open(io.BytesIO(payload)) as image:
                return ImageOps.exif_transpose(image).convert("RGB")
    except Exception as exc:
        print(f"Fallo también la API de Wikimedia para {title}: {exc}")
    raise RuntimeError(f"No se pudo obtener {title}")


def main() -> None:
    text = CREDITS.read_text(encoding="utf-8")
    for id, (title, author, license_name, license_url, note) in UPDATES.items():
        # Evitar solicitudes repetidas a Commons para fotos ya actualizadas.
        block = re.search(rf"### {re.escape(id)}\.webp\n\n([\s\S]*?)(?=### |$)", text)
        if block and f"File:{title}" in block.group(1):
            print(f"Ya está actualizada: {id}")
            continue
        try:
            image = download_photo(title)
        except Exception as e:
            print(f"AVISO: sin reemplazar {id}: {e}")
            continue  # Evita romper imágenes locales ya existentes.
        image.thumbnail((960, 760), Image.Resampling.LANCZOS)
        target = DEST / (id + ".webp")
        image.save(target, "WEBP", quality=82, method=6)
        url = "https://commons.wikimedia.org/wiki/File:" + urllib.parse.quote(title.replace(" ", "_"), safe="(),")
        replacement = (
            f"### {id}.webp\n\n"
            f"- **Fotografía:** File:{title}\n"
            f"- **Autor:** {author}\n"
            f"- **Licencia:** {license_name} ({license_url})\n"
            f"- **Fuente:** {url}\n"
            f"- **Modificación:** redimensionada y convertida a WebP local.\n"
            f"- **Edad y actividad:** {note}\n"
            f"- **Precaución:** imagen referencial; no permite verificar por sí sola la edad de las personas.\n\n"
        )
        pattern = rf"### {re.escape(id)}\.webp\n.*?(?=### |\Z)"
        if not re.search(pattern, text, flags=re.S):
            raise RuntimeError(f"No existe ficha de crédito para {id}")
        text = re.sub(pattern, lambda _: replacement, text, count=1, flags=re.S)
        print(f"ACTUALIZADA {id}: {title} ({target.stat().st_size // 1024} KiB)")
    CREDITS.write_text(text, encoding="utf-8")


if __name__ == "__main__":
    main()
