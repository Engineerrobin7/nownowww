import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:nownowww/features/posts/domain/models/post_model.dart';
import 'package:nownowww/shared/widgets/report_dialog.dart';
import 'package:nownowww/features/reports/domain/models/report_model.dart';
import 'package:nownowww/features/profile/presentation/providers/block_providers.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import 'package:nownowww/features/posts/presentation/providers/post_providers.dart';
import 'package:nownowww/shared/widgets/parsed_text.dart';
import 'package:nownowww/shared/widgets/animated_interactive_icon.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> with SingleTickerProviderStateMixin {
  bool _showHeartAnimation = false;

  void _handleDoubleTapLike(bool isLiked, String? currentUserId) {
    if (currentUserId == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _showHeartAnimation = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showHeartAnimation = false);
    });

    if (!isLiked) {
      ref.read(postRepositoryProvider).likePost(widget.post.id, currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final currentUserId = ref.watch(currentUserProvider)?.uid;
    final userLikes = ref.watch(currentUserLikesProvider).valueOrNull ?? {};
    final userBookmarks = ref.watch(currentUserBookmarksProvider).valueOrNull ?? {};
    final isLiked = userLikes.contains(post.id);
    final isBookmarked = userBookmarks.contains(post.id);

    return InkWell(
      onTap: () => context.push('/post/${post.id}'),
      onDoubleTap: () => _handleDoubleTapLike(isLiked, currentUserId),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: post.isAnonymous || post.uid == 'anonymous_user'
                          ? null
                          : () => context.push('/profile', extra: post.uid),
                      child: Hero(
                        tag: 'avatar_${post.id}',
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade100,
                          backgroundImage: post.authorPhotoUrl != null
                              ? CachedNetworkImageProvider(post.authorPhotoUrl!)
                              : null,
                          child: post.authorPhotoUrl == null
                              ? const Icon(Icons.person, size: 20, color: Colors.grey)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.authorName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getTimeAgo(post.createdAt),
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                              ),
                              const SizedBox(width: 8),
                              _buildTypePill(post.type),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '@${post.authorUsername}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    _PostOptionsMenu(post: post),
                  ],
                ),
                const SizedBox(height: 12),
                ParsedText(
                  text: post.content,
                  style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
                ),
                if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _showFullScreenImage(context, post.imageUrl!),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: post.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        placeholder: (context, url) => Container(
                          height: 180,
                          color: Colors.grey.shade100,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)),
                        ),
                        errorWidget: (context, url, error) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
                if (post.pollOptions != null && post.pollOptions!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _PollWidget(
                    postId: post.id,
                    options: post.pollOptions!,
                    votes: post.pollVotes ?? {},
                    currentUserId: currentUserId,
                  ),
                ],
                const SizedBox(height: 16),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 12),
                Row(
                  children: [
                    AnimatedInteractiveIcon(
                      icon: Icons.chat_bubble_outline,
                      activeIcon: Icons.chat_bubble,
                      isActive: false,
                      label: '${post.commentCount}',
                      onTap: () => context.push('/post/${post.id}'),
                    ),
                    const SizedBox(width: 16),
                    AnimatedInteractiveIcon(
                      icon: Icons.reply_outlined,
                      activeIcon: Icons.reply,
                      isActive: false,
                      label: '${post.shareCount}',
                      onTap: () {
                        final type = post.type == PostType.need ? 'NEEDS help with' : 'is THINKING about';
                        ref.read(postRepositoryProvider).incrementShareCount(post.id);
                        Share.share(
                          'Check out this post on NOWNOWWW!\n\n'
                          '${post.authorName} $type: "${post.content}"\n\n'
                          'Join the conversation: https://nownowww.page.link/post/${post.id}',
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    AnimatedInteractiveIcon(
                      icon: Icons.favorite_border,
                      activeIcon: Icons.favorite,
                      isActive: isLiked,
                      activeColor: Colors.red,
                      label: '${post.likesCount}',
                      onTap: () {
                        if (currentUserId == null) return;
                        if (isLiked) {
                          ref.read(postRepositoryProvider).unlikePost(post.id, currentUserId);
                        } else {
                          ref.read(postRepositoryProvider).likePost(post.id, currentUserId);
                        }
                      },
                    ),
                    const Spacer(),
                    AnimatedInteractiveIcon(
                      icon: Icons.bookmark_border,
                      activeIcon: Icons.bookmark,
                      isActive: isBookmarked,
                      activeColor: Colors.black,
                      label: '',
                      onTap: () {
                        if (currentUserId == null) return;
                        HapticFeedback.lightImpact();
                        if (isBookmarked) {
                          ref.read(postRepositoryProvider).unbookmarkPost(post.id, currentUserId);
                        } else {
                          ref.read(postRepositoryProvider).bookmarkPost(post.id, currentUserId);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.outlined_flag, size: 18, color: Colors.grey),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ReportDialog(
                            targetId: post.id,
                            targetType: ReportType.post,
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            if (_showHeartAnimation)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showHeartAnimation ? 1.0 : 0.0,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                  size: 70,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(imageUrl: url),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypePill(PostType type) {
    final isNeed = type == PostType.need;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isNeed ? Colors.green.withAlpha(20) : Colors.purple.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isNeed ? 'Need' : 'Think',
        style: TextStyle(
          color: isNeed ? Colors.green.shade700 : Colors.purple.shade700,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return DateFormat.Md().format(dateTime);
  }
}

class _PollWidget extends ConsumerWidget {
  final String postId;
  final List<String> options;
  final Map<String, int> votes;
  final String? currentUserId;

  const _PollWidget({
    required this.postId,
    required this.options,
    required this.votes,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalVotes = votes.length;
    final userVoteIndex = currentUserId != null ? votes[currentUserId] : null;

    return Column(
      children: List.generate(options.length, (index) {
        final optionText = options[index];
        final optionVotes = votes.values.where((v) => v == index).length;
        final percentage = totalVotes > 0 ? (optionVotes / totalVotes) : 0.0;
        final isSelected = userVoteIndex == index;

        return InkWell(
          onTap: currentUserId == null
              ? null
              : () {
                  ref.read(postRepositoryProvider).votePoll(postId, currentUserId!, index);
                },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 38,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        optionText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (totalVotes > 0)
                        Text(
                          '${(percentage * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _PostOptionsMenu extends ConsumerWidget {
  final PostModel post;

  const _PostOptionsMenu({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserProvider)?.uid;
    final userProfile = ref.watch(currentUserProfileProvider).valueOrNull;
    final isOwner = currentUserId == post.uid;
    final isAdmin = userProfile?.isAdmin ?? false;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onSelected: (value) async {
        if (value == 'report') {
          showDialog(
            context: context,
            builder: (context) => ReportDialog(
              targetId: post.id,
              targetType: ReportType.post,
            ),
          );
        } else if (value == 'block') {
          if (currentUserId != null) {
            HapticFeedback.heavyImpact();
            await ref.read(blockRepositoryProvider).blockUser(currentUserId, post.uid);
          }
        } else if (value == 'delete') {
          HapticFeedback.heavyImpact();
          ref.read(postRepositoryProvider).deletePost(post.id);
        }
      },
      itemBuilder: (context) => [
        if (!isOwner) ...[
          const PopupMenuItem(value: 'report', child: Text('Report Post')),
          const PopupMenuItem(value: 'block', child: Text('Block User')),
        ],
        if (isOwner || isAdmin)
          PopupMenuItem(
            value: 'delete',
            child: Text(
              isAdmin && !isOwner ? 'Admin: Delete Post' : 'Delete Post', 
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
