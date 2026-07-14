/// Cihazdan logo görseli seçtirir.
///
/// Arayüz olarak tanımlıdır çünkü galeri açmak platform kanalı gerektirir ve
/// testte çalıştırılamaz; ekran testi bunu sahteleyerek yürür.
abstract interface class LogoPicker {
  /// Seçilen dosyanın (geçici) yolu. Kullanıcı vazgeçtiyse `null`.
  Future<String?> pickImage();
}
