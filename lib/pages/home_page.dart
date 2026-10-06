import 'package:flutter/material.dart';

import 'app_config.dart';
import 'app_texts.dart';
import 'widgets/config_sheet.dart';
import '../features/growth/pages/growth_page.dart';
import '../features/vaccines/pages/vaccines_page.dart';
import '../features/children/data/child_repository.dart';
import '../features/children/models/child.dart';
import '../features/children/pages/child_form_page.dart';
import '../features/children/pages/child_profile_page.dart';
import '../features/children/utils/child_display_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _addChild(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChildFormPage()),
    );
  }

  Future<void> _openProfile(BuildContext context, Child child) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChildProfilePage(childId: child.id)),
    );
  }

  Future<void> _showChildSelector(BuildContext context) async {
    final List<Child> children = ChildRepository.instance.children.value;

    if (children.isEmpty) {
      await _addChild(context);
      return;
    }

    final bool dark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF15131A) : const Color(0xFFFAF7F2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: dark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        T.txt('selectChild'),
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: dark ? Colors.white : const Color(0xFF2D2D2D),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: T.txt('addChild'),
                      onPressed: () async {
                        Navigator.pop(sheetContext);

                        await _addChild(context);
                      },
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String?>(
                  valueListenable: ChildRepository.instance.selectedChildId,
                  builder: (context, selectedId, _) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: children.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final child = children[index];

                        final bool selected = child.id == selectedId;

                        final Color childColor = child.sex == ChildSex.girl
                            ? Colors.pink
                            : Colors.blue;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              await ChildRepository.instance.selectChild(
                                child.id,
                              );

                              if (!sheetContext.mounted) {
                                return;
                              }

                              Navigator.pop(sheetContext);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: selected
                                    ? childColor.withValues(
                                        alpha: dark ? 0.18 : 0.10,
                                      )
                                    : dark
                                    ? const Color(0xFF211B2E)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? childColor
                                      : childColor.withValues(alpha: 0.14),
                                  width: selected ? 1.8 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: childColor.withValues(alpha: 0.14),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      child.sex == ChildSex.girl
                                          ? Icons.face_3_rounded
                                          : Icons.face_6_rounded,
                                      color: childColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child.name,
                                          style: TextStyle(
                                            fontFamily: 'Fredoka',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: dark
                                                ? Colors.white
                                                : const Color(0xFF2D2D2D),
                                          ),
                                        ),
                                        Text(
                                          childAgeText(child.birthDate),
                                          style: TextStyle(
                                            fontFamily: 'Baloo2',
                                            fontSize: 14,
                                            color: dark
                                                ? Colors.white60
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF00A896),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idiomaActual, _) {
        final bool dark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: dark
              ? const Color(0xFF15131A)
              : const Color(0xFFFAF7F2),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: dark ? const Color(0xFF211B2E) : Colors.white,
            title: Text(
              T.txt('appName'),
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: dark ? Colors.white : const Color(0xFF4A2C82),
              ),
            ),
            actions: [
              IconButton(
                tooltip: T.txt('settingsTitle'),
                onPressed: () {
                  showConfigSheet(context);
                },
                icon: const Icon(Icons.settings_rounded),
              ),
            ],
          ),
          body: ValueListenableBuilder<List<Child>>(
            valueListenable: ChildRepository.instance.children,
            builder: (context, children, _) {
              if (children.isEmpty) {
                return _EmptyHome(
                  dark: dark,
                  onAdd: () {
                    _addChild(context);
                  },
                );
              }

              return ValueListenableBuilder<String?>(
                valueListenable: ChildRepository.instance.selectedChildId,
                builder: (context, selectedId, _) {
                  Child? child;

                  if (selectedId != null) {
                    child = ChildRepository.instance.findById(selectedId);
                  }

                  child ??= children.first;

                  return _Dashboard(
                    child: child,
                    dark: dark,
                    onChangeChild: () {
                      _showChildSelector(context);
                    },
                    onOpenProfile: () {
                      _openProfile(context, child!);
                    },
                    onVaccines: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VaccinesPage()),
                      );
                    },
                    onGrowth: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GrowthPage()),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _Dashboard extends StatelessWidget {
  final Child child;
  final bool dark;

  final VoidCallback onChangeChild;
  final VoidCallback onOpenProfile;
  final VoidCallback onVaccines;
  final VoidCallback onGrowth;

  const _Dashboard({
    required this.child,
    required this.dark,
    required this.onChangeChild,
    required this.onOpenProfile,
    required this.onVaccines,
    required this.onGrowth,
  });

  @override
  Widget build(BuildContext context) {
    final Color childColor = child.sex == ChildSex.girl
        ? Colors.pink
        : Colors.blue;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              T.txt('homeGreeting'),
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: dark ? Colors.white : const Color(0xFF2D2D2D),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              T.txt('homeGreetingSubtitle'),
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 16,
                color: dark ? Colors.white60 : Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(26),
              child: InkWell(
                onTap: onChangeChild,
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        dark ? const Color(0xFF211B2E) : Colors.white,
                        childColor.withValues(alpha: dark ? 0.18 : 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: childColor.withValues(alpha: 0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: childColor.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: childColor.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          child.sex == ChildSex.girl
                              ? Icons.face_3_rounded
                              : Icons.face_6_rounded,
                          color: childColor,
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                                color: dark
                                    ? Colors.white
                                    : const Color(0xFF2D2D2D),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              childAgeText(child.birthDate),
                              style: TextStyle(
                                fontFamily: 'Baloo2',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: dark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              T.txt('tapToChangeChild'),
                              style: const TextStyle(
                                fontFamily: 'Baloo2',
                                fontSize: 12.5,
                                color: Color(0xFF7B2CBF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF7B2CBF),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onOpenProfile,
                icon: const Icon(Icons.person_outline_rounded),
                label: Text(T.txt('viewProfile')),
              ),
            ),

            const SizedBox(height: 12),

            _SectionTitle(title: T.txt('healthSummary'), dark: dark),

            const SizedBox(height: 12),

            _DashboardHealthCard(
              icon: Icons.vaccines_rounded,
              color: Colors.blue,
              title: T.txt('nextVaccine'),
              subtitle: T.txt('vaccineDataPending'),
              actionText: T.txt('viewVaccines'),
              dark: dark,
              onTap: onVaccines,
            ),

            const SizedBox(height: 14),

            _DashboardHealthCard(
              icon: Icons.show_chart_rounded,
              color: const Color(0xFF00A896),
              title: T.txt('lastGrowthCheck'),
              subtitle: T.txt('growthDataPending'),
              actionText: T.txt('viewGrowth'),
              dark: dark,
              onTap: onGrowth,
            ),

            const SizedBox(height: 24),

            _SectionTitle(title: T.txt('quickSummary'), dark: dark),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _SmallInfoCard(
                    icon: Icons.cake_rounded,
                    title: T.txt('birthDate'),
                    value: simpleDateText(child.birthDate),
                    color: Colors.orange,
                    dark: dark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SmallInfoCard(
                    icon: Icons.child_care_rounded,
                    title: T.txt('sex'),
                    value: child.sex == ChildSex.girl
                        ? T.txt('girl')
                        : T.txt('boy'),
                    color: childColor,
                    dark: dark,
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

class _EmptyHome extends StatelessWidget {
  final bool dark;
  final VoidCallback onAdd;

  const _EmptyHome({required this.dark, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7B2CBF).withValues(alpha: 0.20),
                      const Color(0xFFFF006E).withValues(alpha: 0.10),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.family_restroom_rounded,
                  size: 65,
                  color: Color(0xFF7B2CBF),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                T.txt('homeNoChildTitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: dark ? Colors.white : const Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                T.txt('homeNoChildSubtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 16,
                  height: 1.3,
                  color: dark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF7B2CBF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    T.txt('addFirstChild'),
                    style: const TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool dark;

  const _SectionTitle({required this.title, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Fredoka',
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: dark ? Colors.white : const Color(0xFF4A2C82),
      ),
    );
  }
}

class _DashboardHealthCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String actionText;
  final bool dark;
  final VoidCallback onTap;

  const _DashboardHealthCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                dark ? const Color(0xFF211B2E) : Colors.white,
                color.withValues(alpha: dark ? 0.16 : 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 31),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Colors.white : const Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 14,
                        height: 1.2,
                        color: dark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      actionText,
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool dark;

  const _SmallInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF211B2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 13,
              color: dark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: dark ? Colors.white : const Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }
}
