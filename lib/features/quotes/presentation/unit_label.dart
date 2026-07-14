import 'package:isimcebimde/features/quotes/domain/entities/offer_unit.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';

/// Bir birimin kullanıcıya gösterilen etiketi.
///
/// Hazır birimler dile göre çevrilir (`piece` → "adet" / "pcs"); kullanıcının
/// kendi eklediği birim ne yazdıysa öyle görünür — onu çevirebileceğimiz bir
/// sözlük yok.
///
/// Widget dosyasında değil burada yaşar: PDF çıktısı da bu etiketi kullanır ve
/// `pdf` katmanının bir Flutter widget'ını import etmesi gerekmemeli.
String unitLabel(AppLocalizations l10n, String wireName) =>
    switch (OfferUnit.tryFromWireName(wireName)) {
      OfferUnit.piece => l10n.unitPiece,
      OfferUnit.squareMeter => l10n.unitSquareMeter,
      OfferUnit.cubicMeter => l10n.unitCubicMeter,
      OfferUnit.package => l10n.unitPackage,
      OfferUnit.set => l10n.unitSet,
      OfferUnit.box => l10n.unitBox,
      null => wireName,
    };
