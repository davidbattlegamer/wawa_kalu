import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ChildPhotoService {
  ChildPhotoService._();

  static final ChildPhotoService instance =
      ChildPhotoService._();

  // ============================================================
  // SELECCIONAR FOTO
  // ============================================================

  Future<String?> pickPhoto() async {
    try {
      final PlatformFile? file =
          await FilePicker.pickFile(
        type: FileType.image,
      );

      if (file == null) {
        return null;
      }

      final String? filePath =
          file.path;

      if (filePath == null ||
          filePath.trim().isEmpty) {
        return null;
      }

      return filePath;
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // GUARDAR FOTO EN LA CARPETA DE LA APP
  // ============================================================

  Future<String> savePhoto({
    required String childId,
    required String sourcePath,
  }) async {
    final Directory documents =
        await getApplicationDocumentsDirectory();

    final Directory photosDirectory =
        Directory(
      p.join(
        documents.path,
        'wawa_kalu',
        'child_photos',
      ),
    );

    if (!await photosDirectory.exists()) {
      await photosDirectory.create(
        recursive: true,
      );
    }

    String extension =
        p.extension(
      sourcePath,
    ).toLowerCase();

    if (extension.isEmpty) {
      extension = '.jpg';
    }

    final String fileName =
        '${childId}_${DateTime.now().microsecondsSinceEpoch}$extension';

    final String destinationPath =
        p.join(
      photosDirectory.path,
      fileName,
    );

    final File sourceFile =
        File(
      sourcePath,
    );

    if (!await sourceFile.exists()) {
      throw Exception(
        'La imagen seleccionada no existe.',
      );
    }

    final File savedFile =
        await sourceFile.copy(
      destinationPath,
    );

    return savedFile.path;
  }

  // ============================================================
  // ELIMINAR FOTO
  // ============================================================

  Future<void> deletePhoto(
    String? photoPath,
  ) async {
    if (photoPath == null ||
        photoPath.trim().isEmpty) {
      return;
    }

    try {
      final File file =
          File(
        photoPath,
      );

      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Si la foto ya no existe, la app puede continuar.
    }
  }
}