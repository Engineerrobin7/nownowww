import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_user_repository.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

part 'profile_providers.g.dart';

@riverpod
IUserRepository userRepository(UserRepositoryRef ref) {
  return FirestoreUserRepository();
}

@riverpod
Stream<UserModel?> currentUserProfile(CurrentUserProfileRef ref) {
  final authState = ref.watch(authStateChangesProvider).valueOrNull;
  if (authState == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUser(authState.uid);
}

@riverpod
Stream<UserModel?> userProfile(UserProfileRef ref, String uid) {
  return ref.watch(userRepositoryProvider).watchUser(uid);
}

@riverpod
Future<List<UserModel>> userList(UserListRef ref, List<String> uids) {
  return ref.watch(userRepositoryProvider).getUsersByIds(uids);
}

@riverpod
Stream<Set<String>> currentUserFollowing(CurrentUserFollowingRef ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value({});
  
  return FirebaseFirestore.instance
      .collection('social_graph')
      .where('followerUid', isEqualTo: user.uid)
      .snapshots()
      .map((snap) => snap.docs.map((doc) => doc.data()['followingUid'] as String).toSet());
}
