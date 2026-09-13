import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nownowww/core/constants/firebase_constants.dart';

class AdminService {
  final FirebaseFirestore _firestore;

  AdminService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // CEO Dashboard: Total User Count (Aggregation Query)
  Future<int> getTotalUsers() async {
    final snapshot = await _firestore.collection(FirebaseConstants.usersCollection).count().get();
    return snapshot.count ?? 0;
  }

  // CEO Dashboard: Total Posts Today
  Future<int> getPostsCountToday() async {
    final today = DateTime.now().subtract(const Duration(hours: 24));
    final snapshot = await _firestore
        .collection(FirebaseConstants.postsCollection)
        .where('createdAt', isGreaterThan: today)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  // Bulk Content Cleanup (Scalable Deletion)
  Future<void> deleteInappropriatePost(String postId) async {
    // 1. Delete post
    await _firestore.collection(FirebaseConstants.postsCollection).doc(postId).delete();
    
    // 2. Note: A production Cloud Function would then clean up comments/likes in background
  }
}
