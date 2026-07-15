import 'package:flutter/material.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';

/// Splash logosunu sabit sayıda "kalp atışı" (büyü-küçül) ile oynatır,
/// döngüler bitince [onFinished] tetiklenir.
///
/// Animasyon tamamen bu widget'a özel, dışarı sızmayan geçici UI state'i
/// olduğu için StatefulWidget kullanılıyor (CLAUDE.md: State Management —
/// business state değil, business state'ten bağımsız bir sunum detayı).
class PulsingLogo extends StatefulWidget {
  const PulsingLogo({required this.onFinished, super.key});

  final VoidCallback onFinished;

  /// 3 döngü × [AppDurations.heartbeat] (900ms) = splash toplam ~2.7sn.
  /// Nabız bilinçli olarak yavaş: sakin, profesyonel bir açılış hissi.
  static const int _pulseCount = 3;

  @override
  State<PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<PulsingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  int _completedPulses = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.heartbeat,
    )..addStatusListener(_onStatusChanged);
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.08), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _completedPulses++;
    if (_completedPulses >= PulsingLogo._pulseCount) {
      widget.onFinished();
      return;
    }
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onStatusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      // Şeffaf köşeli varyant: koyu splash üzerinde siyah kare çerçeve
      // görünmez. Launcher ikonu ayrı bir opak varyant kullanır (quotra_icon.png).
      child: Image.asset(
        'assets/images/quotra_logo_transparent.png',
        width: AppSizes.logoSplash,
        height: AppSizes.logoSplash,
      ),
    );
  }
}
