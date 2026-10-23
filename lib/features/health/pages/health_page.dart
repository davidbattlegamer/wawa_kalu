import 'package:flutter/material.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';
import '../../../app/widgets/family_content_ui.dart';
import '../../../app/widgets/tour_targets.dart';
import '../../../pages/nutricion_page.dart';

import '../../children/data/child_repository.dart';
import '../../children/models/child.dart';
import '../../children/pages/child_form_page.dart';
import '../../children/utils/child_display_utils.dart';
import '../../children/widgets/child_avatar.dart';

import '../../growth/pages/growth_page.dart';
import '../../vaccines/pages/vaccines_page.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  Future<void> _openPage(BuildContext context, Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _addChild(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChildFormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idioma, _) {
        final bool dark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: dark
              ? const Color(0xFF15131A)
              : const Color(0xFFFAF7F2),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: dark ? const Color(0xFF211B2E) : Colors.white,
            foregroundColor: dark ? Colors.white : const Color(0xFF2D2D2D),
            title: Text(
              T.txt('health'),
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 31,
                fontWeight: FontWeight.w900,
                height: 1,
                color: dark ? Colors.white : const Color(0xFF4A2C82),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FamilyHero(
                    eyebrow: T.txt('health'),
                    title: T.txt('healthHeaderTitle'),
                    subtitle: T.txt('healthHeaderSubtitle'),
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFFEC5F7A),
                    accent: const Color(0xFFF59E83),
                  ),

                  const SizedBox(height: 23),

                  _SelectedChildCard(
                    onAdd: () {
                      _addChild(context);
                    },
                  ),

                  const SizedBox(height: 25),

                  FamilySectionHeading(
                    title: T.txt('healthTrackingTitle'),
                    subtitle: T.txt('healthTrackingSubtitle'),
                    icon: Icons.monitor_heart_rounded,
                  ),

                  KeyedSubtree(
                    key: TourTargets.vaccinesCard,
                    child: HealthOptionCard(
                      icon: Icons.vaccines_rounded,
                    title: T.txt('vaccines'),
                    subtitle: T.txt('vaccinesSubtitle'),
                    color: const Color(0xFF06A6A6),
                    onTap: () {
                      _openPage(context, const VaccinesPage());
                    },
                    ),
                  ),

                  const SizedBox(height: 14),

                  KeyedSubtree(
                    key: TourTargets.growthCard,
                    child: HealthOptionCard(
                      icon: Icons.show_chart_rounded,
                    title: T.txt('growth'),
                    subtitle: T.txt('growthSubtitle'),
                    color: const Color(0xFF00A896),
                    onTap: () {
                      _openPage(context, const GrowthPage());
                    },
                    ),
                  ),

                  const SizedBox(height: 25),

                  FamilySectionHeading(
                    title: T.txt('healthGuidanceTitle'),
                    subtitle: T.txt('healthGuidanceSubtitle'),
                    icon: Icons.spa_rounded,
                  ),

                  KeyedSubtree(
                    key: TourTargets.nutritionCard,
                    child: HealthOptionCard(
                      icon: Icons.restaurant_menu_rounded,
                    title: T.txt('nutrition'),
                    subtitle: T.txt('healthNutritionIntegratedSubtitle'),
                    color: const Color(0xFFF59E55),
                    onTap: () {
                      _openPage(context, const NutricionPage());
                    },
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectedChildCard extends StatelessWidget {
  const _SelectedChildCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<Child>>(
      valueListenable: ChildRepository.instance.children,
      builder: (context, children, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: ChildRepository.instance.selectedChildId,
          builder: (context, selectedId, _) {
            Child? child;

            if (selectedId != null) {
              child = ChildRepository.instance.findById(selectedId);
            }

            if (child == null) {
              const Color accent = Color(0xFF7B61C9);

              return Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      dark ? const Color(0xFF211D2B) : Colors.white,
                      accent.withValues(alpha: dark ? 0.20 : 0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(27),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.28),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: dark ? 0.06 : 0.11),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -42,
                      right: -24,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(19),
                      child: Row(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  accent.withValues(alpha: 0.24),
                                  accent.withValues(alpha: 0.10),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: const Icon(
                              Icons.child_care_rounded,
                              color: accent,
                              size: 33,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  T.txt('healthNoChild'),
                                  style: TextStyle(
                                    fontFamily: 'Fredoka',
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w800,
                                    color: dark
                                        ? Colors.white
                                        : const Color(0xFF302942),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FilledButton.icon(
                                  onPressed: onAdd,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: accent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add_rounded, size: 19),
                                  label: Text(
                                    T.txt('addChild'),
                                    style: const TextStyle(
                                      fontFamily: 'Fredoka',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            final Color color = child.sex == ChildSex.girl
                ? const Color(0xFFE85D9C)
                : const Color(0xFF4F7CFF);

            return Semantics(
              label:
                  '${T.txt('activeChild')}. ${child.name}. ${childAgeText(child.birthDate)}.',
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      dark ? const Color(0xFF211D2B) : Colors.white,
                      color.withValues(alpha: dark ? 0.22 : 0.11),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(27),
                  border: Border.all(
                    color: color.withValues(alpha: 0.30),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: dark ? 0.06 : 0.12),
                      blurRadius: 19,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -44,
                      right: -28,
                      child: Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.065),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 18,
                      bottom: 18,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.82),
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(19, 18, 17, 18),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  color.withValues(alpha: 0.30),
                                  color.withValues(alpha: 0.10),
                                ],
                              ),
                              border: Border.all(
                                color: color.withValues(alpha: 0.28),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ChildAvatar(child: child, size: 60),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00A896)
                                        .withValues(alpha: dark ? 0.18 : 0.10),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF00A896),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        T.txt('activeChild'),
                                        style: const TextStyle(
                                          fontFamily: 'Baloo2',
                                          fontSize: 11.5,
                                          height: 1,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF00A896),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  child.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Fredoka',
                                    fontSize: 20,
                                    height: 1.05,
                                    fontWeight: FontWeight.w800,
                                    color: dark
                                        ? Colors.white
                                        : const Color(0xFF302942),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.cake_outlined,
                                      color: color,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        childAgeText(child.birthDate),
                                        style: TextStyle(
                                          fontFamily: 'Baloo2',
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600,
                                          color: dark
                                              ? Colors.white70
                                              : const Color(0xFF6C6476),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.favorite_rounded,
                            color: color,
                            size: 27,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// The same navigation tile style is used across Aprender and Salud.
class HealthOptionCard extends StatelessWidget {
  const HealthOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => FamilyTopicCard(
    title: title,
    subtitle: subtitle,
    icon: icon,
    color: color,
    onTap: onTap,
  );
}
