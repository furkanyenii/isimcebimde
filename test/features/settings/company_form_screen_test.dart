import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';
import 'package:isimcebimde/features/settings/domain/repositories/logo_picker.dart';
import 'package:isimcebimde/features/settings/domain/repositories/logo_storage.dart';
import 'package:isimcebimde/features/settings/domain/repositories/settings_repository.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';
import 'package:isimcebimde/features/settings/presentation/screens/company_form_screen.dart';

import '../../support/localized_app.dart';

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this._controller);

  final StreamController<AppSettings> _controller;
  final List<AppSettings> saved = [];

  @override
  Stream<AppSettings> watch() => _controller.stream;

  @override
  Future<void> save(AppSettings settings) async {
    saved.add(settings);
    _controller.add(settings);
  }
}

/// Galeri açmaz; kullanıcının bir dosya seçmiş olmasını taklit eder.
class _FakeLogoPicker implements LogoPicker {
  _FakeLogoPicker(this.result);

  final String? result;

  @override
  Future<String?> pickImage() async => result;
}

/// Dosya sistemine dokunmaz; kopyalama ve silmeyi kaydeder.
class _FakeLogoStorage implements LogoStorage {
  final List<String> stored = [];
  final List<String> deleted = [];

  @override
  Future<String> save(String sourcePath) async {
    stored.add(sourcePath);
    return '/documents/company_logo-1.png';
  }

  @override
  Future<void> delete(String path) async => deleted.add(path);
}

void main() {
  final tr = l10nFor(const Locale('tr'));

  late StreamController<AppSettings> stream;
  late _FakeSettingsRepository repository;
  late _FakeLogoStorage storage;

  setUp(() {
    stream = StreamController<AppSettings>.broadcast();
    repository = _FakeSettingsRepository(stream);
    storage = _FakeLogoStorage();
  });
  tearDown(() => stream.close());

  Widget buildSubject({String? picked}) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      settingsRepositoryProvider.overrideWithValue(repository),
      logoStorageProvider.overrideWithValue(storage),
      logoPickerProvider.overrideWithValue(_FakeLogoPicker(picked)),
    ],
    child: localizedApp(const CompanyFormScreen()),
  );

  testWidgets('mevcut firma bilgileri forma yüklenir', (tester) async {
    await tester.pumpWidget(buildSubject());
    stream.add(
      const AppSettings(
        company: CompanyInfo(name: 'Yılmaz Hırdavat', taxOffice: 'Kadıköy'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Yılmaz Hırdavat'), findsOneWidget);
    expect(find.text('Kadıköy'), findsOneWidget);
  });

  testWidgets('form kaydedilince firma bilgisi yazılır', (tester) async {
    await tester.pumpWidget(buildSubject());
    stream.add(const AppSettings());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, tr.companyNameFieldLabel),
      'Acme Ltd.',
    );
    // Form uzun; test ekranında Kaydet görünür alanın dışında kalıyor.
    await tester.ensureVisible(find.text(tr.actionSave));
    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();

    expect(repository.saved.single.company.name, 'Acme Ltd.');
  });

  testWidgets('geçersiz e-posta kaydı engeller', (tester) async {
    await tester.pumpWidget(buildSubject());
    stream.add(const AppSettings());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, tr.emailLabel),
      'bozuk-adres',
    );
    // Form uzun; test ekranında Kaydet görünür alanın dışında kalıyor.
    await tester.ensureVisible(find.text(tr.actionSave));
    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();

    expect(find.text(tr.errorEmailInvalid), findsOneWidget);
    expect(repository.saved, isEmpty);
  });

  testWidgets('seçilen logo kalıcı konuma kopyalanır ve kaydedilir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(picked: '/tmp/gallery/logo.png'));
    stream.add(const AppSettings());
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.companyLogoAdd));
    await tester.pumpAndSettle();

    // Galerinin geçici yolu değil, kopyalanan dosyanın yolu saklanır.
    expect(storage.stored, ['/tmp/gallery/logo.png']);
    expect(
      repository.saved.single.company.logoPath,
      '/documents/company_logo-1.png',
    );
  });

  testWidgets('logo kaldırılınca dosya da silinir', (tester) async {
    await tester.pumpWidget(buildSubject());
    stream.add(
      const AppSettings(company: CompanyInfo(logoPath: '/documents/eski.png')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.companyLogoRemove));
    await tester.pumpAndSettle();

    expect(repository.saved.single.company.logoPath, isNull);
    // Cihazda çöp dosya bırakılmaz.
    expect(storage.deleted, ['/documents/eski.png']);
  });

  testWidgets('kullanıcı seçimden vazgeçerse hiçbir şey değişmez', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    stream.add(const AppSettings());
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.companyLogoAdd));
    await tester.pumpAndSettle();

    expect(storage.stored, isEmpty);
    expect(repository.saved, isEmpty);
  });
}
