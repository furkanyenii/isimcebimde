import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/errors/failure_localizer.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';

/// Her [Failure] tipinin **her desteklenen dilde** bir karşılığı olmalı.
///
/// `Failure` sealed olduğu için çeviri switch'i exhaustive; yeni bir hata tipi
/// eklenip çevirisi yazılmazsa kod zaten derlenmez. Buradaki testler bir adım
/// öteye gidip çevirinin *boş olmadığını* ve *dile göre gerçekten değiştiğini*
/// doğrular — anahtarın var olması, çevirinin yapılmış olması demek değildir.
void main() {
  /// Her varyantından bir örnek. Yeni bir Failure eklenirse buraya da eklenmeli.
  const failures = <Failure>[
    DatabaseFailure(DataOperation.read, EntityKind.product),
    DatabaseFailure(DataOperation.create, EntityKind.product),
    DatabaseFailure(DataOperation.update, EntityKind.product),
    DatabaseFailure(DataOperation.delete, EntityKind.product),
    DatabaseFailure(DataOperation.read, EntityKind.category),
    DatabaseFailure(DataOperation.create, EntityKind.category),
    DatabaseFailure(DataOperation.update, EntityKind.category),
    DatabaseFailure(DataOperation.delete, EntityKind.category),
    DatabaseFailure(DataOperation.read, EntityKind.customer),
    DatabaseFailure(DataOperation.create, EntityKind.customer),
    DatabaseFailure(DataOperation.update, EntityKind.customer),
    DatabaseFailure(DataOperation.delete, EntityKind.customer),
    EmptyNameFailure(EntityKind.product),
    EmptyNameFailure(EntityKind.category),
    EmptyNameFailure(EntityKind.customer),
    UnsavedEntityFailure(EntityKind.product),
    UnsavedEntityFailure(EntityKind.category),
    UnsavedEntityFailure(EntityKind.customer),
    NegativePriceFailure(),
    InvalidEmailFailure(),
    InvalidNationalIdFailure(),
    InvalidTaxNumberFailure(),
    DuplicateCategoryFailure('Hırdavat'),
    CategoryInUseFailure(),
    ExportFailure('pdf write failed'),
  ];

  for (final locale in AppLocalizations.supportedLocales) {
    group('${locale.languageCode} çevirileri', () {
      final l10n = lookupAppLocalizations(locale);

      test('her hata tipi boş olmayan bir mesaja çevrilir', () {
        for (final failure in failures) {
          final message = failure.localized(l10n);
          expect(
            message.trim(),
            isNotEmpty,
            reason:
                '${failure.runtimeType} (${failure.debugLabel}) çevrilmemiş',
          );
        }
      });

      test('aynı hata iki kez aynı mesajı verir (yan etkisiz)', () {
        for (final failure in failures) {
          expect(failure.localized(l10n), failure.localized(l10n));
        }
      });
    });
  }

  test('mesajlar dile göre gerçekten değişir', () {
    final tr = lookupAppLocalizations(const Locale('tr'));
    final en = lookupAppLocalizations(const Locale('en'));

    // Anahtarın var olması, çevirinin yapılmış olması demek değildir:
    // ARB'ye İngilizce metni kopyalayıp bırakmak sessiz bir hatadır.
    for (final failure in failures.where((f) => f is! ExportFailure)) {
      expect(
        failure.localized(tr),
        isNot(failure.localized(en)),
        reason: '${failure.runtimeType} iki dilde de aynı metni veriyor',
      );
    }
  });

  test('kullanıcı verisi mesaja parametre olarak girer', () {
    final tr = lookupAppLocalizations(const Locale('tr'));

    // Kategori adı kullanıcının yazdığı veridir; çevrilmez, yerleştirilir.
    expect(
      const DuplicateCategoryFailure('Hırdavat').localized(tr),
      contains('Hırdavat'),
    );
  });

  test('Failure olmayan hata genel mesaja düşer, stack trace sızmaz', () {
    final tr = lookupAppLocalizations(const Locale('tr'));
    final message = localizeError(StateError('beklenmeyen'), tr);

    expect(message, tr.errorGeneric);
    expect(message, isNot(contains('StateError')));
  });

  test('debugLabel kullanıcıya gösterilmez, teknik kalır', () {
    // debugLabel yalnızca log içindir; çeviriyle karıştırılmamalı.
    expect(
      const DatabaseFailure(
        DataOperation.create,
        EntityKind.product,
      ).debugLabel,
      'product.create failed',
    );
  });
}
