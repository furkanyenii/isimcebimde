import 'dart:io';

import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/settings/domain/repositories/logo_storage.dart';
import 'package:path_provider/path_provider.dart';

/// Logoyu uygulamanın belge klasöründe saklar.
class FileLogoStorage implements LogoStorage {
  const FileLogoStorage();

  static const String _fileName = 'company_logo';

  @override
  Future<String> save(String sourcePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final extension = _extensionOf(sourcePath);

      // Dosya adına zaman damgası girer: aynı yola yazmak, Flutter'ın görsel
      // önbelleği eski logoyu göstermeye devam ettiği için yanıltıcı olurdu.
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final target = '${directory.path}/$_fileName-$stamp$extension';

      await File(sourcePath).copy(target);
      return target;
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.update,
        EntityKind.settings,
        cause: e,
      );
    }
  }

  @override
  Future<void> delete(String path) async {
    final file = File(path);
    // Dosya zaten yoksa bu bir hata değil: istenen son durum sağlanmıştır.
    // `existsSync`: tek dosya için async varyantı yavaştır (avoid_slow_async_io).
    if (file.existsSync()) {
      await file.delete();
    }
  }

  static String _extensionOf(String path) {
    final dot = path.lastIndexOf('.');
    final slash = path.lastIndexOf('/');
    if (dot <= slash) return ''; // uzantısız dosya
    return path.substring(dot);
  }
}
