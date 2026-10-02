import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/profile/presentation/providers/block_providers.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import 'package:nownowww/shared/widgets/presence_avatar.dart';

class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedUidsAsync = ref.watch(blockedUsersProvider);
    final currentUserId = ref.watch(currentUserProvider)?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Blocked Users', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: blockedUidsAsync.when(
        data: (uids) {
          if (uids.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('No blocked users', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Users you block will appear here.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              final uid = uids[index];
              return _BlockedUserTile(uid: uid, currentUserId: currentUserId);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _BlockedUserTile extends ConsumerWidget {
  final String uid;
  final String? currentUserId;

  const _BlockedUserTile({required this.uid, required this.currentUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider(uid));

    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return ListTile(
          leading: PresenceAvatar(photoUrl: user.photoUrl, isOnline: user.isOnline, radius: 20),
          title: Text(user.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text('@${user.username}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          trailing: OutlinedButton(
            onPressed: currentUserId == null
                ? null
                : () async {
                    await ref.read(blockRepositoryProvider).unblockUser(currentUserId!, uid);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unblocked @${user.username}')),
                      );
                    }
                  },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Unblock', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
