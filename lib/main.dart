import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      // Riverpod 3 varsayılan olarak hata veren provider'ı arka planda yeniden
      // dener; bu sırada state `AsyncLoading(error: ...)` olarak kalır ve
      // kullanıcı hata ekranı yerine sonsuz spinner görür.
      //
      // Veri kaynağımız yerel bir veritabanı: yeniden denemek bozuk bir DB'yi
      // düzeltmez. Bu yüzden otomatik retry kapatılır — hata kullanıcıya
      // gösterilir ve tekrar denemeyi o başlatır (CLAUDE.md: UI Rules).
      retry: (retryCount, error) => null,
      child: const App(),
    ),
  );
}
