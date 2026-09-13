import 'dart:io';

abstract class IStorageRepository {
  Future<String> uploadImage({
    required String path,
    required File file,
  });
  
  Future<void> deleteImage(String url);
}
