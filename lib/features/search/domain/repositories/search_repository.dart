import 'package:nownowww/features/posts/domain/models/post_model.dart';
import 'package:nownowww/features/profile/domain/models/user_model.dart';

abstract class ISearchRepository {
  Future<List<UserModel>> searchUsers(String query);
  
  Future<List<PostModel>> searchPosts(String query);
  
  Future<List<String>> searchTopics(String query);
}
