import 'package:flutter/material.dart';

/// Uygulamadaki seçim (picker) bottom sheet'lerinin tek kapısı.
///
/// İki davranışı garanti eder:
/// - Sheet **ekranın üst %25'i boşta kalacak şekilde** açılır. Varsayılan
///   `showModalBottomSheet` içeriği kadar yer kaplar; arama + uzun liste
///   barındıran bir picker'da bu, listenin yarısının kırpılması demekti.
/// - Klavye açıldığında liste kısalır, altına kaymaz (`viewInsets` padding'i).
///
/// Sheet içindeki arama alanı **autofocus almaz**: kullanıcı önce listeyi
/// görmeli; klavye sheet'in üstüne binip seçimi zorlaştırıyordu.
Future<T?> showAppPickerSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _PickerSheetFrame(child: builder(context)),
  );
}

class _PickerSheetFrame extends StatelessWidget {
  const _PickerSheetFrame({required this.child});

  final Widget child;

  /// Ekranın alt dörtte üçü. Kalan üst %25 arkadaki ekranı görünür bırakır —
  /// kullanıcı hangi ekranda olduğunu kaybetmez.
  static const double _heightFactor = 0.75;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final targetHeight = MediaQuery.sizeOf(context).height * _heightFactor;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Klavye açıkken hedef yükseklik + klavye ekranı taşırdı; kalan alanla
        // sınırlanır. Sheet kısalır, liste kaydırılabilir kalır.
        final available = constraints.maxHeight - keyboardHeight;
        return Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SizedBox(
            height: targetHeight < available ? targetHeight : available,
            child: child,
          ),
        );
      },
    );
  }
}
