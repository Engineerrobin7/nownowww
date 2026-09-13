import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../../domain/repositories/storage_repository.dart';

class CloudinaryStorageRepository implements IStorageRepository {
  final CloudinaryPublic _cloudinary;

  CloudinaryStorageRepository({
    required String cloudName,
    required String uploadPreset,
  })  : _cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);

  @override
  Future<String> uploadImage({
    required String path,
    required File file,
  }) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: path.split('/').first,
          publicId: path.split('/').last.replaceAll('.jpg', '').replaceAll('.png', ''),
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload to Cloudinary: $e');
    }
  }

  @override
  Future<void> deleteImage(String url) async {
    // Note: Deleting via the public client is restricted for security.
    // Usually, deletion should happen via backend (Cloud Functions) using Admin API.
    // For MVP, we'll focus on uploads.
  }
}
