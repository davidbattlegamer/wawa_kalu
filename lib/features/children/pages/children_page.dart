import 'package:flutter/material.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';
import '../../../app/widgets/family_content_ui.dart';

import '../data/child_repository.dart';
import '../models/child.dart';
import '../utils/child_display_utils.dart';
import '../widgets/child_avatar.dart';

import 'child_form_page.dart';
import 'child_profile_page.dart';

class ChildrenPage extends StatelessWidget {
  const ChildrenPage({super.key});

  Future<void> _addChild(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChildFormPage()),
    );
  }

  Future<void> _openChild(BuildContext context, Child child) async {
    await ChildRepository.instance.selectChild(child.id);

    if (!context.mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChildProfilePage(childId: child.id)),
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
            backgroundColor: dark ? const Color(0xFF211B2E) : Colors.white,
            foregroundColor: dark ? Colors.white : const Color(0xFF2D2D2D),
            elevation: 0,
            title: Text(
              T.txt('myChildren'),
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 31,
                fontWeight: FontWeight.w900,
                height: 1,
                color: dark ? Colors.white : const Color(0xFF4A2C82),
              ),
            ),
            actions: [
              IconButton(
                tooltip: T.txt('addChild'),
                onPressed: () {
                  _addChild(context);
                },
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: ValueListenableBuilder<List<Child>>(
              valueListenable: ChildRepository.instance.children,
              builder: (context, children, _) {
                if (children.isEmpty) {
                  return _EmptyChildren(
                    dark: dark,
                    onAdd: () {
                      _addChild(context);
                    },
                  );
                }

                return ValueListenableBuilder<String?>(
                  valueListenable: ChildRepository.instance.selectedChildId,
                  builder: (context, selectedId, _) {
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                      children: [
                        FamilyHero(
                          eyebrow: T.txt('myChildren'),
                          title: T.txt('childrenHubTitle'),
                          subtitle: T.txt('childrenHubSubtitle'),
                          icon: Icons.family_restroom_rounded,
                          color: const Color(0xFF7B61C9),
                          accent: const Color(0xFFDF7E9F),
                        ),
                        const SizedBox(height: 26),
                        FamilySectionHeading(
                          title: T.txt('childrenProfilesTitle'),
                          subtitle: T.txt('childrenProfilesSubtitle'),
                          icon: Icons.people_alt_rounded,
                        ),
                        ...children.map((child) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: _ChildCard(
                              child: child,
                              selected: child.id == selectedId,
                              onTap: () {
                                _openChild(context, child);
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        FamilyNotice(
                          text: T.txt('childrenContextNotice'),
                          color: const Color(0xFF7B61C9),
                          icon: Icons.auto_awesome_rounded,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _EmptyChildren extends StatelessWidget {
  final bool dark;
  final VoidCallback onAdd;

  const _EmptyChildren({required this.dark, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7B2CBF).withValues(alpha: 0.22),
                    const Color(0xFFFF006E).withValues(alpha: 0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.child_care_rounded,
                size: 58,
                color: Color(0xFF7B2CBF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              T.txt('noChildrenRegistered'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: dark ? Colors.white : const Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              T.txt('childrenEmptyDescription'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 16,
                height: 1.3,
                fontWeight: FontWeight.w500,
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
                  T.txt('addChild'),
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
    );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final Child child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color childColor =
        child.sex == ChildSex.girl ? const Color(0xFFE85D9C) : const Color(0xFF4F7CFF);
    final Color accent = selected ? const Color(0xFF7B61C9) : childColor;

    return Semantics(
      button: true,
      selected: selected,
      label: '${child.name}. ${childAgeText(child.birthDate)}.',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 230),
            curve: Curves.easeOutCubic,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  dark ? const Color(0xFF211D2B) : Colors.white,
                  accent.withValues(alpha: dark ? 0.22 : 0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: accent.withValues(alpha: selected ? 0.58 : 0.28),
                width: selected ? 1.8 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: dark ? 0.07 : 0.13),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -42,
                  right: -26,
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: dark ? 0.07 : 0.055),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 18,
                  bottom: 18,
                  child: Container(
                    width: selected ? 5 : 3,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: selected ? 0.95 : 0.55),
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
                        width: 74,
                        height: 74,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accent.withValues(alpha: 0.32),
                              accent.withValues(alpha: 0.10),
                            ],
                          ),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.16),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ChildAvatar(child: child, size: 64),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (selected) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A896)
                                      .withValues(alpha: dark ? 0.18 : 0.11),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color(0xFF00A896)
                                        .withValues(alpha: 0.18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 14,
                                      color: Color(0xFF00A896),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      T.txt('active'),
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
                            ],
                            Text(
                              child.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 21,
                                height: 1.05,
                                fontWeight: FontWeight.w800,
                                color:
                                    dark ? Colors.white : const Color(0xFF302942),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Wrap(
                              spacing: 7,
                              runSpacing: 6,
                              children: [
                                _ChildMetaChip(
                                  icon: Icons.cake_outlined,
                                  text: childAgeText(child.birthDate),
                                  color: accent,
                                  dark: dark,
                                ),
                                _ChildMetaChip(
                                  icon: child.sex == ChildSex.girl
                                      ? Icons.face_3_rounded
                                      : Icons.face_6_rounded,
                                  text: child.sex == ChildSex.girl
                                      ? T.txt('girl')
                                      : T.txt('boy'),
                                  color: childColor,
                                  dark: dark,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 9),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: dark ? 0.20 : 0.11),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accent.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: accent,
                          size: 21,
                        ),
                      ),
                    ],
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

class _ChildMetaChip extends StatelessWidget {
  const _ChildMetaChip({
    required this.icon,
    required this.text,
    required this.color,
    required this.dark,
  });

  final IconData icon;
  final String text;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 12.5,
              height: 1,
              fontWeight: FontWeight.w700,
              color: dark ? Colors.white70 : const Color(0xFF625A69),
            ),
          ),
        ],
      ),
    );
  }
}
