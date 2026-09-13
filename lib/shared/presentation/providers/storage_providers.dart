import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/cloudinary_storage_repository.dart';
import '../../domain/repositories/storage_repository.dart';

part 'storage_providers.g.dart';

@riverpod
IStorageRepository storageRepository(StorageRepositoryRef ref) {
  // Replace these with your actual keys from Cloudinary Dashboard
  return CloudinaryStorageRepository(
    cloudName: 'nbkpipgr',
    uploadPreset: 'nownowww_preset',
  );
}
