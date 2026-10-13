import 'package:flutter/material.dart';

/// Shared, accessible visual components for Wawa Kalú family guides.
class FamilyUi {
  FamilyUi._();
  static const canvasLight = Color(0xFFFAF7F2);
  static const canvasDark = Color(0xFF15131A);
  static const surfaceDark = Color(0xFF211B2E);
  static bool dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  static Color ink(BuildContext context) =>
      dark(context) ? Colors.white : const Color(0xFF302942);
  static Color muted(BuildContext context) =>
      dark(context) ? Colors.white70 : const Color(0xFF6C6476);

  static AppBar appBar(BuildContext context, String title) => AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: dark(context) ? surfaceDark : Colors.white,
        foregroundColor: ink(context),
        title: Text(title, style: const TextStyle(
          fontFamily: 'Fredoka', fontSize: 23, fontWeight: FontWeight.w700,
        )),
      );
}

class FamilyHero extends StatelessWidget {
  const FamilyHero({super.key, required this.eyebrow, required this.title,
    required this.subtitle, required this.icon, required this.color,
    required this.accent});
  final String eyebrow, title, subtitle;
  final IconData icon;
  final Color color, accent;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [
          Color.lerp(color, Colors.black, .27)!,
          Color.lerp(Color.lerp(color, accent, .52)!, Colors.black, .27)!,
        ]),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [BoxShadow(color: color.withValues(alpha: .20),
        blurRadius: 24, offset: const Offset(0, 12))],
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(children: [
      Positioned(top: -48, right: -35, child: Container(width: 170, height: 170,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: .10)))),
      Positioned(bottom: -75, right: 65, child: Container(width: 160, height: 160,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: .07)))),
      Padding(padding: const EdgeInsets.all(24),
        child: LayoutBuilder(builder: (context, constraints) {
          final compact = constraints.maxWidth < 300;
          return Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white.withValues(alpha: .24))),
                  child: Text(eyebrow, style: const TextStyle(fontFamily: 'Baloo2',
                    fontSize: 12, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: .6))),
                const SizedBox(height: 14),
                Text(title, style: TextStyle(fontFamily: 'Fredoka',
                  fontSize: compact ? 25 : 29, fontWeight: FontWeight.w800,
                  height: 1.08, color: Colors.white)),
                const SizedBox(height: 10),
                Text(subtitle, style: TextStyle(fontFamily: 'Baloo2', fontSize: 15,
                  height: 1.3, color: Colors.white.withValues(alpha: .92))),
              ])),
            if (!compact) ...[
              const SizedBox(width: 12),
              Container(width: 76, height: 76,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withValues(alpha: .24))),
                child: Icon(icon, color: Colors.white, size: 39)),
            ],
          ]);
        })),
    ]),
  );
}

class FamilySectionHeading extends StatelessWidget {
  const FamilySectionHeading({super.key, required this.title, this.subtitle, this.icon});
  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        if (icon != null) ...[
          Icon(icon, color: const Color(0xFF9C73DD), size: 23),
          const SizedBox(width: 9),
        ],
        Expanded(child: Text(title, style: TextStyle(fontFamily: 'Fredoka',
          fontSize: 23, fontWeight: FontWeight.w800, color: FamilyUi.ink(context)))),
      ]),
      if (subtitle != null) ...[
        const SizedBox(height: 4),
        Text(subtitle!, style: TextStyle(fontFamily: 'Baloo2',
          fontSize: 15, height: 1.3, color: FamilyUi.muted(context))),
      ],
    ]),
  );
}

/// Navigable or expandable topic tile, with accessible InkWell feedback.
class FamilyTopicCard extends StatelessWidget {
  const FamilyTopicCard({super.key, required this.title, required this.subtitle,
    required this.icon, required this.color, required this.onTap,
    this.expanded = false, this.content, this.badge, this.featured = false});
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool expanded, featured;
  final Widget? content;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final isDark = FamilyUi.dark(context);
    return Padding(padding: const EdgeInsets.only(bottom: 13),
      child: Material(color: isDark ? FamilyUi.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(25), clipBehavior: Clip.antiAlias,
        child: AnimatedContainer(duration: const Duration(milliseconds: 240),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color.withValues(alpha: expanded ? .52 : .18),
              width: expanded ? 1.7 : 1),
            gradient: featured || expanded ? LinearGradient(colors: [
              color.withValues(alpha: isDark ? .21 : .09),
              color.withValues(alpha: isDark ? .07 : .02),
            ]) : null),
          child: Column(children: [
            InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.all(17),
              child: Row(children: [
                Container(width: 56, height: 56,
                  decoration: BoxDecoration(color: color.withValues(alpha: isDark ? .24 : .13),
                    borderRadius: BorderRadius.circular(19)),
                  child: Icon(icon, color: color, size: 28)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badge != null) ...[
                      Text(badge!, style: TextStyle(fontFamily: 'Baloo2',
                        fontSize: 12, fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white70 : color)),
                      const SizedBox(height: 3),
                    ],
                    Text(title, style: TextStyle(fontFamily: 'Fredoka',
                      fontSize: 19, fontWeight: FontWeight.w800,
                      color: FamilyUi.ink(context))),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontFamily: 'Baloo2',
                      fontSize: 14, height: 1.25, color: FamilyUi.muted(context))),
                  ])),
                const SizedBox(width: 8),
                AnimatedRotation(duration: const Duration(milliseconds: 240),
                  turns: content == null ? 0 : (expanded ? .5 : 0),
                  child: Icon(content == null ? Icons.arrow_forward_ios_rounded :
                    Icons.keyboard_arrow_down_rounded, color: color,
                    size: content == null ? 18 : 27)),
              ]))),
            if (content != null) AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut, alignment: Alignment.topCenter,
              child: expanded ? Padding(padding: const EdgeInsets.fromLTRB(17, 0, 17, 18),
                child: Column(children: [
                  Divider(color: color.withValues(alpha: .23), height: 12),
                  const SizedBox(height: 10),
                  content!,
                ])) : const SizedBox(width: double.infinity)),
          ]),
        ),
      ),
    );
  }
}

class FamilyInfoPanel extends StatelessWidget {
  const FamilyInfoPanel({super.key, required this.title, required this.text,
    required this.icon, required this.color});
  final String title, text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: FamilyUi.dark(context) ? .17 : .075),
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: color.withValues(alpha: .18))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 22, color: color), const SizedBox(width: 9),
        Expanded(child: Text(title, style: TextStyle(fontFamily: 'Fredoka',
          fontSize: 17, fontWeight: FontWeight.w800, color: FamilyUi.ink(context)))),
      ]),
      const SizedBox(height: 9),
      Text(text, style: TextStyle(fontFamily: 'Baloo2',
        fontSize: 15, height: 1.35, color: FamilyUi.muted(context))),
    ]),
  );
}

class FamilyBulletList extends StatelessWidget {
  const FamilyBulletList({super.key, required this.items,
    required this.color, this.numbered = false});
  final List<String> items;
  final Color color;
  final bool numbered;

  @override
  Widget build(BuildContext context) => Column(children: [
    for (var i = 0; i < items.length; i++)
      Padding(padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 26, height: 26, alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(9)),
            child: numbered ? Text('${i + 1}', style: TextStyle(
              color: color, fontFamily: 'Fredoka', fontWeight: FontWeight.w800)) :
              Icon(Icons.check_rounded, color: color, size: 16)),
          const SizedBox(width: 11),
          Expanded(child: Padding(padding: const EdgeInsets.only(top: 2),
            child: Text(items[i], style: TextStyle(fontFamily: 'Baloo2',
              fontSize: 15, height: 1.35, color: FamilyUi.muted(context))))),
        ])),
  ]);
}

class FamilyNotice extends StatelessWidget {
  const FamilyNotice({super.key, required this.text,
    this.color = const Color(0xFFE68B54),
    this.icon = Icons.tips_and_updates_rounded});
  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: FamilyUi.dark(context) ? FamilyUi.surfaceDark : Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: color.withValues(alpha: .22))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 25), const SizedBox(width: 12),
      Expanded(child: Text(text, style: TextStyle(fontFamily: 'Baloo2',
        fontSize: 15, height: 1.4, color: FamilyUi.muted(context)))),
    ]),
  );
}

class FamilyPrimaryLink extends StatelessWidget {
  const FamilyPrimaryLink({super.key, required this.title, required this.subtitle,
    required this.icon, required this.color, required this.onTap});
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color, borderRadius: BorderRadius.circular(24),
    clipBehavior: Clip.antiAlias,
    child: InkWell(onTap: onTap, child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
      child: Row(children: [
        Container(width: 52, height: 52,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18),
            borderRadius: BorderRadius.circular(17)),
          child: Icon(icon, color: Colors.white, size: 27)),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'Fredoka', fontSize: 19,
            fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(fontFamily: 'Baloo2',
            fontSize: 14, height: 1.25, color: Colors.white)),
        ])),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_rounded, color: Colors.white),
      ]),
    )),
  );
}
