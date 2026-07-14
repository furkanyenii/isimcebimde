import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/domain/repositories/settings_repository.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';
import 'package:isimcebimde/features/settings/presentation/screens/settings_screen.dart';

import '../../support/localized_app.dart';

/// Ekran testi veritabanını değil ekranı sınar; repository sahtelenir
/// (CLAUDE.md: Test Rules).
class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this._controller);

  final StreamController<AppSettings> _controller;
  final List<AppSettings> saved = [];
  Failure? failure;

  @override
  Stream<AppSettings> watch() => _controller.stream;

  @override
  Future<void> save(AppSettings settings) async {
    if (failure != null) throw failure!;
    saved.add(settings);
    _controller.add(settings);
  }
}

void main() {
  final tr = l10nFor(const Locale('tr'));

  late StreamController<AppSettings> stream;
  late _FakeSettingsRepository repository;

  setUp(() {
    stream = StreamController<AppSettings>.broadcast();
    repository = _FakeSettingsRepository(stream);
  });
  tearDown(() => stream.close());

  Widget buildSubject() => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    child: localizedApp(const SettingsScreen()),
  );

  testWidgets('ayar okunana kadar loading gösterilir', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.byType(AppLoadingView), findsOneWidget);
  });

  testWidgets('seçili dil ve tema işaretli gelir', (tester) async {
    await tester.pumpWidget(buildSubject());
    stream.add(
      const AppSettings(
        language: AppLanguage.turkish,
        themeMode: AppThemeMode.dark,
      ),
    );
    await tester.pumpAndSettle();

    // Dil ve tema için birer seçim işareti.
    expect(find.byIcon(Icons.check), findsNWidgets(2));
    expect(
      tester
          .widget<ListTile>(find.widgetWithText(ListTile, tr.languageTurkish))
          .selected,
      isTrue,
    );
    expect(
      tester
          .widget<ListTile>(find.widgetWithText(ListTile, tr.settingsThemeDark))
          .selected,
      isTrue,
    );
  });

  testWidgets('dil seçimi anında kaydedilir', (tester) async {
    await tester.pumpWidget(buildSubject());
    stream.add(const AppSettings());
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.languageEnglish));
    await tester.pumpAndSettle();

    expect(repository.saved.single.language, AppLanguage.english);
  });

  testWidgets('tema seçimi dili varsayılana döndürmez', (tester) async {
    await tester.pumpWidget(buildSubject());
    stream.add(const AppSettings(language: AppLanguage.english));
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.settingsThemeDark));
    await tester.pumpAndSettle();

    final saved = repository.saved.single;
    expect(saved.themeMode, AppThemeMode.dark);
    expect(saved.language, AppLanguage.english); // Tek alan değişti.
  });

  testWidgets('kaydetme hatası kullanıcıya gösterilir', (tester) async {
    repository.failure = const DatabaseFailure(
      DataOperation.update,
      EntityKind.settings,
    );

    await tester.pumpWidget(buildSubject());
    stream.add(const AppSettings());
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.settingsThemeDark));
    await tester.pumpAndSettle();

    expect(find.text(tr.errorSettingsSave), findsOneWidget);
  });

  testWidgets('okuma hatasında sonsuz spinner değil hata ekranı gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    stream.addError(
      const DatabaseFailure(DataOperation.read, EntityKind.settings),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppLoadingView), findsNothing);
    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.text(tr.errorSettingsLoad), findsOneWidget);
  });
}
