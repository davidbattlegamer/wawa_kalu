import 'package:flutter/material.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';
import '../data/parent_activity_catalog.dart';

// Guía de actividades con materiales cotidianos para madres, padres y cuidadores.
class GuiaFamiliasPage extends StatefulWidget {
  const GuiaFamiliasPage({
    super.key,
    this.initialAgeGroup = -1,
  });

  final int initialAgeGroup;

  @override
  State<GuiaFamiliasPage> createState() => _GuiaFamiliasPageState();
}

class _GuiaFamiliasPageState extends State<GuiaFamiliasPage> {
  late int _age;
  ActivityArea? _area;

  @override
  void initState() {
    super.initState();
    _age = widget.initialAgeGroup >= 0 && widget.initialAgeGroup <= 3
        ? widget.initialAgeGroup
        : -1;
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, language, _) {
        final List<ParentActivity> visible = parentActivityCatalog.where((a) {
          return (_age == -1 || a.ageGroup == _age) &&
              (_area == null || a.area == _area);
        }).toList();


        return Scaffold(
          backgroundColor: dark ? const Color(0xFF15131A) : const Color(0xFFFAF7F2),
          appBar: AppBar(
            elevation: 0,
            centerTitle: false,
            backgroundColor: dark ? const Color(0xFF211B2E) : Colors.white,
            foregroundColor: dark ? Colors.white : const Color(0xFF30283D),
            title: Text(
              T.txt('learning'),
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double side = width < 380 ? 16 : 20;
                final double inner = width - side * 2;
                final bool twoColumns = inner >= 650;
                final double cardWidth = twoColumns ? (inner - 14) / 2 : inner;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(side, 20, side, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GuideHero(dark: dark),
                      const SizedBox(height: 25),
                      _SectionHeading(
                        title: T.txt('guideAgesTitle'),
                        icon: Icons.child_care_rounded,
                        dark: dark,
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int index = -1; index < 4; index++) ...[
                              _FilterPill(
                                label: index == -1
                                    ? T.txt('guideAllAges')
                                    : _ageLabel(index),
                                selected: _age == index,
                                dark: dark,
                                color: const Color(0xFF8054D7),
                                onTap: () => setState(() => _age = index),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _SectionHeading(
                        title: T.txt('guideAreasTitle'),
                        icon: Icons.category_rounded,
                        dark: dark,
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterPill(
                              label: T.txt('guideAllAreas'),
                              selected: _area == null,
                              dark: dark,
                              color: const Color(0xFF8054D7),
                              onTap: () => setState(() => _area = null),
                            ),
                            const SizedBox(width: 8),
                            for (final area in ActivityArea.values) ...[
                              _FilterPill(
                                label: _areaLabel(area),
                                selected: _area == area,
                                dark: dark,
                                color: _areaColor(area),
                                onTap: () => setState(() => _area = area),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 23),
                      _GuideTip(dark: dark),
                      const SizedBox(height: 27),
                      Row(
                        children: [
                          Expanded(
                            child: _SectionHeading(
                              title: T.txt('guideActivitiesTitle'),
                              icon: Icons.auto_awesome_rounded,
                              dark: dark,
                            ),
                          ),
                          Text(
                            T.txt('guideCount').replaceAll(
                              '{count}',
                              visible.length.toString(),
                            ),
                            style: TextStyle(
                              fontFamily: 'Baloo2',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: dark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      if (visible.isEmpty)
                        _EmptyGuide(
                          dark: dark,
                          onReset: () => setState(() {
                            _age = -1;
                            _area = null;
                          }),
                        )
                      else
                        Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            for (final activity in visible)
                              SizedBox(
                                width: cardWidth,
                                child: _ActivityCard(
                                  activity: activity,
                                  dark: dark,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => _ActivityDetailPage(
                                          activity: activity,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 28),
                      _InlineNote(
                        text: T.txt('learningUnifiedClosing'),
                        icon: Icons.favorite_rounded,
                        color: const Color(0xFF8B5CF6),
                        dark: dark,
                      ),

                      const SizedBox(height: 22),
                      Text(
                        T.txt('guideAgeNotice'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          fontSize: 13,
                          height: 1.35,
                          color: dark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}


class _InlineNote extends StatelessWidget {
  const _InlineNote({
    required this.text,
    required this.icon,
    required this.color,
    required this.dark,
  });

  final String text;
  final IconData icon;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.12 : 0.065),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 14.5,
                height: 1.35,
                color: dark ? Colors.white70 : const Color(0xFF625A69),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _ageLabel(int group) {
  switch (group) {
    case 0: return T.txt('guideAge12');
    case 1: return T.txt('guideAge23');
    case 2: return T.txt('guideAge34');
    default: return T.txt('guideAge45');
  }
}

String _areaLabel(ActivityArea area) {
  switch (area) {
    case ActivityArea.exploration: return T.txt('guideAreaExplore');
    case ActivityArea.movement: return T.txt('guideAreaMove');
    case ActivityArea.language: return T.txt('guideAreaLanguage');
    case ActivityArea.protection: return T.txt('guideAreaProtection');
    case ActivityArea.thinking: return T.txt('guideAreaThink');
    case ActivityArea.creativity: return T.txt('guideAreaCreate');
    case ActivityArea.life: return T.txt('guideAreaLife');
    case ActivityArea.feelings: return T.txt('guideAreaFeel');
  }
}

Color _areaColor(ActivityArea area) {
  switch (area) {
    case ActivityArea.exploration: return const Color(0xFF00A896);
    case ActivityArea.movement: return const Color(0xFFEF8354);
    case ActivityArea.language: return const Color(0xFF477CE6);
    case ActivityArea.protection: return const Color(0xFF16A085);
    case ActivityArea.thinking: return const Color(0xFF8A58D6);
    case ActivityArea.creativity: return const Color(0xFFE85D8E);
    case ActivityArea.life: return const Color(0xFF1C9C8B);
    case ActivityArea.feelings: return const Color(0xFFDE7C38);
  }
}

IconData _areaIcon(ActivityArea area) {
  switch (area) {
    case ActivityArea.exploration: return Icons.spa_rounded;
    case ActivityArea.movement: return Icons.directions_walk_rounded;
    case ActivityArea.language: return Icons.forum_rounded;
    case ActivityArea.protection: return Icons.shield_rounded;
    case ActivityArea.thinking: return Icons.extension_rounded;
    case ActivityArea.creativity: return Icons.palette_rounded;
    case ActivityArea.life: return Icons.home_work_rounded;
    case ActivityArea.feelings: return Icons.favorite_rounded;
  }
}

class _GuideHero extends StatelessWidget {
  final bool dark;
  const _GuideHero({required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [const Color(0xFF423073), const Color(0xFF733E68)]
              : [const Color(0xFF7250C9), const Color(0xFFE37799)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8054D7).withValues(alpha: dark ? 0.20 : 0.25),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              right: -45, top: -55,
              child: _SoftCircle(size: 190, opacity: 0.10),
            ),
            Positioned(
              right: 52, bottom: -55,
              child: _SoftCircle(size: 135, opacity: 0.09),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(21, 25, 14, 24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.19),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            T.txt('learningUnifiedTag'),
                            style: const TextStyle(
                              fontFamily: 'Baloo2',
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          T.txt('learningUnifiedTitle'),
                          style: const TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 28,
                            height: 1.04,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          T.txt('learningUnifiedSubtitle'),
                          style: TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 14,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.93),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 86,
                    height: 145,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(27),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.32),
                            ),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        const Positioned(
                          top: 3, right: 0,
                          child: Icon(Icons.star_rounded,
                              color: Color(0xFFFFE28A), size: 29),
                        ),
                        const Positioned(
                          bottom: 0, left: 3,
                          child: Icon(Icons.spa_rounded,
                              color: Color(0xFFD1FFE8), size: 29),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _SoftCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: opacity),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool dark;
  const _SectionHeading({
    required this.title, required this.icon, required this.dark,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 22, color: const Color(0xFF9A65DF)),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: dark ? Colors.white : const Color(0xFF30283D),
          ),
        ),
      ),
    ],
  );
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final bool dark;
  final Color color;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label, required this.selected, required this.dark,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? color
              : (dark ? const Color(0xFF292432) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : color.withValues(alpha: 0.17),
          ),
          boxShadow: selected
              ? [BoxShadow(
                  color: color.withValues(alpha: 0.22),
                  blurRadius: 12, offset: const Offset(0, 5),
                )]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Baloo2',
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: selected
                ? Colors.white
                : (dark ? Colors.white70 : const Color(0xFF4B4258)),
          ),
        ),
      ),
    ),
  );
}

class _GuideTip extends StatelessWidget {
  final bool dark;
  const _GuideTip({required this.dark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: dark ? const Color(0xFF263A38) : const Color(0xFFEAF7F1),
      borderRadius: BorderRadius.circular(21),
      border: Border.all(
        color: const Color(0xFF43B998).withValues(alpha: 0.30),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 43, height: 43,
          decoration: BoxDecoration(
            color: const Color(0xFF42AD91).withValues(alpha: 0.17),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.favorite_outline_rounded,
              color: Color(0xFF17A183)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                T.txt('guideTipTitle'),
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: dark ? Colors.white : const Color(0xFF276F5C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                T.txt('guideTipText'),
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  height: 1.27,
                  fontSize: 13.5,
                  color: dark ? Colors.white70 : const Color(0xFF416A5E),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ActivityCard extends StatelessWidget {
  final ParentActivity activity;
  final bool dark;
  final VoidCallback onTap;
  const _ActivityCard({
    required this.activity, required this.dark, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = _areaColor(activity.area);
    final String? imageAsset = activity.imageAsset;
    final ActivityCopy copy = activity.copyFor(AppConfig.idioma.value);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: dark
                  ? [const Color(0xFF282230), color.withValues(alpha: 0.15)]
                  : [Colors.white, color.withValues(alpha: 0.09)],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color.withValues(alpha: dark ? 0.32 : 0.24)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: dark ? 0.08 : 0.10),
                blurRadius: 16, offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withValues(alpha: 0.95), color.withValues(alpha: 0.62)],
                  ),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (imageAsset != null)
                      Positioned.fill(
                        // La foto reemplaza al icono en el MISMO espacio de
                        // 76 x 100 px; no se altera la tarjeta ni sus textos.
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Image.asset(
                            imageAsset,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                            errorBuilder: (_, __, ___) => Icon(
                              _areaIcon(activity.area),
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      Positioned(
                        top: -17, right: -18,
                        child: _SoftCircle(size: 65, opacity: 0.19),
                      ),
                      Icon(
                        _areaIcon(activity.area),
                        color: Colors.white,
                        size: 40,
                      ),
                    ],
                    const Positioned(
                      bottom: 7, right: 8,
                      child: Icon(Icons.star_rounded,
                          color: Color(0xFFFFE8A4), size: 17),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _areaLabel(activity.area).toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      copy.title,
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 18,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: dark ? Colors.white : const Color(0xFF2C2633),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      copy.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 13.2,
                        height: 1.23,
                        color: dark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      children: [
                        _SmallTag(
                          text: _ageLabel(activity.ageGroup),
                          color: color, dark: dark,
                        ),
                        _SmallTag(
                          text: '${activity.minutes} ${T.txt('guideMinutes')}',
                          color: color, dark: dark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          T.txt('guideActivityCta'),
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(Icons.arrow_forward_rounded, size: 17, color: color),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallTag extends StatelessWidget {
  final String text;
  final Color color;
  final bool dark;
  const _SmallTag({required this.text, required this.color, required this.dark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: dark ? 0.21 : 0.11),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'Baloo2',
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
        color: dark ? Colors.white : color,
      ),
    ),
  );
}

class _EmptyGuide extends StatelessWidget {
  final bool dark;
  final VoidCallback onReset;
  const _EmptyGuide({required this.dark, required this.onReset});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(
      color: dark ? const Color(0xFF292432) : Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      children: [
        const Icon(Icons.search_off_rounded, size: 42, color: Color(0xFF9B7CD6)),
        const SizedBox(height: 10),
        Text(T.txt('guideNoResults'), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        TextButton(onPressed: onReset, child: Text(T.txt('guideResetFilters'))),
      ],
    ),
  );
}

class _ActivityDetailPage extends StatefulWidget {
  final ParentActivity activity;
  const _ActivityDetailPage({required this.activity});

  @override
  State<_ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<_ActivityDetailPage> {
  final Set<int> _readyMaterials = <int>{};
  final Set<int> _doneSteps = <int>{};

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final ParentActivity activity = widget.activity;
    final Color color = _areaColor(activity.area);
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, language, _) {
        final ActivityCopy copy = activity.copyFor(language);
        return Scaffold(
          backgroundColor: dark ? const Color(0xFF15131A) : const Color(0xFFFAF7F2),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: dark ? const Color(0xFF211B2E) : Colors.white,
            foregroundColor: dark ? Colors.white : const Color(0xFF30283D),
            title: Text(
              T.txt('guideDetails'),
              style: const TextStyle(
                fontFamily: 'Fredoka', fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(23),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.73)],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.20),
                              blurRadius: 20, offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(_areaIcon(activity.area),
                                size: 48, color: Colors.white),
                            const SizedBox(height: 13),
                            Text(
                              _areaLabel(activity.area).toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Baloo2',
                                color: Colors.white.withValues(alpha: 0.88),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              copy.title,
                              style: const TextStyle(
                                fontFamily: 'Fredoka',
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 29,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              copy.subtitle,
                              style: const TextStyle(
                                fontFamily: 'Baloo2',
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _WhiteTag(text: _ageLabel(activity.ageGroup)),
                                _WhiteTag(
                                  text: '${activity.minutes} ${T.txt('guideMinutes')}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (activity.imageAsset != null) ...[
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: SizedBox(
                            width: double.infinity,
                            height: 190,
                            child: Image.asset(
                              activity.imageAsset!,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (_, __, ___) => ColoredBox(
                                color: color.withValues(alpha: 0.10),
                                child: Center(
                                  child: Icon(
                                    _areaIcon(activity.area),
                                    color: color,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _GuideSection(
                        title: T.txt('guideGoal'),
                        icon: Icons.track_changes_rounded,
                        color: color, dark: dark,
                        child: Text(copy.goal, style: _bodyStyle(dark)),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: dark ? const Color(0xFF49342E) : const Color(0xFFFFF2E5),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFE6A15A).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.shield_rounded,
                                color: Color(0xFFDB8331), size: 26),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    T.txt('guideSafety'),
                                    style: TextStyle(
                                      fontFamily: 'Fredoka',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: dark ? Colors.white : const Color(0xFF875321),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(copy.safety, style: _bodyStyle(dark)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _GuideSection(
                        title: T.txt('guideMaterials'),
                        icon: Icons.inventory_2_rounded,
                        color: color, dark: dark,
                        trailing: Text(
                          T.txt('guideReadyCount')
                              .replaceAll('{ready}', _readyMaterials.length.toString())
                              .replaceAll('{total}', copy.materials.length.toString()),
                          style: TextStyle(
                            fontFamily: 'Baloo2', fontWeight: FontWeight.w700,
                            fontSize: 12, color: color,
                          ),
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < copy.materials.length; i++)
                              _CheckRow(
                                text: copy.materials[i],
                                checked: _readyMaterials.contains(i),
                                dark: dark,
                                color: color,
                                onTap: () => setState(() {
                                  if (!_readyMaterials.add(i)) {
                                    _readyMaterials.remove(i);
                                  }
                                }),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _GuideSection(
                        title: T.txt('guideSteps'),
                        icon: Icons.format_list_numbered_rounded,
                        color: color, dark: dark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: LinearProgressIndicator(
                                minHeight: 7,
                                value: _doneSteps.length / copy.steps.length,
                                backgroundColor: color.withValues(alpha: 0.12),
                                valueColor: AlwaysStoppedAnimation<Color>(color),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              T.txt('guideStepProgress')
                                  .replaceAll('{done}', _doneSteps.length.toString())
                                  .replaceAll('{total}', copy.steps.length.toString()),
                              style: TextStyle(
                                fontFamily: 'Baloo2',
                                color: dark ? Colors.white60 : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (int i = 0; i < copy.steps.length; i++)
                              _StepRow(
                                number: i + 1,
                                text: copy.steps[i],
                                done: _doneSteps.contains(i),
                                color: color, dark: dark,
                                onTap: () => setState(() {
                                  if (!_doneSteps.add(i)) {
                                    _doneSteps.remove(i);
                                  }
                                }),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _GuideSection(
                        title: T.txt('guideObserve'),
                        icon: Icons.visibility_rounded,
                        color: const Color(0xFF269F8B),
                        dark: dark,
                        child: Text(copy.observe, style: _bodyStyle(dark)),
                      ),
                      const SizedBox(height: 14),
                      _GuideSection(
                        title: T.txt('guideAdapt'),
                        icon: Icons.volunteer_activism_rounded,
                        color: const Color(0xFFE46F93),
                        dark: dark,
                        child: Text(copy.adapt, style: _bodyStyle(dark)),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: TextButton.icon(
                          onPressed: () => setState(() {
                            _readyMaterials.clear();
                            _doneSteps.clear();
                          }),
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: Text(T.txt('guideRestart')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

TextStyle _bodyStyle(bool dark) => TextStyle(
  fontFamily: 'Baloo2',
  fontSize: 14.5,
  height: 1.35,
  color: dark ? Colors.white70 : const Color(0xFF514A59),
);

class _WhiteTag extends StatelessWidget {
  final String text;
  const _WhiteTag({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.21),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Baloo2',
        fontWeight: FontWeight.w800,
        fontSize: 12.5,
        color: Colors.white,
      ),
    ),
  );
}

class _GuideSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool dark;
  final Widget child;
  final Widget? trailing;

  const _GuideSection({
    required this.title, required this.icon, required this.color,
    required this.dark, required this.child, this.trailing,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: dark ? const Color(0xFF27212F) : Colors.white,
      borderRadius: BorderRadius.circular(23),
      border: Border.all(color: color.withValues(alpha: dark ? 0.22 : 0.13)),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: dark ? 0.04 : 0.055),
          blurRadius: 13, offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 23, color: color),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: dark ? Colors.white : const Color(0xFF30283D),
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 11),
        child,
      ],
    ),
  );
}

class _CheckRow extends StatelessWidget {
  final String text;
  final bool checked;
  final bool dark;
  final Color color;
  final VoidCallback onTap;
  const _CheckRow({
    required this.text, required this.checked, required this.dark,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Checkbox(
            value: checked,
            onChanged: (_) => onTap(),
            activeColor: color,
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              text,
              style: _bodyStyle(dark).copyWith(
                decoration: checked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;
  final bool done;
  final Color color;
  final bool dark;
  final VoidCallback onTap;

  const _StepRow({
    required this.number, required this.text, required this.done,
    required this.color, required this.dark, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Material(
      color: color.withValues(alpha: done ? 0.12 : 0.055),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 29, height: 29,
                decoration: BoxDecoration(
                  color: done ? color : color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                      : Text(
                          number.toString(),
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: _bodyStyle(dark).copyWith(
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
