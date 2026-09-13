import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';

part 'presence_controller.g.dart';

@riverpod
class PresenceController extends _$PresenceController with WidgetsBindingObserver {
  @override
  void build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    
    // Set online when first initialized
    _updatePresence(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updatePresence(true);
    } else {
      _updatePresence(false);
    }
  }

  Future<void> _updatePresence(bool isOnline) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    
    await ref.read(userRepositoryProvider).updatePresence(user.uid, isOnline);
  }
}
