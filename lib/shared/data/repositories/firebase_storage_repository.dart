import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/repositories/storage_repository.dart';

class FirebaseStorageRepository implements IStorageRepository {
  final FirebaseStorage _storage;

  FirebaseStorageRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadImage({
    required String path,
    required File file,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  @override
  Future<void> deleteImage(String url) async {
    final ref = _storage.refFromURL(url);
    await ref.delete();
  }
}
