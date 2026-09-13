import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nownowww/core/constants/firebase_constants.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class FirestoreUserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;

  FirestoreUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  
  CollectionReference<Map<String, dynamic>> get _socialGraph =>
      _firestore.collection('social_graph');

  @override
  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toJson());
  }

  @override
  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.uid).update(user.toJson());
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    final query = await _users.where('username', isEqualTo: username).get();
    return query.docs.isEmpty;
  }

  @override
  Stream<UserModel?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> followUser(String currentUid, String targetUid) async {
    final batch = _firestore.batch();
    final followId = '${currentUid}_$targetUid';
    
    // 1. Create social graph link
    batch.set(_socialGraph.doc(followId), {
      'followerUid': currentUid,
      'followingUid': targetUid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Increment counts (Atomic)
    batch.update(_users.doc(currentUid), {
      'followingCount': FieldValue.increment(1),
    });
    batch.update(_users.doc(targetUid), {
      'followersCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Future<void> unfollowUser(String currentUid, String targetUid) async {
    final batch = _firestore.batch();
    final followId = '${currentUid}_$targetUid';
    
    // 1. Delete link
    batch.delete(_socialGraph.doc(followId));

    // 2. Decrement counts
    batch.update(_users.doc(currentUid), {
      'followingCount': FieldValue.increment(-1),
    });
    batch.update(_users.doc(targetUid), {
      'followersCount': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  @override
  Future<List<UserModel>> getPopularUsers() async {
    final query = await _users
        .orderBy('followersCount', descending: true)
        .limit(10)
        .get();
    
    return query.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<UserModel>> getUsersByIds(List<String> uids) async {
    if (uids.isEmpty) return [];
    
    final List<UserModel> users = [];
    for (var i = 0; i < uids.length; i += 10) {
      final chunk = uids.sublist(i, i + 10 > uids.length ? uids.length : i + 10);
      final query = await _users.where(FieldPath.documentId, whereIn: chunk).get();
      users.addAll(query.docs.map((doc) => UserModel.fromJson(doc.data())));
    }
    return users;
  }

  @override
  Future<void> updatePresence(String uid, bool isOnline) async {
    await _users.doc(uid).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  // Scalable check for "Is Following"
  Future<bool> isFollowing(String currentUid, String targetUid) async {
    final doc = await _socialGraph.doc('${currentUid}_$targetUid').get();
    return doc.exists;
  }
}
