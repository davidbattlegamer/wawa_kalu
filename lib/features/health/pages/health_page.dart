import 'package:flutter/material.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';
import '../../../app/widgets/family_content_ui.dart';
import '../../../pages/nutricion_page.dart';
import '../../../pages/recetas_page.dart';

import '../../children/data/child_repository.dart';
import '../../children/models/child.dart';
import '../../children/pages/child_form_page.dart';
import '../../children/utils/child_display_utils.dart';

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
                    color: const Color(0xFFBE567C),
                    accent: const Color(0xFFEF9A72),
                  ),

                  const SizedBox(height: 23),

                  _SelectedChildCard(
                    dark: dark,
                    onAdd: () {
                      _addChild(context);
                    },
                  ),

                  const SizedBox(height: 25),

                  Text(
                    T.txt('healthTrackingTitle'),
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: dark ? Colors.white : const Color(0xFF2D2D2D),
                    ),
                  ),

                  const SizedBox(height: 12),

                  HealthOptionCard(
                    icon: Icons.vaccines_rounded,
                    title: T.txt('vaccines'),
                    subtitle: T.txt('vaccinesSubtitle'),
                    color: Colors.blue,
                    dark: dark,
                    onTap: () {
                      _openPage(context, const VaccinesPage());
                    },
                  ),

                  const SizedBox(height: 14),

                  HealthOptionCard(
                    icon: Icons.show_chart_rounded,
                    title: T.txt('growth'),
                    subtitle: T.txt('growthSubtitle'),
                    color: const Color(0xFF00A896),
                    dark: dark,
                    onTap: () {
                      _openPage(context, const GrowthPage());
                    },
                  ),

                  const SizedBox(height: 25),

                  Text(
                    T.txt('healthGuidanceTitle'),
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: dark ? Colors.white : const Color(0xFF2D2D2D),
                    ),
                  ),

                  const SizedBox(height: 12),

                  HealthOptionCard(
                    icon: Icons.restaurant_menu_rounded,
                    title: T.txt('nutrition'),
                    subtitle: T.txt('healthNutritionSubtitle'),
                    color: const Color(0xFF269B90),
                    dark: dark,
                    onTap: () {
                      _openPage(context, const NutricionPage());
                    },
                  ),

                  const SizedBox(height: 14),

                  HealthOptionCard(
                    icon: Icons.menu_book_rounded,
                    title: T.txt('recipes'),
                    subtitle: T.txt('healthRecipesSubtitle'),
                    color: const Color(0xFFDB7A45),
                    dark: dark,
                    onTap: () {
                      _openPage(context, const RecetasPage());
                    },
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
  final bool dark;
  final VoidCallback onAdd;

  const _SelectedChildCard({required this.dark, required this.onAdd});

  @override
  Widget build(BuildContext context) {
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
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF211B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF7B2CBF).withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.child_care_rounded,
                      color: Color(0xFF7B2CBF),
                      size: 39,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      T.txt('healthNoChild'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: dark ? Colors.white : const Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(T.txt('addChild')),
                    ),
                  ],
                ),
              );
            }

            final Color color = child.sex == ChildSex.girl
                ? Colors.pink
                : Colors.blue;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dark ? const Color(0xFF211B2E) : Colors.white,
                    color.withValues(alpha: dark ? 0.16 : 0.07),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.14),
                    ),
                    child: Icon(
                      child.sex == ChildSex.girl
                          ? Icons.face_3_rounded
                          : Icons.face_6_rounded,
                      color: color,
                      size: 31,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          T
                              .txt('healthOfChild')
                              .replaceAll('{name}', child.name),
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: dark
                                ? Colors.white
                                : const Color(0xFF2D2D2D),
                          ),
                        ),
                        Text(
                          childAgeText(child.birthDate),
                          style: TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 14.5,
                            color: dark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.favorite_rounded, color: Color(0xFFEF476F)),
                ],
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
    required this.dark,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool dark;
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
