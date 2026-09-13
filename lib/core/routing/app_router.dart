import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/auth/presentation/screens/login_screen.dart';
import 'package:nownowww/features/auth/presentation/screens/signup_screen.dart';
import 'package:nownowww/features/auth/presentation/screens/login_email_screen.dart';
import 'package:nownowww/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:nownowww/features/auth/presentation/screens/legal_screen.dart';
import 'package:nownowww/features/posts/presentation/screens/create_post_screen.dart';
import 'package:nownowww/features/posts/presentation/screens/feed_screen.dart';
import 'package:nownowww/features/posts/presentation/screens/post_detail_screen.dart';
import 'package:nownowww/features/comments/domain/models/comment_model.dart';
import 'package:nownowww/features/comments/presentation/screens/comment_detail_screen.dart';
import 'package:nownowww/features/search/presentation/screens/search_screen.dart';
import 'package:nownowww/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:nownowww/features/profile/presentation/screens/profile_screen.dart';
import 'package:nownowww/features/profile/presentation/screens/profile_setup_screen.dart';
import 'package:nownowww/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:nownowww/features/profile/presentation/screens/user_list_screen.dart';
import 'package:nownowww/features/profile/domain/models/user_model.dart';
import 'package:nownowww/features/settings/presentation/screens/settings_screen.dart';
import 'package:nownowww/features/settings/presentation/screens/privacy_screen.dart';
import 'package:nownowww/features/home/presentation/screens/main_screen.dart';
import 'package:nownowww/features/home/presentation/screens/messages_screen.dart';
import 'package:nownowww/features/home/presentation/screens/chat_detail_screen.dart';
import 'package:nownowww/features/home/presentation/screens/onboarding_screen.dart';
import 'package:nownowww/features/home/presentation/screens/splash_screen.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  final profileState = ref.watch(currentUserProfileProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final hasProfile = profileState.valueOrNull != null;
      
      final isAuthRoute = state.matchedLocation == '/login' || 
                         state.matchedLocation == '/signup' || 
                         state.matchedLocation == '/login-email';
      final isSplash = state.matchedLocation == '/splash';
      final isProfileSetup = state.matchedLocation == '/profile-setup';

      if (authState.isLoading || (isLoggedIn && profileState.isLoading)) {
        return isSplash ? null : '/splash';
      }

      if (!isLoggedIn) {
        if (isAuthRoute) return null;
        return '/login';
      }

      if (!hasProfile) {
        if (isProfileSetup) return null;
        return '/profile-setup';
      }

      if (isAuthRoute || isSplash || isProfileSetup) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/login-email',
        builder: (context, state) => const LoginEmailScreen(),
      ),
      GoRoute(
        path: '/login-phone',
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const LegalScreen(
          title: 'Terms of Service',
          content: 'Welcome to NOWNOWWW. By using our platform, you agree to share authentically and respect other users. No spam, no harassment, and no illegal content is permitted. We reserve the right to remove any content that violates these simple principles...',
        ),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const LegalScreen(
          title: 'Privacy Policy',
          content: 'Your privacy is our priority. We only collect the data necessary to provide a social experience. Your email and phone are used for authentication. We do not sell your personal data to third parties. Our anonymous posting feature ensures your identity remains private when chosen...',
        ),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) {
              final query = state.extra as String?;
              return SearchScreen(initialQuery: query);
            },
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              final uid = state.extra as String?;
              return ProfileScreen(uid: uid);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/create-post',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CreatePostScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/privacy-settings',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) {
          final user = state.extra as UserModel;
          return EditProfileScreen(user: user);
        },
      ),
      GoRoute(
        path: '/user-list',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return UserListScreen(
            title: extra['title'] as String,
            uids: extra['uids'] as List<String>,
          );
        },
      ),
      GoRoute(
        path: '/post/:postId',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostDetailScreen(postId: postId);
        },
      ),
      GoRoute(
        path: '/comment-detail',
        builder: (context, state) {
          final comment = state.extra as CommentModel;
          return CommentDetailScreen(comment: comment);
        },
      ),
      GoRoute(
        path: '/chat-detail/:chatId',
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          final otherUser = state.extra as UserModel;
          return ChatDetailScreen(chatId: chatId, otherUser: otherUser);
        },
      ),
    ],
  );
}
