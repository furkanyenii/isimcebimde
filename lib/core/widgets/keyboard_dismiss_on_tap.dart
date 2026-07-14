import 'package:flutter/material.dart';

/// [child]'ın dışına dokunulduğunda klavyeyi kapatır.
///
/// iOS'un düz sayı klavyesinde (ör. `TextInputType.number`) sistem
/// seviyesinde "Bitti" tuşu yoktur — alfabetik klavyeden farklı olarak.
/// Bu sarmalayıcı olmadan kullanıcı sayısal bir alanda klavyeyi kapatamaz.
class KeyboardDismissOnTap extends StatelessWidget {
  const KeyboardDismissOnTap({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
