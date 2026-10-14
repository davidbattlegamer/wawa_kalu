import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'app_config.dart';
import 'app_texts.dart';
import 'widgets/config_sheet.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  bool _starting = false;
  bool _pressing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _scale = Tween<double>(
      begin: 0.86,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.055),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startApp() async {
    if (_starting) {
      return;
    }

    setState(() {
      _pressing = true;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 100),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _pressing = false;
      _starting = true;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 360),
    );

    await AppConfig.marcarBienvenidaVista();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idioma, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppConfig.temaApp,
          builder: (context, themeMode, _) {
            final bool dark =
                Theme.of(context).brightness == Brightness.dark;

            return Scaffold(
              backgroundColor:
                  dark ? const Color(0xFF15131A) : const Color(0xFFFFFBF6),
              body: SafeArea(
                child: Stack(
                  children: [
                    _WelcomeBackground(dark: dark),
                    Positioned.fill(
                      child: FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: _WelcomeContent(
                            dark: dark,
                            scale: _scale,
                            starting: _starting,
                            pressing: _pressing,
                            onStart: _startApp,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 12,
                      child: _SettingsButton(
                        dark: dark,
                        onTap: () => showConfigSheet(context),
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

class _WelcomeBackground extends StatelessWidget {
  const _WelcomeBackground({
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -110,
              left: -90,
              child: _GlowBlob(
                size: 270,
                color: const Color(0xFF8B5CF6),
                opacity: dark ? 0.13 : 0.08,
              ),
            ),
            Positioned(
              top: 210,
              right: -120,
              child: _GlowBlob(
                size: 250,
                color: const Color(0xFF00A896),
                opacity: dark ? 0.11 : 0.07,
              ),
            ),
            Positioned(
              bottom: -130,
              left: 20,
              child: _GlowBlob(
                size: 290,
                color: const Color(0xFFFF8A4C),
                opacity: dark ? 0.09 : 0.065,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: opacity * 0.8),
            blurRadius: 80,
            spreadRadius: 16,
          ),
        ],
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent({
    required this.dark,
    required this.scale,
    required this.starting,
    required this.pressing,
    required this.onStart,
  });

  final bool dark;
  final Animation<double> scale;
  final bool starting;
  final bool pressing;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact =
            constraints.maxHeight < 760 || constraints.maxWidth < 380;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            compact ? 20 : 28,
            20,
            compact ? 22 : 30,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 560,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: compact ? 8 : 18,
                  ),
                  ScaleTransition(
                    scale: scale,
                    child: _OwlHero(
                      dark: dark,
                      compact: compact,
                    ),
                  ),
                  SizedBox(
                    height: compact ? 14 : 18,
                  ),
                  _BrandLockup(
                    dark: dark,
                    compact: compact,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    T.txt('welcomeHeroEyebrow'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: Color(0xFF00A896),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    T.txt('welcomeHeroTitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: compact ? 28 : 33,
                      height: 1.06,
                      fontWeight: FontWeight.w900,
                      color: dark
                          ? Colors.white
                          : const Color(0xFF302942),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      T.txt('welcomeHeroSubtitle'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: compact ? 14.5 : 15.5,
                        height: 1.34,
                        fontWeight: FontWeight.w600,
                        color: dark
                            ? Colors.white70
                            : const Color(0xFF6F667B),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: compact ? 20 : 24,
                  ),
                  _WelcomeGlassPanel(
                    dark: dark,
                    child: Column(
                      children: [
                        _WelcomeFeatureRow(
                          icon: Icons.health_and_safety_rounded,
                          color: const Color(0xFFEC5F7A),
                          title: T.txt('welcomeFeatureHealthTitle'),
                          description:
                              T.txt('welcomeFeatureHealthSubtitle'),
                          dark: dark,
                        ),
                        _WelcomeDivider(dark: dark),
                        _WelcomeFeatureRow(
                          icon: Icons.auto_stories_rounded,
                          color: const Color(0xFF7B61C9),
                          title: T.txt('welcomeFeatureLearnTitle'),
                          description:
                              T.txt('welcomeFeatureLearnSubtitle'),
                          dark: dark,
                        ),
                        _WelcomeDivider(dark: dark),
                        _WelcomeFeatureRow(
                          icon: Icons.family_restroom_rounded,
                          color: const Color(0xFF16B89A),
                          title: T.txt('welcomeFeatureFamilyTitle'),
                          description:
                              T.txt('welcomeFeatureFamilySubtitle'),
                          dark: dark,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: compact ? 18 : 22,
                  ),
                  _TrustStrip(dark: dark),
                  SizedBox(
                    height: compact ? 18 : 22,
                  ),
                  _StartButton(
                    starting: starting,
                    pressing: pressing,
                    onTap: onStart,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 16,
                        color: dark
                            ? Colors.white38
                            : const Color(0xFF16A085),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          T.txt('welcomeFooterNote'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 12.5,
                            height: 1.2,
                            color: dark
                                ? Colors.white54
                                : Colors.black45,
                          ),
                        ),
                      ),
                    ],
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

class _OwlHero extends StatelessWidget {
  const _OwlHero({
    required this.dark,
    required this.compact,
  });

  final bool dark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double size = compact ? 172 : 210;

    return SizedBox(
      width: size + 54,
      height: size + 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFD86F).withValues(
                    alpha: dark ? 0.18 : 0.30,
                  ),
                  const Color(0xFF8B5CF6).withValues(
                    alpha: dark ? 0.12 : 0.08,
                  ),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 6,
            child: _Sparkle(
              size: 35,
              color: const Color(0xFFFFC857),
              dark: dark,
            ),
          ),
          Positioned(
            bottom: 22,
            left: 8,
            child: _Sparkle(
              size: 24,
              color: const Color(0xFF16B89A),
              dark: dark,
            ),
          ),
          Positioned(
            top: 58,
            left: 1,
            child: _MiniDot(
              size: 13,
              color: const Color(0xFFEC5F7A),
            ),
          ),
          Container(
            width: size - 12,
            height: size - 12,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dark
                  ? Colors.white.withValues(alpha: 0.035)
                  : Colors.white.withValues(alpha: 0.66),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: dark ? 0.10 : 0.86,
                ),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(
                    alpha: dark ? 0.12 : 0.16,
                  ),
                  blurRadius: 34,
                  offset: const Offset(0, 13),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/home.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.child_care_rounded,
                  size: 96,
                  color: Color(0xFF7B2CBF),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({
    required this.dark,
    required this.compact,
  });

  final bool dark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Wawa',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: compact ? 38 : 44,
              height: 1,
              fontWeight: FontWeight.w900,
              color: dark
                  ? Colors.white
                  : const Color(0xFF4A2C82),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: compact ? 38 : 44,
            child: Image.asset(
              'assets/images/logo_kalu.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  'Kalú',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: compact ? 36 : 42,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: dark
                        ? Colors.white
                        : const Color(0xFF4A2C82),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({
    required this.size,
    required this.color,
    required this.dark,
  });

  final double size;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: dark ? 0.13 : 0.18,
        ),
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        size: size * 0.55,
        color: color,
      ),
    );
  }
}

class _MiniDot extends StatelessWidget {
  const _MiniDot({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.82),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _WelcomeGlassPanel extends StatelessWidget {
  const _WelcomeGlassPanel({
    required this.dark,
    required this.child,
  });

  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? [
                      Colors.white.withValues(alpha: 0.085),
                      const Color(0xFF8B5CF6)
                          .withValues(alpha: 0.055),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.80),
                      const Color(0xFFF7F1FF)
                          .withValues(alpha: 0.60),
                    ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: dark ? 0.10 : 0.86,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A2C82).withValues(
                  alpha: dark ? 0.06 : 0.09,
                ),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _WelcomeFeatureRow extends StatelessWidget {
  const _WelcomeFeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.dark,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 11,
      ),
      child: Row(
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: dark ? 0.17 : 0.10,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.14),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: dark
                        ? Colors.white
                        : const Color(0xFF302942),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 13.5,
                    height: 1.23,
                    color: dark
                        ? Colors.white60
                        : const Color(0xFF746B7C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeDivider extends StatelessWidget {
  const _WelcomeDivider({
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: dark
          ? Colors.white.withValues(alpha: 0.07)
          : Colors.black.withValues(alpha: 0.055),
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip({
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
      decoration: BoxDecoration(
        color: const Color(0xFF16B89A).withValues(
          alpha: dark ? 0.10 : 0.065,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF16B89A)
              .withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 41,
            height: 41,
            decoration: BoxDecoration(
              color: const Color(0xFF16B89A).withValues(
                alpha: dark ? 0.16 : 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              size: 21,
              color: Color(0xFF16B89A),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  T.txt('welcomeTrustTitle'),
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: dark
                        ? Colors.white
                        : const Color(0xFF302942),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  T.txt('welcomeTrustSubtitle'),
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 13,
                    height: 1.22,
                    color: dark
                        ? Colors.white60
                        : const Color(0xFF6F667B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({
    required this.starting,
    required this.pressing,
    required this.onTap,
  });

  final bool starting;
  final bool pressing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: pressing ? 0.975 : 1,
      duration: const Duration(milliseconds: 110),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: starting
                ? const [
                    Color(0xFF16B89A),
                    Color(0xFF4D8DFF),
                  ]
                : const [
                    Color(0xFF7B61C9),
                    Color(0xFFEC5F7A),
                  ],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B61C9)
                  .withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            onTap: starting ? null : onTap,
            borderRadius: BorderRadius.circular(22),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: starting
                    ? Row(
                        key: const ValueKey('starting'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 21,
                            height: 21,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.3,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            T.txt('startingApp'),
                            style: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 18.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        key: const ValueKey('start'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            T.txt('welcomeStartButton'),
                            style: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 9),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 23,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    required this.dark,
    required this.onTap,
  });

  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 14,
          sigmaY: 14,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.white.withValues(alpha: 0.72),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: dark ? 0.10 : 0.88,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: dark ? 0.12 : 0.06,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.settings_rounded,
                color: dark
                    ? Colors.white
                    : const Color(0xFF4A2C82),
                size: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
