import 'package:intl/intl.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';

/// Paylaşılan PDF'in dosya adı: `TKL-2026-000001-16072026.pdf`.
///
/// Teklif numarası **korunur**: dosya adı yalnızca tarihten oluşsaydı aynı gün
/// hazırlanan iki teklif aynı ada sahip olur, karşı tarafın indirilenlerinde
/// biri diğerinin üstüne yazardı.
///
/// [sharedAt] çağıranca verilir (`DateTime.now()`); "bugün" fonksiyonun içinde
/// okunsaydı davranış test edilemezdi.
///
/// Tarih biçimi locale'den bağımsız sabittir: dosya adı kullanıcıya okunan bir
/// metin değil, dosya sisteminde ve eklerde taşınan bir kimliktir.
String offerPdfFileName(
  Offer offer, {
  required String draftLabel,
  required DateTime sharedAt,
}) {
  final date = DateFormat('ddMMyyyy').format(sharedAt);
  // Kaydedilmemiş teklifin numarası yoktur; taslak etiketiyle basılır.
  final identifier = offer.quoteNumberOrNull ?? draftLabel;
  return '$identifier-$date.pdf';
}
