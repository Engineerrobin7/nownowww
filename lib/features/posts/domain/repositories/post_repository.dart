import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/paginated_posts.dart';

abstract class IPostRepository {
  Future<void> createPost(PostModel post);
  
  Future<void> updatePost(PostModel post);
  
  Future<void> deletePost(String postId);
  
  Stream<List<PostModel>> watchFeed({PostType? type});
  
  Future<PaginatedPosts> fetchFeed({DocumentSnapshot? lastDoc, int limit = 20, PostType? type});
  
  Stream<List<PostModel>> watchUserPosts(String uid);
  
  Future<void> likePost(String postId, String uid);
  
  Future<void> unlikePost(String postId, String uid);
  
  Future<void> incrementShareCount(String postId);

  Future<PostModel?> getPost(String postId);
}
