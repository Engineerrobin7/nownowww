// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRepositoryHash() =>
    r'2254553207211732acd261fcc9972f50ff487ac6';

/// See also [notificationRepository].
@ProviderFor(notificationRepository)
final notificationRepositoryProvider =
    AutoDisposeProvider<INotificationRepository>.internal(
  notificationRepository,
  name: r'notificationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationRepositoryRef
    = AutoDisposeProviderRef<INotificationRepository>;
String _$userNotificationsHash() => r'3d7d6f24d185eaf4c730253ffaf77ea39f390d8e';

/// See also [userNotifications].
@ProviderFor(userNotifications)
final userNotificationsProvider =
    AutoDisposeStreamProvider<List<NotificationModel>>.internal(
  userNotifications,
  name: r'userNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserNotificationsRef
    = AutoDisposeStreamProviderRef<List<NotificationModel>>;
String _$initializeNotificationsHash() =>
    r'5847f623718aa774b995067634ea11b7a45084a1';

/// See also [initializeNotifications].
@ProviderFor(initializeNotifications)
final initializeNotificationsProvider =
    AutoDisposeFutureProvider<void>.internal(
  initializeNotifications,
  name: r'initializeNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initializeNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InitializeNotificationsRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
