"""Genera el icono Android sin el marco blanco del icono adaptable.

El logo de otros sistemas no se modifica. Se parte de la imagen de 1024 px
ya presente en el repositorio, sin depender de recursos en Internet.
Ejecutar: python tools/generate_android_icon.py
Requiere Pillow.
"""
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
IMAGES = ROOT / "assets" / "images"
SOURCE = IMAGES / "WawaKalu_icono.png"
BACKGROUND = IMAGES / "WawaKalu_android_sin_borde.png"
FOREGROUND = IMAGES / "WawaKalu_android_foreground_transparente.png"

SIZE = 1024


def gradient() -> Image.Image:
    """Gradiente opaco que llena todo el recorte del launcher."""
    top_left = (147, 39, 220)
    top_right = (3, 150, 240)
    bottom_left = (85, 22, 188)
    bottom_right = (15, 38, 188)

    def line(left, right):
        return Image.frombytes(
            "RGB",
            (SIZE, 1),
            bytes(
                value
                for x in range(SIZE)
                for value in (
                    round(left[channel] * (1 - x / (SIZE - 1))
                          + right[channel] * x / (SIZE - 1))
                    for channel in range(3)
                )
            ),
        )

    top = line(top_left, top_right)
    bottom = line(bottom_left, bottom_right)
    background = Image.new("RGB", (SIZE, SIZE))
    for y in range(SIZE):
        background.paste(Image.blend(top, bottom, y / (SIZE - 1)), (0, y))
    return background.convert("RGBA")


def main() -> None:
    source = Image.open(SOURCE).convert("RGBA")
    if source.width != source.height:
        raise ValueError(f"El icono original debe ser cuadrado: {source.size}")

    background = gradient()
    # Conservar el arte original y ampliar ligeramente para retirar
    # el margen transparente. El gradiente completa TODAS las esquinas,
    # evitando el borde blanco al aplicar la máscara del launcher.
    side = 1108
    artwork = source.resize((side, side), Image.Resampling.LANCZOS)
    layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    layer.paste(artwork, ((SIZE - side) // 2, (SIZE - side) // 2))
    background.alpha_composite(layer)
    background.convert("RGB").save(BACKGROUND, format="PNG", optimize=True)

    # En iconos adaptables Android usa el dibujo completo como fondo,
    # mientras el foreground queda vacío: no hay icono duplicado,
    # recuadro adicional, ni inset blanco alrededor de los búhos.
    Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0)).save(
        FOREGROUND, format="PNG", optimize=True
    )
    print(f"Icono Android sin blanco: {BACKGROUND}")
    print(f"Foreground transparente: {FOREGROUND}")


if __name__ == "__main__":
    main()
