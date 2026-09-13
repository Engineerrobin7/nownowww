import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/firestore_comment_repository.dart';
import '../../domain/models/comment_model.dart';
import '../../domain/repositories/comment_repository.dart';
import 'package:nownowww/features/profile/presentation/providers/block_providers.dart';

part 'comment_providers.g.dart';

@riverpod
ICommentRepository commentRepository(CommentRepositoryRef ref) {
  return FirestoreCommentRepository();
}

@riverpod
Stream<List<CommentModel>> postComments(PostCommentsRef ref, String postId) {
  final blockedUsers = ref.watch(blockedUsersProvider).valueOrNull ?? [];
  return ref.watch(commentRepositoryProvider).watchComments(postId).map((comments) {
    return comments.where((comment) => !blockedUsers.contains(comment.uid)).toList();
  });
}

@riverpod
Stream<List<ReplyModel>> commentReplies(CommentRepliesRef ref, String commentId) {
  final blockedUsers = ref.watch(blockedUsersProvider).valueOrNull ?? [];
  return ref.watch(commentRepositoryProvider).watchReplies(commentId).map((replies) {
    return replies.where((reply) => !blockedUsers.contains(reply.uid)).toList();
  });
}
