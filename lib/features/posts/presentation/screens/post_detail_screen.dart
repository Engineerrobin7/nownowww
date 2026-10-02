import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import 'package:nownowww/features/comments/domain/models/comment_model.dart';
import 'package:nownowww/features/comments/presentation/providers/comment_providers.dart';
import 'package:nownowww/features/comments/presentation/widgets/comment_item.dart';
import 'package:nownowww/features/posts/presentation/providers/post_providers.dart';
import 'package:nownowww/shared/widgets/parsed_text.dart';
import 'package:nownowww/features/posts/domain/models/post_model.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final userProfile = ref.read(currentUserProfileProvider).valueOrNull;
      if (userProfile == null) return;

      final comment = CommentModel(
        id: const Uuid().v4(),
        postId: widget.postId,
        uid: userProfile.uid,
        authorName: userProfile.displayName,
        authorUsername: userProfile.username,
        authorPhotoUrl: userProfile.photoUrl,
        content: content,
        createdAt: DateTime.now(),
      );

      await ref.read(commentRepositoryProvider).addComment(comment);
      _commentController.clear();
      if (mounted) FocusScope.of(context).unfocus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(getPostProvider(widget.postId));
    final commentsAsync = ref.watch(postCommentsProvider(widget.postId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Post & Comments', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(getPostProvider(widget.postId));
                ref.invalidate(postCommentsProvider(widget.postId));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                children: [
                  postAsync.when(
                    data: (post) => post != null
                        ? _PostHeader(post: post)
                        : const Center(child: Text('Post not found')),
                    loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: Colors.black))),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                  commentsAsync.when(
                    data: (comments) {
                      final postAuthorId = postAsync.valueOrNull?.uid;
                      if (comments.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text('No comments yet. Be the first to reply!')),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) => CommentItem(
                          comment: comments[index],
                          postAuthorId: postAuthorId,
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        top: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Write a comment...',
                  border: InputBorder.none,
                  isDense: true,
                ),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _isSubmitting ? null : _submitComment,
            child: _isSubmitting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : const Text('Post', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends ConsumerWidget {
  final PostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserProvider)?.uid;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: post.authorPhotoUrl != null ? CachedNetworkImageProvider(post.authorPhotoUrl!) : null,
                child: post.authorPhotoUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(_getTimeAgo(post.createdAt), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 8),
                      Text(
                        post.type.name.toUpperCase(),
                        style: TextStyle(
                          color: post.type == PostType.need ? Colors.green.shade700 : Colors.purple.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ParsedText(text: post.content, style: const TextStyle(fontSize: 16, height: 1.5)),
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ],
          if (post.pollOptions != null && post.pollOptions!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...List.generate(post.pollOptions!.length, (index) {
              final optionText = post.pollOptions![index];
              final votes = post.pollVotes ?? {};
              final totalVotes = votes.length;
              final optionVotes = votes.values.where((v) => v == index).length;
              final percentage = totalVotes > 0 ? (optionVotes / totalVotes) : 0.0;
              final isSelected = currentUserId != null && votes[currentUserId] == index;

              return InkWell(
                onTap: currentUserId == null
                    ? null
                    : () {
                        ref.read(postRepositoryProvider).votePoll(post.id, currentUserId, index);
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
                            Text(optionText, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            const Spacer(),
                            if (totalVotes > 0)
                              Text('${(percentage * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text('${post.commentCount} Comments', style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(width: 24),
              const Icon(Icons.reply_outlined, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text('${post.shareCount} Shares', style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat.Md().format(dateTime);
  }
}
