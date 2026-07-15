import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isimcebimde/app/di/app_initialization_provider.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_theme.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/splash/presentation/widgets/pulsing_logo.dart';

/// Açılış ekranı. Veritabanı hazırlanırken marka gösterilir; hazır olunca
/// dashboard'a geçilir. Hata olursa kullanıcı sonsuza kadar burada beklemez —
/// hata ekranı ve tekrar dene aksiyonu gösterilir (CLAUDE.md: UI Rules).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // Pulse animasyonunun bitip bitmediği, dışarı sızmayan geçici UI state'i —
  // dashboard'a geçiş hem bu, hem DB init tamamlanınca tetiklenir.
  bool _animationFinished = false;

  void _onAnimationFinished() {
    _animationFinished = true;
    _maybeNavigate();
  }

  void _maybeNavigate() {
    final initialization = ref.read(appInitializationProvider);
    if (!_animationFinished ||
        !initialization.hasValue ||
        initialization.isLoading) {
      return;
    }
    if (!mounted) return;
    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appInitializationProvider, (previous, next) {
      if (next.hasValue && !next.isLoading) {
        _maybeNavigate();
      }
    });

    final initialization = ref.watch(appInitializationProvider);

    // Splash marka rengiyle (koyu gradyan dünyası) tasarlandı; kullanıcının
    // tema tercihinden bağımsız olarak her zaman koyu görünür. Builder, alt
    // ağacın (context.colors) bu koyu temayı okumasını sağlar.
    return Theme(
      data: AppTheme.dark,
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.colors.surface,
          body: Center(
            child: initialization.when(
              data: (_) => _Branding(onAnimationFinished: _onAnimationFinished),
              loading: () => _Branding(
                showProgress: true,
                onAnimationFinished: _onAnimationFinished,
              ),
              error: (error, _) => AppErrorView(
                message: context.l10n.splashInitError,
                onRetry: () => ref.invalidate(appInitializationProvider),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Branding extends StatelessWidget {
  const _Branding({
    required this.onAnimationFinished,
    this.showProgress = false,
  });

  final VoidCallback onAnimationFinished;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PulsingLogo(onFinished: onAnimationFinished),
        const SizedBox(height: AppSizes.md),
        Text('Quotra', style: context.textStyles.headlineMedium),
        const SizedBox(height: AppSizes.xs),
        Text(
          context.l10n.appTagline,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        if (showProgress) ...[
          const SizedBox(height: AppSizes.xl),
          const SizedBox(
            width: AppSizes.iconMd,
            height: AppSizes.iconMd,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ],
    );
  }
}
