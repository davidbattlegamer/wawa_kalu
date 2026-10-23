import 'dart:ui';

import 'package:flutter/material.dart';

// ============================================================================
// ITEM DE NAVEGACIÓN
// ============================================================================

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

// ============================================================================
// BARRA LIQUID GLASS
// ============================================================================

class LiquidGlassBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<LiquidGlassNavItem> items;
  final bool darkMode;
  // Referencias opcionales para resaltar las pestañas durante el tour.
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
    final Color selectedColor =
        items[selectedIndex].color;

    return SafeArea(
      top: false,

      minimum:
          const EdgeInsets.fromLTRB(
        14,
        0,
        14,
        10,
      ),

      child: Container(
        height: 82,

        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(31),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(
                alpha:
                    darkMode
                        ? 0.35
                        : 0.13,
              ),
              blurRadius: 35,
              spreadRadius: -6,
              offset:
                  const Offset(0, 13),
            ),

            BoxShadow(
              color: selectedColor
                  .withValues(
                alpha:
                    darkMode
                        ? 0.13
                        : 0.09,
              ),
              blurRadius: 34,
              spreadRadius: -8,
              offset:
                  const Offset(0, 4),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(31),

          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 24,
              sigmaY: 24,
            ),

            child: Container(
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius
                        .circular(31),

                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topLeft,
                  end: Alignment
                      .bottomRight,

                  colors: darkMode
                      ? [
                          Colors.white
                              .withValues(
                            alpha:
                                0.145,
                          ),
                          Colors.white
                              .withValues(
                            alpha:
                                0.075,
                          ),
                          Colors.black
                              .withValues(
                            alpha:
                                0.13,
                          ),
                        ]
                      : [
                          Colors.white
                              .withValues(
                            alpha:
                                0.76,
                          ),
                          Colors.white
                              .withValues(
                            alpha:
                                0.45,
                          ),
                          Colors.white
                              .withValues(
                            alpha:
                                0.28,
                          ),
                        ],
                ),

                border:
                    Border.all(
                  color: Colors.white
                      .withValues(
                    alpha:
                        darkMode
                            ? 0.20
                            : 0.76,
                  ),
                  width: 1.15,
                ),
              ),

              child: Stack(
                children: [
                  // REFLEJO SUPERIOR
                  Positioned(
                    top: 1,
                    left: 25,
                    right: 25,

                    child:
                        IgnorePointer(
                      child:
                          Container(
                        height: 1.3,

                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),

                          gradient:
                              LinearGradient(
                            colors: [
                              Colors
                                  .transparent,

                              Colors.white
                                  .withValues(
                                alpha:
                                    darkMode
                                        ? 0.34
                                        : 0.95,
                              ),

                              Colors
                                  .transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // RESPLANDOR SUPERIOR
                  Positioned(
                    top: -28,
                    left: 30,
                    right: 30,

                    child:
                        IgnorePointer(
                      child:
                          Container(
                        height: 50,

                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            50,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .white
                                  .withValues(
                                alpha:
                                    darkMode
                                        ? 0.045
                                        : 0.20,
                              ),
                              blurRadius:
                                  30,
                              spreadRadius:
                                  4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  LayoutBuilder(
                    builder:
                        (
                      context,
                      constraints,
                    ) {
                      final double
                          itemWidth =
                          constraints
                                  .maxWidth /
                              items.length;

                      return Stack(
                        children: [
                          // BURBUJA ANIMADA
                          AnimatedPositioned(
                            duration:
                                const Duration(
                              milliseconds:
                                  430,
                            ),

                            curve: Curves
                                .easeOutCubic,

                            left:
                                selectedIndex *
                                        itemWidth +
                                    5,

                            top: 6,
                            bottom: 6,

                            width:
                                itemWidth -
                                    10,

                            child:
                                _SelectedBubble(
                              color:
                                  selectedColor,
                              dark:
                                  darkMode,
                            ),
                          ),

                          // BOTONES
                          Row(
                            children:
                                List.generate(
                              items.length,
                              (
                                index,
                              ) {
                                return Expanded(
                                  child:
                                      _NavItem(
                                    key: itemKeys == null
                                        ? null
                                        : itemKeys![index],
                                    item:
                                        items[index],
                                    selected:
                                        selectedIndex ==
                                            index,
                                    dark:
                                        darkMode,
                                    onTap:
                                        () {
                                      onSelected(
                                        index,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
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

// ============================================================================
// BURBUJA ACTIVA
// ============================================================================

class _SelectedBubble extends StatelessWidget {
  final Color color;
  final bool dark;

  const _SelectedBubble({
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(25),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Colors.white.withValues(
              alpha:
                  dark ? 0.18 : 0.76,
            ),

            color.withValues(
              alpha:
                  dark ? 0.24 : 0.15,
            ),

            Colors.white.withValues(
              alpha:
                  dark ? 0.055 : 0.30,
            ),
          ],
        ),

        border: Border.all(
          color: Colors.white.withValues(
            alpha:
                dark ? 0.22 : 0.82,
          ),
          width: 1.1,
        ),

        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha:
                  dark ? 0.26 : 0.16,
            ),
            blurRadius: 18,
            spreadRadius: -4,
            offset:
                const Offset(0, 7),
          ),

          BoxShadow(
            color:
                Colors.white.withValues(
              alpha:
                  dark ? 0.055 : 0.48,
            ),
            blurRadius: 5,
            spreadRadius: -1,
            offset:
                const Offset(0, -2),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            top: 3,
            left: 14,
            right: 14,

            child: Container(
              height: 1.4,

              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius
                        .circular(30),

                gradient:
                    LinearGradient(
                  colors: [
                    Colors.transparent,

                    Colors.white
                        .withValues(
                      alpha:
                          dark
                              ? 0.25
                              : 0.90,
                    ),

                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 13,
            left: 4,

            child: Container(
              width: 1.8,
              height: 25,

              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius
                        .circular(20),

                color: Colors.white
                    .withValues(
                  alpha:
                      dark
                          ? 0.10
                          : 0.40,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -8,
            right: -6,

            child: Container(
              width: 30,
              height: 30,

              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: color
                        .withValues(
                      alpha:
                          dark
                              ? 0.11
                              : 0.08,
                    ),
                    blurRadius: 18,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTÓN
// ============================================================================

class _NavItem extends StatelessWidget {
  final LiquidGlassNavItem item;
  final bool selected;
  final bool dark;
  final VoidCallback onTap;

  const _NavItem({
    super.key,
    required this.item,
    required this.selected,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = dark
        ? Colors.white.withValues(
            alpha: 0.63,
          )
        : const Color(0xFF3C3C43)
            .withValues(
            alpha: 0.68,
          );

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        splashColor:
            item.color.withValues(
          alpha: 0.06,
        ),

        highlightColor:
            Colors.transparent,

        child: AnimatedScale(
          duration:
              const Duration(
            milliseconds: 280,
          ),

          curve:
              Curves.easeOutCubic,

          scale:
              selected ? 1.0 : 0.965,

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 300,
                ),

                curve:
                    Curves.easeOutCubic,

                width:
                    selected ? 31 : 28,

                height:
                    selected ? 31 : 28,

                alignment:
                    Alignment.center,

                decoration:
                    BoxDecoration(
                  shape: BoxShape.circle,

                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: item
                                .color
                                .withValues(
                              alpha:
                                  0.25,
                            ),
                            blurRadius:
                                14,
                            spreadRadius:
                                -2,
                          ),
                        ]
                      : null,
                ),

                child:
                    AnimatedSwitcher(
                  duration:
                      const Duration(
                    milliseconds: 220,
                  ),

                  switchInCurve:
                      Curves.easeOutBack,

                  switchOutCurve:
                      Curves.easeIn,

                  transitionBuilder:
                      (
                    child,
                    animation,
                  ) {
                    return ScaleTransition(
                      scale: animation,
                      child:
                          FadeTransition(
                        opacity:
                            animation,
                        child: child,
                      ),
                    );
                  },

                  child: Icon(
                    selected
                        ? item
                            .selectedIcon
                        : item.icon,

                    key: ValueKey<bool>(
                      selected,
                    ),

                    size:
                        selected ? 25 : 23,

                    color: selected
                        ? item.color
                        : inactiveColor,
                  ),
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 2,
                ),

                child:
                    AnimatedDefaultTextStyle(
                  duration:
                      const Duration(
                    milliseconds: 280,
                  ),

                  curve:
                      Curves.easeOutCubic,

                  style: TextStyle(
                    fontFamily:
                        'Fredoka',

                    fontSize:
                        selected
                            ? 11.7
                            : 11,

                    height: 1,

                    fontWeight:
                        selected
                            ? FontWeight
                                .w700
                            : FontWeight
                                .w600,

                    color: selected
                        ? item.color
                        : inactiveColor,
                  ),

                  child: FittedBox(
                    fit:
                        BoxFit.scaleDown,

                    child: Text(
                      item.label,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),

              AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 280,
                ),

                margin:
                    const EdgeInsets
                        .only(
                  top: 3,
                ),

                width:
                    selected ? 4 : 0,

                height:
                    selected ? 4 : 0,

                decoration:
                    BoxDecoration(
                  shape: BoxShape.circle,

                  color: item.color,

                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: item
                                .color
                                .withValues(
                              alpha:
                                  0.55,
                            ),
                            blurRadius:
                                7,
                            spreadRadius:
                                1,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}