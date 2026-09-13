import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:nownowww/features/comments/domain/models/comment_model.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import '../providers/comment_providers.dart';
import '../widgets/comment_item.dart';
import '../widgets/reply_item.dart';

class CommentDetailScreen extends ConsumerStatefulWidget {
  final CommentModel comment;

  const CommentDetailScreen({super.key, required this.comment});

  @override
  ConsumerState<CommentDetailScreen> createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends ConsumerState<CommentDetailScreen> {
  final _replyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _submitReply() async {
    final content = _replyController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final userProfile = ref.read(currentUserProfileProvider).valueOrNull;
      if (userProfile == null) return;

      final reply = ReplyModel(
        id: const Uuid().v4(),
        commentId: widget.comment.id,
        postId: widget.comment.postId,
        uid: userProfile.uid,
        authorName: userProfile.displayName,
        authorUsername: userProfile.username,
        authorPhotoUrl: userProfile.photoUrl,
        content: content,
        createdAt: DateTime.now(),
      );

      await ref.read(commentRepositoryProvider).addReply(reply);
      _replyController.clear();
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
    final repliesAsync = ref.watch(commentRepliesProvider(widget.comment.id));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Replies', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(commentRepliesProvider(widget.comment.id));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CommentItem(comment: widget.comment),
                  ),
                  const Divider(),
                  repliesAsync.when(
                    data: (replies) {
                      if (replies.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('No replies yet.'),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: replies.length,
                        itemBuilder: (context, index) => ReplyItem(reply: replies[index]),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16,
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
                      controller: _replyController,
                      decoration: const InputDecoration(
                        hintText: 'Add a reply...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isSubmitting ? null : _submitReply,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Icon(Icons.send, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
