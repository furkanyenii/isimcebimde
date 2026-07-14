/// Firma logosunun kalıcı saklanması.
///
/// Galeriden seçilen dosya OS'un geçici klasöründedir ve önbellek temizlendiğinde
/// **silinir** — o yolu doğrudan veritabanına yazmak, logonun bir gün sessizce
/// kaybolması demektir. Bu yüzden dosya önce uygulamanın belge klasörüne
/// kopyalanır; saklanan yol o kopyayı gösterir.
abstract interface class LogoStorage {
  /// [sourcePath]'teki görseli kalıcı konuma kopyalar ve yeni yolu döner.
  Future<String> save(String sourcePath);

  /// Kalıcı kopyayı siler. Dosya yoksa sessizce geçer.
  Future<void> delete(String path);
}
