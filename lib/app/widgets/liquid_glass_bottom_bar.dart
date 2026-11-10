import 'package:flutter/material.dart';

// Barra inferior de Wawa Kalú. Mantiene la API pública y las claves
// utilizadas por los recorridos guiados, pero reproduce el diseño de
// referencia: cápsula blanca, cuatro accesos morados y pestaña activa
// dentro de una cápsula pastel con punto inferior.
class LiquidGlassNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Color color;

  const LiquidGlassNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.color,
  });
}

class LiquidGlassBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<LiquidGlassNavItem> items;
  final bool darkMode;

  /// Se conservan los GlobalKeys del tour de bienvenida.
  final List<GlobalKey>? itemKeys;

  const LiquidGlassBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.items,
    required this.darkMode,
    this.itemKeys,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = items[selectedIndex].color;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: darkMode ? const Color(0xFF261D37) : const Color(0xFFFCFAFF),
          borderRadius: BorderRadius.circular(43),
          border: Border.all(
            color: darkMode
                ? const Color(0xFF625079)
                : const Color(0xFFE9DFF1),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B4C8D)
                  .withValues(alpha: darkMode ? 0.27 : 0.18),
              blurRadius: 28,
              spreadRadius: -5,
              offset: const Offset(0, 9),
            ),
            BoxShadow(
              color: activeColor.withValues(alpha: 0.07),
              blurRadius: 24,
              spreadRadius: -8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(43),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = constraints.maxWidth / items.length;
              final bool compact = itemWidth < 87;

              return Row(
                children: List.generate(items.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 5,
                      ),
                      child: _NavItem(
                        key: itemKeys != null && index < itemKeys!.length
                            ? itemKeys![index]
                            : null,
                        item: items[index],
                        selected: index == selectedIndex,
                        dark: darkMode,
                        compact: compact,
                        onTap: () => onSelected(index),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.item,
    required this.selected,
    required this.dark,
    required this.compact,
    required this.onTap,
  });

  final LiquidGlassNavItem item;
  final bool selected;
  final bool dark;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Morado uniforme para las pestañas inactivas, como la referencia.
    const Color purpleInk = Color(0xFF50386F);
    final Color ink = selected
        ? item.color
        : dark
            ? const Color(0xFFEDE3F8)
            : purpleInk;

    final Color start = dark
        ? Color.lerp(const Color(0xFF2F2544), item.color, 0.16)!
        : Color.lerp(Colors.white, item.color, 0.085)!;
    final Color end = dark
        ? Color.lerp(const Color(0xFF342846), item.color, 0.28)!
        : Color.lerp(Colors.white, item.color, 0.19)!;

    final double iconSize = compact ? 26 : 31;
    final double textSize = compact ? 12.1 : 15.1;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(37),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(37),
          splashColor: item.color.withValues(alpha: 0.10),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 290),
            curve: Curves.easeOutCubic,
            height: 88,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [start, end],
                    )
                  : null,
              borderRadius: BorderRadius.circular(37),
              border: selected
                  ? Border.all(
                      color: item.color.withValues(
                        alpha: dark ? 0.40 : 0.26,
                      ),
                      width: 1,
                    )
                  : null,
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: item.color.withValues(alpha: dark ? 0.13 : 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    selected ? item.selectedIcon : item.icon,
                    size: iconSize,
                    color: ink,
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.label,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w700,
                          fontSize: textSize,
                          height: 1.12,
                          color: ink,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: selected ? 1 : 0,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: item.color.withValues(alpha: 0.33),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
