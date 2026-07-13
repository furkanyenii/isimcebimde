import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';

void main() {
  const company = Customer(
    id: 1,
    type: CustomerType.company,
    name: 'Yılmaz İnşaat Ltd. Şti.',
    contactPerson: 'Ahmet Yılmaz',
    phone: '0532 111 22 33',
    taxOffice: 'Kadıköy',
    taxNumber: '1234567890',
  );

  group('CustomerType', () {
    test('veritabanı gösterimi metindir, enum index\'i değil', () {
      expect(CustomerType.individual.wireName, 'individual');
      expect(CustomerType.company.wireName, 'company');
    });

    test('gidiş-dönüş kayıpsızdır', () {
      for (final type in CustomerType.values) {
        expect(CustomerType.fromWireName(type.wireName), type);
      }
    });

    test('bilinmeyen değer sessizce varsayılana düşmez, hata fırlatır', () {
      // Bozuk veriyi gizlemek, onu göstermekten daha tehlikelidir.
      expect(
        () => CustomerType.fromWireName('kurumsal'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Customer.copyWith', () {
    test('verilmeyen alanlar korunur', () {
      final result = company.copyWith(name: 'Yılmaz İnşaat A.Ş.');

      expect(result.name, 'Yılmaz İnşaat A.Ş.');
      expect(result.contactPerson, 'Ahmet Yılmaz');
      expect(result.phone, '0532 111 22 33');
      expect(result.taxNumber, '1234567890');
    });

    test('null verilen alan gerçekten temizlenir', () {
      // Düz `String?` parametresiyle bu çağrı telefonu SESSİZCE korurdu:
      // kullanıcı alanı boşaltıp kaydettiğinde veri güncellenmemiş olurdu.
      final result = company.copyWith(phone: null, taxOffice: null);

      expect(result.phone, isNull);
      expect(result.taxOffice, isNull);
      // Dokunulmayan alanlar etkilenmemeli.
      expect(result.contactPerson, 'Ahmet Yılmaz');
      expect(result.taxNumber, '1234567890');
    });

    test('bireysele çevirmek kurumsal alanları kendiliğinden silmez', () {
      // Temizleme sorumluluğu çağıranındır; entity sessizce veri atmaz.
      final result = company.copyWith(type: CustomerType.individual);

      expect(result.type, CustomerType.individual);
      expect(result.contactPerson, 'Ahmet Yılmaz');
    });
  });

  test('değer eşitliği kimlik değil içerik üzerinden kurulur', () {
    const same = Customer(
      id: 1,
      type: CustomerType.company,
      name: 'Yılmaz İnşaat Ltd. Şti.',
      contactPerson: 'Ahmet Yılmaz',
      phone: '0532 111 22 33',
      taxOffice: 'Kadıköy',
      taxNumber: '1234567890',
    );

    expect(same, company);
    expect(same.hashCode, company.hashCode);
    expect(company.copyWith(name: 'Başka'), isNot(company));
  });
}
