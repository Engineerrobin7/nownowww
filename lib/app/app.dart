import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:nownowww/core/routing/app_router.dart';
import 'package:nownowww/core/theme/app_theme.dart';
import 'package:nownowww/core/services/connectivity_service.dart';
import 'package:nownowww/features/settings/presentation/providers/theme_providers.dart';

class NownowwwApp extends ConsumerWidget {
  const NownowwwApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final router = ref.watch(appRouterProvider);
      final themeMode = ref.watch(themeControllerProvider);

      return OverlaySupport.global(
        child: MaterialApp.router(
          title: 'NOWNOWWW',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
          builder: (context, child) {
            return Material(
              child: Column(
                children: [
                  const ConnectionBanner(),
                  Expanded(
                    child: UpgradeAlert(
                      // Using basic configuration to ensure compilation across versions
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } catch (e) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Configuration Error:\n$e\n\nPlease ensure Firebase is correctly set up.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      );
    }
  }
}
