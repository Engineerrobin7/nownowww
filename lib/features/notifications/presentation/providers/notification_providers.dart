import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_notification_repository.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';
import '../services/notification_service.dart';

part 'notification_providers.g.dart';

@riverpod
INotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return FirestoreNotificationRepository();
}

@riverpod
Stream<List<NotificationModel>> userNotifications(UserNotificationsRef ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(notificationRepositoryProvider).watchNotifications(user.uid);
}

@riverpod
Future<void> initializeNotifications(InitializeNotificationsRef ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return;
  
  final service = NotificationService(
    repository: ref.watch(notificationRepositoryProvider),
  );
  await service.initialize(user.uid);
}
