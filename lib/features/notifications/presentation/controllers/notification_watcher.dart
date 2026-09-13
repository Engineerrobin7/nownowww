import 'package:overlay_support/overlay_support.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import '../providers/notification_providers.dart';

part 'notification_watcher.g.dart';

@riverpod
class NotificationWatcher extends _$NotificationWatcher {
  @override
  void build() {
    // Watch for new notifications
    ref.listen(userNotificationsProvider, (previous, next) {
      if (previous == null || next.isLoading || next.hasError) return;
      
      final prevList = previous.value ?? [];
      final nextList = next.value ?? [];

      if (nextList.length > prevList.length) {
        final newNotification = nextList.first;
        if (!newNotification.isRead) {
          showSimpleNotification(
            Text(newNotification.senderName),
            subtitle: Text(newNotification.content),
            background: Colors.black,
            foreground: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    });
  }
}
