import 'package:image_picker/image_picker.dart';
import 'package:isimcebimde/features/settings/domain/repositories/logo_picker.dart';

class ImagePickerLogoPicker implements LogoPicker {
  const ImagePickerLogoPicker();

  /// Logo teklif başlığında küçük görünür; tam çözünürlüklü bir fotoğrafı
  /// saklamanın anlamı yok — küçültülerek kopyalanır.
  static const double _maxDimension = 1024;

  @override
  Future<String?> pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: _maxDimension,
      maxHeight: _maxDimension,
    );
    return file?.path;
  }
}
