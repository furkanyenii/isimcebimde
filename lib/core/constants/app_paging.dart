/// Listeleme ekranlarındaki sayfalama (pagination) sabitleri.
abstract final class AppPaging {
  /// Bir sayfada gösterilen kayıt sayısı. Bundan fazlası olduğunda sayfalama
  /// kontrolleri görünür (bkz. `core/widgets/app_paginated_list_view.dart`).
  static const int pageSize = 15;

  /// Sayfalama çubuğunun (tek satır) yüksekliği. Ekranlar, çubuk görünürken
  /// FAB'ı bu kadar yukarı kaldırıp çakışmayı önler.
  static const double barHeight = 56;
}
