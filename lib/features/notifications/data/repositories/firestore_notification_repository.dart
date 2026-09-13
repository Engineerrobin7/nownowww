import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nownowww/core/constants/firebase_constants.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';

class FirestoreNotificationRepository implements INotificationRepository {
  final FirebaseFirestore _firestore;

  FirestoreNotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection(FirebaseConstants.notificationsCollection);

  CollectionReference<Map<String, dynamic>> get _devices =>
      _firestore.collection(FirebaseConstants.devicesCollection);

  @override
  Stream<List<NotificationModel>> watchNotifications(String uid) {
    return _notifications
        .where('receiverId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _notifications.doc(notificationId).update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead(String uid) async {
    final batch = _firestore.batch();
    final unread = await _notifications
        .where('receiverId', isEqualTo: uid)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _notifications.doc(notificationId).delete();
  }

  @override
  Future<void> saveDeviceToken(String uid, String token) async {
    await _devices.doc(uid).set({
      'tokens': FieldValue.arrayUnion([token]),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
