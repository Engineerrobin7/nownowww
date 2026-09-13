import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

enum ConnectionStatus { online, offline }

@riverpod
class ConnectivityService extends _$ConnectivityService {
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  ConnectionStatus build() {
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        state = ConnectionStatus.offline;
      } else {
        state = ConnectionStatus.online;
      }
    });

    ref.onDispose(() {
      _subscription.cancel();
    });

    return ConnectionStatus.online;
  }
}

class ConnectionBanner extends ConsumerWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityServiceProvider);

    if (status == ConnectionStatus.online) return const SizedBox.shrink();

    return Material(
      child: Container(
        width: double.infinity,
        color: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: const Text(
          'No Internet Connection',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
