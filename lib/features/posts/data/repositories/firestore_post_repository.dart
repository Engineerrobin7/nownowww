import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nownowww/core/constants/firebase_constants.dart';
import 'package:nownowww/features/posts/domain/models/post_model.dart';
import 'package:nownowww/features/posts/domain/models/paginated_posts.dart';
import 'package:nownowww/features/posts/domain/repositories/post_repository.dart';

class FirestorePostRepository implements IPostRepository {
  final FirebaseFirestore _firestore;

  FirestorePostRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference<Map<String, dynamic>> get _postLikes =>
      _firestore.collection('post_likes');

  @override
  Future<void> createPost(PostModel post) async {
    final batch = _firestore.batch();
    final postRef = _posts.doc(post.id);
    final userRef = _firestore.collection(FirebaseConstants.usersCollection).doc(post.uid);

    final data = post.toJson();
    if (post.isAnonymous) {
      data['uid'] = 'anonymous_user';
      data['authorName'] = 'Someone';
      data['authorUsername'] = 'anonymous';
      data['authorPhotoUrl'] = null;
    }

    batch.set(postRef, data);

    // Increment user's post counters
    if (!post.isAnonymous) {
      final counterField = post.type == PostType.need ? 'needsCount' : 'thoughtsCount';
      batch.update(userRef, {
        counterField: FieldValue.increment(1),
        'postsCount': FieldValue.increment(1),
      });
    }

    await batch.commit();
  }

  @override
  Future<void> updatePost(PostModel post) async {
    await _posts.doc(post.id).update(post.toJson());
  }

  @override
  Future<void> deletePost(String postId) async {
    await _posts.doc(postId).delete();
    // Note: In production, we'd trigger a Cloud Function to clean up likes
  }

  @override
  Stream<List<PostModel>> watchFeed({PostType? type}) {
    Query<Map<String, dynamic>> query = _posts.orderBy('createdAt', descending: true);
    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }
    
    return query.snapshots().map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<PaginatedPosts> fetchFeed({DocumentSnapshot? lastDoc, int limit = 20, PostType? type}) async {
    Query<Map<String, dynamic>> query = _posts.orderBy('createdAt', descending: true);
    
    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }
    
    query = query.limit(limit);
    
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    
    final snapshot = await query.get();
    final posts = snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    
    return PaginatedPosts(
      posts: posts,
      lastDoc: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      hasMore: posts.length == limit,
    );
  }

  @override
  Stream<List<PostModel>> watchUserPosts(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> likePost(String postId, String uid) async {
    final batch = _firestore.batch();
    final likeId = '${postId}_$uid';

    batch.set(_postLikes.doc(likeId), {
      'postId': postId,
      'userId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.update(_posts.doc(postId), {
      'likesCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Future<void> unlikePost(String postId, String uid) async {
    final batch = _firestore.batch();
    final likeId = '${postId}_$uid';

    batch.delete(_postLikes.doc(likeId));

    batch.update(_posts.doc(postId), {
      'likesCount': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  @override
  Future<PostModel?> getPost(String postId) async {
    final doc = await _posts.doc(postId).get();
    if (!doc.exists || doc.data() == null) return null;
    return PostModel.fromJson(doc.data()!);
  }

  @override
  Future<void> incrementShareCount(String postId) async {
    await _posts.doc(postId).update({
      'shareCount': FieldValue.increment(1),
    });
  }

  // Scalable check for "Has Liked"
  Future<bool> hasLikedPost(String postId, String uid) async {
    final doc = await _postLikes.doc('${postId}_$uid').get();
    return doc.exists;
  }
}
