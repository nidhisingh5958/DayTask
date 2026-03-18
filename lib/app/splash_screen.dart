import 'dart:async';

import 'package:daytask_app/app/theme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    _autoAdvanceTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        widget.onContinue();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = width > 700 ? 520.0 : width * 0.92;
    final titleSize = width < 420 ? 46.0 : 56.0;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A1324), AppTheme.background],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: -90,
            right: -70,
            child: _GlowOrb(
              size: 250,
              colors: [
                AppTheme.accent.withValues(alpha: 0.18),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            left: -80,
            bottom: 110,
            child: _GlowOrb(
              size: 220,
              colors: [
                const Color(0xFF79A8FF).withValues(alpha: 0.14),
                Colors.transparent,
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardWidth),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0x33FFFFFF),
                          width: 0.9,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            blurRadius: 30,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _BrandRow(),
                            const SizedBox(height: 22),
                            const _IllustrationBlock(),
                            const SizedBox(height: 24),
                            Text(
                              'Manage\nyour\nTask with',
                              style: TextStyle(
                                fontSize: titleSize,
                                height: 0.94,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                              ),
                            ),
                            Text(
                              'DayTask',
                              style: TextStyle(
                                fontSize: titleSize,
                                height: 0.94,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                                color: AppTheme.accent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Plan your day, focus better, finish faster.',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: widget.onContinue,
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: const Text("Let's Start"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0x33F4C95D),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.watch_later_outlined, color: AppTheme.accent),
        ),
        const SizedBox(width: 12),
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Day',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'Task',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppTheme.accent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IllustrationBlock extends StatelessWidget {
  const _IllustrationBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF2F4F7), Color(0xFFE7EAF0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 18,
            left: 18,
            child: Container(
              width: 100,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE2E8),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 18,
            child: Container(
              width: 130,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE2E8),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 92,
            right: 44,
            child: Container(
              width: 86,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFFE0B84F),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            top: 95,
            right: 46,
            child: Container(
              width: 38,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4A4),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.person_outline,
              size: 120,
              color: Colors.blueGrey.shade700,
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 38,
            child: Container(
              height: 7,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade700,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 18,
            child: Container(
              width: 64,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE2E8),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
