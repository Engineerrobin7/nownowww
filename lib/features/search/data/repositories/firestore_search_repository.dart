import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nownowww/core/constants/firebase_constants.dart';
import 'package:nownowww/features/posts/domain/models/post_model.dart';
import 'package:nownowww/features/profile/domain/models/user_model.dart';
import '../../domain/repositories/search_repository.dart';

class FirestoreSearchRepository implements ISearchRepository {
  final FirebaseFirestore _firestore;

  FirestoreSearchRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.isEmpty) return [];
    
    // Simple prefix search for username
    final snapshot = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<PostModel>> searchPosts(String query) async {
    if (query.isEmpty) return [];

    final snapshot = await _firestore
        .collection(FirebaseConstants.postsCollection)
        .where('content', isGreaterThanOrEqualTo: query)
        .where('content', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<String>> searchTopics(String query) async {
    if (query.isEmpty) return [];

    final snapshot = await _firestore
        .collection(FirebaseConstants.topicsCollection)
        .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('name', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  }
}
