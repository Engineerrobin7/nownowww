import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_block_repository.dart';
import '../../domain/repositories/block_repository.dart';

part 'block_providers.g.dart';

@riverpod
IBlockRepository blockRepository(BlockRepositoryRef ref) {
  return FirestoreBlockRepository();
}

@riverpod
Stream<List<String>> blockedUsers(BlockedUsersRef ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(blockRepositoryProvider).watchBlockedUsers(user.uid);
}
