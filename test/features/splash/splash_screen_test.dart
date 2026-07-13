import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/app/di/app_initialization_provider.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:isimcebimde/features/splash/presentation/screens/splash_screen.dart';

/// Splash gerçek veritabanına dokunmaz; başlatma sonucu override edilir.
/// (DB'ye dokunan testler `testWidgets` içinde çalışmaz — CLAUDE.md: Test Rules.)
void main() {
  Widget buildApp(Future<void> Function(Ref ref) initialization) =>
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [appInitializationProvider.overrideWith(initialization)],
        child: const MaterialApp(home: SplashScreen()),
      );

  testWidgets('başlatma sürerken marka ve ilerleme gösterir', (tester) async {
    // Hiç tamamlanmayan future → kalıcı loading.
    await tester.pumpWidget(buildApp((ref) => Completer<void>().future));
    await tester.pump();

    expect(find.text('Quotra'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(AppErrorView), findsNothing);
  });

  testWidgets('başlatma hata verirse kullanıcı splash\'te kilitlenmez', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp((ref) async => throw Exception('DB açılamadı')),
    );
    await tester.pumpAndSettle();

    // Sonsuz spinner değil, görünür hata ve tekrar deneme yolu.
    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.text('Tekrar dene'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(DashboardScreen), findsNothing);
  });

  testWidgets('başlatma bitince dashboard\'a geçer', (tester) async {
    // Yönlendirmeyi sınadığı için gerçek router ile kurulur.
    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [appInitializationProvider.overrideWith((ref) async {})],
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });
}
