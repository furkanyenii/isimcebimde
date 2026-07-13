import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';

void main() {
  group('normalizeForSearch', () {
    test('küçültür ve boşlukları kırpar', () {
      expect(normalizeForSearch('  Vida M8  '), 'vida m8');
    });

    test('Türkçe harfleri ASCII\'ye katlar', () {
      expect(normalizeForSearch('Çekiç'), 'cekic');
      expect(normalizeForSearch('Işık'), 'isik');
      expect(normalizeForSearch('ısıtıcı'), 'isitici');
      expect(normalizeForSearch('Güneş'), 'gunes');
      expect(normalizeForSearch('Öğütücü'), 'ogutucu');
      expect(normalizeForSearch('ŞİŞE'), 'sise');
    });

    test('noktalı ve noktasız i aynı yere düşer', () {
      // Türkçe'nin klasik tuzağı: I/ı ve İ/i iki ayrı harftir.
      expect(normalizeForSearch('İzmir'), normalizeForSearch('izmir'));
      expect(normalizeForSearch('IŞIK'), normalizeForSearch('ışık'));
    });
  });

  group('containsNormalized', () {
    test('şapkasız yazan kullanıcı şapkalı kaydı bulur', () {
      // Sahadaki asıl senaryo: telefon klavyesinde kimse ç/ş/ı ile uğraşmaz.
      expect(containsNormalized('Çekiç 500gr', 'cekic'), isTrue);
      expect(containsNormalized('Işık Elektrik', 'isik'), isTrue);
      expect(containsNormalized('Güneş Panel', 'gunes'), isTrue);
    });

    test('şapkalı yazan kullanıcı da bulur (katlama iki taraflıdır)', () {
      expect(containsNormalized('Çekiç 500gr', 'çekiç'), isTrue);
      expect(containsNormalized('Isıtıcı', 'ısıtıcı'), isTrue);
    });

    test('büyük/küçük harf farkı eşleşmeyi bozmaz', () {
      expect(containsNormalized('Çekiç', 'ÇEKİÇ'), isTrue);
    });

    test('parça eşleşmesi yeterlidir', () {
      expect(containsNormalized('Yılmaz İnşaat Ltd. Şti.', 'inşaat'), isTrue);
    });

    test('boş sorgu her şeyle eşleşir (filtre yok demektir)', () {
      expect(containsNormalized('Çekiç', ''), isTrue);
      expect(containsNormalized('Çekiç', '   '), isTrue);
    });

    test('alakasız metin eşleşmez', () {
      expect(containsNormalized('Çekiç', 'tornavida'), isFalse);
    });
  });
}
