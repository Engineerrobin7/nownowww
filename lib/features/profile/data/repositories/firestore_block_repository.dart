import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nownowww/core/constants/firebase_constants.dart';
import '../../domain/repositories/block_repository.dart';

class FirestoreBlockRepository implements IBlockRepository {
  final FirebaseFirestore _firestore;

  FirestoreBlockRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _blockedCollection =>
      _firestore.collection(FirebaseConstants.blockedUsersCollection);

  @override
  Future<void> blockUser(String blockerId, String blockedId) async {
    await _blockedCollection.doc('${blockerId}_$blockedId').set({
      'blockerId': blockerId,
      'blockedId': blockedId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> unblockUser(String blockerId, String blockedId) async {
    await _blockedCollection.doc('${blockerId}_$blockedId').delete();
  }

  @override
  Stream<List<String>> watchBlockedUsers(String uid) {
    return _blockedCollection
        .where('blockerId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()['blockedId'] as String).toList());
  }

  @override
  Future<bool> isBlocked(String blockerId, String blockedId) async {
    final doc = await _blockedCollection.doc('${blockerId}_$blockedId').get();
    return doc.exists;
  }
}
