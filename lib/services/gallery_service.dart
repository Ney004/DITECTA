import 'dart:io';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryService {
  static Future<bool> saveToGallery(String imagePath) async {
    try {
      // Solicitar permisos en Android
      if (Platform.isAndroid) {
        final storage = await Permission.storage.request();
        final photos = await Permission.photos.request();

        if (!storage.isGranted && !photos.isGranted) return false;
      }

      final result = await SaverGallery.saveFile(
        filePath: imagePath, // ← nombre correcto
        fileName: 'DITECTA_${DateTime.now().millisecondsSinceEpoch}',
        androidRelativePath: 'Pictures/DITECTA',
        skipIfExists: false,
      );

      return result.isSuccess;
    } catch (e) {
      return false;
    }
  }
}
