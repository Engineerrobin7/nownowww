import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationService {
  final INotificationRepository? repository;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  NotificationService({this.repository});

  Future<void> initialize(String uid) async {
    if (kIsWeb) return; // Standard FCM logic for mobile

    // Request permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get token
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToDatabase(uid, token);
      }
    }

    // Handle token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      _saveTokenToDatabase(uid, newToken);
    });
  }

  Future<void> _saveTokenToDatabase(String uid, String token) async {
    await _db.collection('devices').doc(uid).set({
      'tokens': FieldValue.arrayUnion([token]),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
