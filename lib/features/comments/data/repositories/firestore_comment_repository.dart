import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nownowww/core/constants/firebase_constants.dart';
import 'package:nownowww/features/comments/domain/models/comment_model.dart';
import '../../domain/repositories/comment_repository.dart';

class FirestoreCommentRepository implements ICommentRepository {
  final FirebaseFirestore _firestore;

  FirestoreCommentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  @override
  Future<void> addComment(CommentModel comment) async {
    final batch = _firestore.batch();
    
    // 1. Create the comment
    batch.set(_comments.doc(comment.id), comment.toJson());
    
    // 2. Increment post's comment counter (Atomic)
    batch.update(_firestore.collection(FirebaseConstants.postsCollection).doc(comment.postId), {
      'commentCount': FieldValue.increment(1),
    });

    // 3. Increment user's global comment stat
    batch.update(_firestore.collection(FirebaseConstants.usersCollection).doc(comment.uid), {
      'commentsCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Stream<List<CommentModel>> watchComments(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .limit(100) // Scaled limit
        .snapshots()
        .map((snap) => snap.docs.map((doc) => CommentModel.fromJson(doc.data())).toList());
  }

  @override
  Future<void> addReply(ReplyModel reply) async {
    final batch = _firestore.batch();
    final replyRef = _firestore.collection('replies').doc(reply.id);
    
    batch.set(replyRef, reply.toJson());
    
    // Increment specific comment's reply count
    batch.update(_comments.doc(reply.commentId), {
      'replyCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Stream<List<ReplyModel>> watchReplies(String commentId) {
    return _firestore
        .collection('replies')
        .where('commentId', isEqualTo: commentId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ReplyModel.fromJson(doc.data())).toList());
  }

  @override
  Future<void> deleteComment(String commentId, String postId) async {
    final batch = _firestore.batch();
    batch.delete(_comments.doc(commentId));
    batch.update(_firestore.collection('posts').doc(postId), {
      'commentCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  @override
  Future<void> deleteReply(String replyId, String commentId) async {
    final batch = _firestore.batch();
    batch.delete(_firestore.collection('replies').doc(replyId));
    batch.update(_comments.doc(commentId), {
      'replyCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  @override
  Future<void> likeComment(String commentId, String uid) async {
    await _comments.doc(commentId).update({
      'likes': FieldValue.arrayUnion([uid]),
    });
  }

  @override
  Future<void> unlikeComment(String commentId, String uid) async {
    await _comments.doc(commentId).update({
      'likes': FieldValue.arrayRemove([uid]),
    });
  }
}
