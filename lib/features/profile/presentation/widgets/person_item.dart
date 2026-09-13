import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/profile/domain/models/user_model.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import 'package:nownowww/shared/widgets/presence_avatar.dart';

class PersonItem extends ConsumerWidget {
  final UserModel user;

  const PersonItem({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserProvider)?.uid;
    final followingSet = ref.watch(currentUserFollowingProvider).valueOrNull ?? {};
    final isFollowing = followingSet.contains(user.uid);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Hero(
            tag: 'avatar_${user.uid}',
            child: PresenceAvatar(
              photoUrl: user.photoUrl,
              isOnline: user.isOnline,
              radius: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('@${user.username}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                Text(user.bio ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (currentUserId != user.uid)
            ElevatedButton(
              onPressed: () {
                if (currentUserId == null) return;
                if (isFollowing) {
                  ref.read(userRepositoryProvider).unfollowUser(currentUserId, user.uid);
                } else {
                  ref.read(userRepositoryProvider).followUser(currentUserId, user.uid);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowing ? Colors.white : Colors.black,
                foregroundColor: isFollowing ? Colors.black : Colors.white,
                minimumSize: const Size(70, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: isFollowing ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                elevation: 0,
              ),
              child: Text(isFollowing ? 'Following' : 'Follow', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
