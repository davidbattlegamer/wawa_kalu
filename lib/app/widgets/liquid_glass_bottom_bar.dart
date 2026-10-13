import 'dart:ui';

import 'package:flutter/material.dart';

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

  const LiquidGlassBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.items,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color glassBase = darkMode
        ? const Color(0xFF201A2A).withValues(alpha: 0.74)
        : Colors.white.withValues(alpha: 0.72);

    final Color borderColor = darkMode
        ? Colors.white.withValues(alpha: 0.13)
        : Colors.white.withValues(alpha: 0.82);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: glassBase,
              border: Border.all(
                color: borderColor,
                width: 1.15,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: darkMode ? 0.30 : 0.10,
                  ),
                  blurRadius: 28,
                  spreadRadius: -8,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.white.withValues(
                    alpha: darkMode ? 0.04 : 0.55,
                  ),
                  blurRadius: 10,
                  spreadRadius: -6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 18,
                  right: 18,
                  top: 0,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(
                            alpha: darkMode ? 0.12 : 0.70,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(
                    items.length,
                    (index) {
                      final item = items[index];
                      final bool selected =
                          index == selectedIndex;

                      return Expanded(
                        child: _LiquidGlassNavButton(
                          item: item,
                          selected: selected,
                          darkMode: darkMode,
                          onTap: () => onSelected(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassNavButton extends StatelessWidget {
  final LiquidGlassNavItem item;
  final bool selected;
  final bool darkMode;
  final VoidCallback onTap;

  const _LiquidGlassNavButton({
    required this.item,
    required this.selected,
    required this.darkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = darkMode
        ? Colors.white.withValues(alpha: 0.63)
        : const Color(0xFF6E6878);

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: item.color.withValues(alpha: 0.10),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 8,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: selected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          item.color.withValues(
                            alpha: darkMode ? 0.28 : 0.17,
                          ),
                          Colors.white.withValues(
                            alpha: darkMode ? 0.07 : 0.56,
                          ),
                        ],
                      )
                    : null,
                border: selected
                    ? Border.all(
                        color: Colors.white.withValues(
                          alpha: darkMode ? 0.10 : 0.62,
                        ),
                        width: 1,
                      )
                    : null,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: item.color.withValues(
                            alpha: darkMode ? 0.18 : 0.16,
                          ),
                          blurRadius: 18,
                          spreadRadius: -5,
                          offset: const Offset(0, 7),
                        ),
                      ]
                    : const [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    scale: selected ? 1.12 : 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? item.color.withValues(
                                alpha: darkMode ? 0.20 : 0.12,
                              )
                            : Colors.transparent,
                      ),
                      child: Icon(
                        selected
                            ? item.selectedIcon
                            : item.icon,
                        size: 22,
                        color: selected
                            ? item.color
                            : inactiveColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: selected ? 11.6 : 11.1,
                      height: 1,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: selected
                          ? item.color
                          : inactiveColor,
                    ),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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
