import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Comments', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz, color: Colors.black), onPressed: () {}),
        ],
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
                        Text('Top comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                          child: Center(child: Text('No comments yet.')),
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
            child: Text(
              'Post',
              style: TextStyle(
                color: _isSubmitting ? Colors.grey : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final PostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: 'avatar_${post.id}',
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: post.authorPhotoUrl != null ? NetworkImage(post.authorPhotoUrl!) : null,
                  child: post.authorPhotoUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Text('1h ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 8),
                      Text(post.type.name.toUpperCase(), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          ParsedText(text: post.content, style: const TextStyle(fontSize: 16, height: 1.5)),
          const SizedBox(height: 24),
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
}
