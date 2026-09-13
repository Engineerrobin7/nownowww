import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_post_repository.dart';
import '../../domain/models/post_model.dart';
import '../../domain/repositories/post_repository.dart';

part 'post_providers.g.dart';

@riverpod
IPostRepository postRepository(PostRepositoryRef ref) {
  return FirestorePostRepository();
}

@riverpod
Stream<List<PostModel>> userPosts(UserPostsRef ref, String uid) {
  return ref.watch(postRepositoryProvider).watchUserPosts(uid);
}

@riverpod
Future<PostModel?> getPost(GetPostRef ref, String postId) {
  return ref.watch(postRepositoryProvider).getPost(postId);
}

@riverpod
Stream<Set<String>> currentUserLikes(CurrentUserLikesRef ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value({});
  
  return FirebaseFirestore.instance
      .collection('post_likes')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map((snap) => snap.docs.map((doc) => doc.data()['postId'] as String).toSet());
}
