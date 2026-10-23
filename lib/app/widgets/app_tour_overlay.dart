import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../pages/app_texts.dart';

/// Recorrido superpuesto al contenido real, sin navegar ni alterar
/// información personal. Todos los controles inferiores quedan protegidos
/// durante el tour; solo funcionan Atrás, Siguiente y Omitir.
class AppTourOverlay extends StatelessWidget {
  const AppTourOverlay({
    super.key,
    required this.step,
    required this.focusRect,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  static const int stepCount = 5;

  final int step;
  final Rect? focusRect;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  static const List<_TourSlide> _slides = [
    _TourSlide(
      titleKey: 'tourWelcomeTitle',
      descriptionKey: 'tourWelcomeDescription',
      icon: Icons.waving_hand_rounded,
      accent: Color(0xFF8B5CF6),
    ),
    _TourSlide(
      titleKey: 'tourChildrenTitle',
      descriptionKey: 'tourChildrenDescription',
      icon: Icons.child_care_rounded,
      accent: Color(0xFF6E56C6),
    ),
    _TourSlide(
      titleKey: 'tourHealthTitle',
      descriptionKey: 'tourHealthDescription',
      icon: Icons.favorite_rounded,
      accent: Color(0xFFEF476F),
    ),
    _TourSlide(
      titleKey: 'tourLearningTitle',
      descriptionKey: 'tourLearningDescription',
      icon: Icons.auto_stories_rounded,
      accent: Color(0xFFFF9F1C),
    ),
    _TourSlide(
      titleKey: 'tourSettingsTitle',
      descriptionKey: 'tourSettingsDescription',
      icon: Icons.settings_rounded,
      accent: Color(0xFF4D8DFF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final slide = _slides[step];
    final media = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, limits) {
        final double height = limits.maxHeight;
        final double width = limits.maxWidth;
        final double available = math.max(
          170,
          height - media.padding.top - media.padding.bottom - 28,
        );
        final double panelMaxHeight = math.min(290, available);
        final double estimate = math.min(264, panelMaxHeight);

        // La tarjeta aparece encima de la barra inferior para los pasos
        // de secciones, y debajo del engranaje para el último paso.
        final double panelTop;
        if (step == 0 || focusRect == null) {
          panelTop = (height - estimate) / 2;
        } else if (step == stepCount - 1) {
          panelTop = math.min(
            height - media.padding.bottom - estimate - 14,
            focusRect!.bottom + 16,
          );
        } else {
          panelTop = math.max(
            media.padding.top + 12,
            focusRect!.top - estimate - 20,
          );
        }

        final top = panelTop.clamp(
          media.padding.top + 8,
          math.max(
            media.padding.top + 8,
            height - media.padding.bottom - estimate - 8,
          ),
        );

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {}, // Impide activar accidentalmente otros botones.
                child: CustomPaint(
                  painter: _TourScrimPainter(
                    focusRect: step == 0 ? null : focusRect,
                    color: Colors.black.withValues(alpha: dark ? 0.76 : 0.63),
                    accent: slide.accent,
                  ),
                ),
              ),
            ),
            Positioned(
              top: top,
              left: 16,
              right: 16,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: math.min(width - 32, 450),
                    maxHeight: panelMaxHeight,
                  ),
                  child: _TourPanel(
                    key: ValueKey(step),
                    slide: slide,
                    step: step,
                    dark: dark,
                    onBack: onBack,
                    onNext: onNext,
                    onSkip: onSkip,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TourSlide {
  const _TourSlide({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.accent,
  });

  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final Color accent;
}

class _TourPanel extends StatelessWidget {
  const _TourPanel({
    super.key,
    required this.slide,
    required this.step,
    required this.dark,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  final _TourSlide slide;
  final int step;
  final bool dark;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final Color ink = dark ? Colors.white : const Color(0xFF2F2540);
    final Color muted =
        dark ? Colors.white70 : const Color(0xFF746B81);
    final Color tint = slide.accent;
    final String counter = T.txt('tourStepOf')
        .replaceAll('{step}', '${step + 1}')
        .replaceAll('{total}', '${AppTourOverlay.stepCount}');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [
                  const Color(0xFF30263D),
                  Color.lerp(const Color(0xFF282132), tint, 0.16)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(Colors.white, tint, 0.13)!,
                ],
        ),
        border: Border.all(
          color: dark
              ? tint.withValues(alpha: 0.45)
              : tint.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(19, 17, 19, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: dark ? 0.25 : 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(slide.icon, color: tint, size: 24),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    counter,
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      color: muted,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    T.txt('tourSkip'),
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      color: muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              T.txt(slide.titleKey),
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w800,
                height: 1.1,
                fontSize: 22,
                color: ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              T.txt(slide.descriptionKey),
              style: TextStyle(
                fontFamily: 'Baloo2',
                height: 1.3,
                fontSize: 14,
                color: muted,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (int i = 0; i < AppTourOverlay.stepCount; i++) ...[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: step == i ? 25 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: step == i
                          ? tint
                          : tint.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  if (i != AppTourOverlay.stepCount - 1)
                    const SizedBox(width: 5),
                ],
                const Spacer(),
                if (step > 0)
                  TextButton(
                    onPressed: onBack,
                    child: Text(
                      T.txt('tourBack'),
                      style: TextStyle(
                        color: ink,
                        fontFamily: 'Baloo2',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                const SizedBox(width: 5),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: tint,
                    foregroundColor: slide.accent ==
                            const Color(0xFFFF9F1C)
                        ? const Color(0xFF332002)
                        : Colors.white,
                    minimumSize: const Size(92, 43),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onNext,
                  child: Text(
                    T.txt(step == AppTourOverlay.stepCount - 1
                        ? 'tourFinish'
                        : 'tourNext'),
                    style: const TextStyle(
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TourScrimPainter extends CustomPainter {
  const _TourScrimPainter({
    required this.focusRect,
    required this.color,
    required this.accent,
  });

  final Rect? focusRect;
  final Color color;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect total = Offset.zero & size;
    if (focusRect == null) {
      canvas.drawRect(total, Paint()..color = color);
      return;
    }

    final Rect hole = focusRect!.inflate(6).intersect(total);
    if (hole.isEmpty) {
      canvas.drawRect(total, Paint()..color = color);
      return;
    }

    final round = RRect.fromRectAndRadius(
      hole,
      const Radius.circular(20),
    );
    final Path mask = Path.combine(
      PathOperation.difference,
      Path()..addRect(total),
      Path()..addRRect(round),
    );
    canvas.drawPath(mask, Paint()..color = color);
    canvas.drawRRect(
      round,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );
  }

  @override
  bool shouldRepaint(covariant _TourScrimPainter oldDelegate) {
    return oldDelegate.focusRect != focusRect ||
        oldDelegate.color != color ||
        oldDelegate.accent != accent;
  }
}
