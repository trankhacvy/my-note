import 'package:image_picker/image_picker.dart';

Future getImageFromGallery() async {
  return ImagePicker.pickImage(source: ImageSource.gallery);
}