import '../models/notification_model.dart';

abstract class INotificationRepository {
  Stream<List<NotificationModel>> watchNotifications(String uid);
  
  Future<void> markAsRead(String notificationId);
  
  Future<void> markAllAsRead(String uid);
  
  Future<void> deleteNotification(String notificationId);
  
  Future<void> saveDeviceToken(String uid, String token);
}
