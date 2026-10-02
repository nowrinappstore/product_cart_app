import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> uploadProductImage(XFile file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('products/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final bytes = await file.readAsBytes();
    await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return ref.getDownloadURL();
  }
}