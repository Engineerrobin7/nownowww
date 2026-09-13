import '../models/comment_model.dart';

abstract class ICommentRepository {
  Future<void> addComment(CommentModel comment);
  Stream<List<CommentModel>> watchComments(String postId);
  Future<void> addReply(ReplyModel reply);
  Stream<List<ReplyModel>> watchReplies(String commentId);
  
  // High-scale management methods
  Future<void> deleteComment(String commentId, String postId);
  Future<void> deleteReply(String replyId, String commentId);
  Future<void> likeComment(String commentId, String uid);
  Future<void> unlikeComment(String commentId, String uid);
}
