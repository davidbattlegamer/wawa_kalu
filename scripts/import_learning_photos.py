"""Importa fotografías libres de Wikimedia Commons para el módulo Aprender.

Las fotos se guardan como WebP locales, y sus créditos en el mismo directorio.
Solo incluye actividades y juegos: las fichas de protección quedan intactas.
Ejecutar: pip install pillow && python scripts/import_learning_photos.py
"""

from __future__ import annotations

import html
import io
import json
import pathlib
import re
import time
import urllib.error
import urllib.parse
import urllib.request

from PIL import Image, ImageOps

API = "https://commons.wikimedia.org/w/api.php"
USER_AGENT = "WawaKalu-Educational/1.0 (offline photos; attribution in repo)"
DEST = pathlib.Path("assets/images/learning")

# Fotos verificadas como existentes en Wikimedia Commons. Los metadatos
# de licencia se consultan siempre antes de incluir cada recurso.
PHOTOS = {
    "texturas": ("Sensory Play with sand box.jpg", "toddler sensory texture play"),
    "torres": ("Child engaging in colorful wooden block sorting activity.jpg", "child stacking blocks toys"),
    "canciones": ("Photo taken in Burundi of Children singing with their caregiver in front of them.jpg", "children singing songs caregiver"),
    "ropa": ("Child Hanging Laundry.jpg", "child helping fold laundry"),
    "cojines": ("Pillow Fight IMG 0728 (3412764396).jpg", "children playing with cushions"),
    "casita": ("Doll's house.jpg", "children playing with dollhouse"),
    "cuento": ("Child reading book.jpg", "preschool child storytelling picture book"),
    "pintura": ("Finger Painting.jpg", "child finger painting"),
    "mercado": ("Pretend-city-grocery-store.jpg", "child playing pretend grocery shop"),
    "patrones": ("Shape sorter.jpg", "children arranging color shape patterns"),
    "barrio": ("Lego City.jpg", "children building lego city"),
    "emociones": ("Child Smiling.jpg", "child showing facial emotion"),
    "nombrar_objetos": ("Infant explores colorful toy while seated in a high chair, showcasing sensory play and fine motor development.jpg", "toddler identifying toys objects"),
    "leer_imagenes": ("A child and adult reading book in Venezuela.jpg", "adult preschool child reading picture book"),
    "turnos_conversacion": ("Mother and child talk.jpg", "mother speaking with young child"),
    "juego_sonidos": ("Little girl playing a toy xylophone closeup.jpg", "child playing toy musical instrument"),
}

# Si Commons no encuentra la imagen principal, una foto temática y
# reutilizable evita dejar recursos faltantes en el APK.
FALLBACK = {
    "texturas": "Shape sorter.jpg",
    "torres": "Shape sorter.jpg",
    "canciones": "School children singing. Pie Town, New Mexico, October 1940.jpg",
    "ropa": "Laundry.jpg",
    "cojines": "Child engaging in colorful wooden block sorting activity.jpg",
    "casita": "JLL Childhood Collection3 dolls in front of a dolls house 2783.JPG",
    "cuento": "Child reading book.jpg",
    "pintura": "Child painting.JPG",
    "mercado": "Children playing grocery store, ca 1921 (MOHAI 5121).jpg",
    "patrones": "Shape sorter.jpg",
    "barrio": "Lego City.jpg",
    "emociones": "Emotions , Children Girls, هیجان، دختر بچه 11.jpg",
    "nombrar_objetos": "Shape sorter.jpg",
    "leer_imagenes": "Child reading book.jpg",
    "turnos_conversacion": "Mother and daughter talking.jpg",
    "juego_sonidos": "Playing the Xylophone.jpg",
}


def read_url(url: str, *, attempts: int = 4) -> bytes:
    last_error = None
    for attempt in range(attempts):
        try:
            request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
            with urllib.request.urlopen(request, timeout=60) as response:
                return response.read()
        except (urllib.error.URLError, TimeoutError, OSError) as exc:
            last_error = exc
            time.sleep(1 + attempt * 2)
    raise RuntimeError("Fallo al descargar {}: {}".format(url, last_error))


def commons(**parameters: object) -> dict:
    arguments = {"action": "query", "format": "json", "formatversion": 2}
    arguments.update(parameters)
    url = API + "?" + urllib.parse.urlencode(arguments)
    return json.loads(read_url(url))


def license_is_usable(meta: dict) -> bool:
    license_name = html.unescape(meta.get("LicenseShortName", {}).get("value", ""))
    lower = license_name.lower().replace(" ", "")
    return (
        lower.startswith("cc0")
        or lower.startswith("ccby")
        or lower.startswith("publicdomain")
        or lower.startswith("pd-")
        or lower.startswith("pdm")
    ) and "-nc" not in lower and "-nd" not in lower


def choose_file(filename: str) -> dict | None:
    data = commons(
        titles="File:" + filename,
        prop="imageinfo",
        iiprop="url|size|mime|extmetadata",
        iiurlwidth=960,
    )
    for page in data.get("query", {}).get("pages", []):
        for info in page.get("imageinfo", []):
            if (
                info.get("mime") in ("image/jpeg", "image/png", "image/webp")
                and info.get("width", 0) >= 400
                and info.get("height", 0) >= 300
                and license_is_usable(info.get("extmetadata", {}))
            ):
                return {"title": page["title"], "info": info}
    return None


def search_photo(keywords: str) -> dict | None:
    data = commons(
        generator="search",
        gsrsearch=keywords,
        gsrnamespace=6,
        gsrlimit=35,
        prop="imageinfo",
        iiprop="url|size|mime|extmetadata",
        iiurlwidth=960,
    )
    candidates = []
    for page in data.get("query", {}).get("pages", []):
        for info in page.get("imageinfo", []):
            name = page.get("title", "").lower()
            if (
                info.get("mime") != "image/jpeg"
                or info.get("width", 0) < 500
                or info.get("height", 0) < 350
                or not license_is_usable(info.get("extmetadata", {}))
            ):
                continue
            if any(word in name for word in ("logo", "icon", "illustration", "cartoon", "clipart", "poster", "screenshot")):
                continue
            candidates.append({"title": page["title"], "info": info})
    # Wikimedia devuelve los resultados relevantes antes de los menos apropiados.
    return candidates[0] if candidates else None


def plain_text(value: str) -> str:
    value = re.sub(r"<[^>]+>", " ", value)
    return " ".join(html.unescape(value).split())


def save_image(activity: str, selected: dict) -> str:
    info = selected["info"]
    url = info.get("thumburl") or info["url"]
    image_data = read_url(url)
    if len(image_data) < 4000:
        raise RuntimeError("Archivo demasiado pequeño para {}".format(activity))
    with Image.open(io.BytesIO(image_data)) as opened:
        image = ImageOps.exif_transpose(opened).convert("RGB")
        image.thumbnail((960, 760), Image.Resampling.LANCZOS)
        dest = DEST / (activity + ".webp")
        image.save(dest, "WEBP", quality=83, method=6)
        print("{}: {} ({}x{}, {} KiB)".format(activity, selected["title"], *image.size, dest.stat().st_size // 1024))
    meta = info.get("extmetadata", {})
    license_name = plain_text(meta.get("LicenseShortName", {}).get("value", "Licencia libre"))
    license_url = meta.get("LicenseUrl", {}).get("value", "")
    author = plain_text(meta.get("Artist", {}).get("value", "Autor indicado en Commons"))
    author = author[:350]
    link = info.get("descriptionurl", "https://commons.wikimedia.org/wiki/" + urllib.parse.quote(selected["title"].replace(" ", "_"), safe="():,"))
    return (
        "### {}.webp\n\n"
        "- **Fotografía:** {}\n"
        "- **Autor:** {}\n"
        "- **Licencia:** {} ({})\n"
        "- **Fuente:** {}\n"
        "- **Modificación:** reducida y convertida a WebP para uso sin conexión.\n"
        "- **Nota:** fotografía de referencia, no es una instrucción ni garantía del resultado de la actividad.\n\n"
    ).format(activity, selected["title"], author, license_name, license_url, link)


def main() -> None:
    DEST.mkdir(parents=True, exist_ok=True)
    credits = [
        "# Créditos de fotografías · Aprender\n\n",
        "Fotos libres obtenidas de Wikimedia Commons, utilizadas como "
        "referencias visuales de juegos y actividades por edad. "
        "No son fotos de usuarios de Wawa Kalú.\n\n",
    ]
    problems = []
    for activity, (file_name, query) in PHOTOS.items():
        try:
            chosen = choose_file(file_name) if file_name else None
            if chosen is None:
                print("Buscando alternativa para {}: {}".format(activity, query))
                chosen = search_photo(query)
            if chosen is None:
                chosen = choose_file(FALLBACK[activity])
            if chosen is None:
                raise RuntimeError("No se encontró una fotografía libre adecuada")
            credits.append(save_image(activity, chosen))
        except Exception as exc:
            print("ERROR {}: {}".format(activity, exc))
            problems.append(activity)
    (DEST / "FUENTES_FOTOGRAFIAS.md").write_text("".join(credits), encoding="utf-8")
    if problems:
        raise RuntimeError("No se descargaron: " + ", ".join(problems))
    print("Descargadas {} fotografías para Aprender.".format(len(PHOTOS)))


if __name__ == "__main__":
    main()
