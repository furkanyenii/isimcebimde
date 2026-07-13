import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isimcebimde/app/di/app_initialization_provider.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';

/// Açılış ekranı. Veritabanı hazırlanırken marka gösterilir; hazır olunca
/// dashboard'a geçilir. Hata olursa kullanıcı sonsuza kadar burada beklemez —
/// hata ekranı ve tekrar dene aksiyonu gösterilir (CLAUDE.md: UI Rules).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(appInitializationProvider, (previous, next) {
      if (next.hasValue && !next.isLoading) {
        context.go(AppRoutes.dashboard);
      }
    });

    final initialization = ref.watch(appInitializationProvider);

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: initialization.when(
          data: (_) => const _Branding(),
          loading: () => const _Branding(showProgress: true),
          error: (error, _) => AppErrorView(
            message: 'Uygulama başlatılamadı. Veritabanı açılamıyor.',
            onRetry: () => ref.invalidate(appInitializationProvider),
          ),
        ),
      ),
    );
  }
}

class _Branding extends StatelessWidget {
  const _Branding({this.showProgress = false});

  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.request_quote_outlined,
          size: AppSizes.iconLg,
          color: context.colors.primary,
        ),
        const SizedBox(height: AppSizes.md),
        Text('Quotra', style: context.textStyles.headlineMedium),
        const SizedBox(height: AppSizes.xs),
        Text(
          'Dakikalar içinde teklif',
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
