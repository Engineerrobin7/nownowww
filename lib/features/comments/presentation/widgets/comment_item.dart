import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nownowww/features/comments/domain/models/comment_model.dart';
import 'package:nownowww/features/comments/presentation/providers/comment_providers.dart';
import 'package:nownowww/shared/widgets/parsed_text.dart';
import 'package:nownowww/features/comments/presentation/widgets/reply_item.dart';

class CommentItem extends ConsumerWidget {
  final CommentModel comment;
  final String? postAuthorId;

  const CommentItem({
    super.key,
    required this.comment,
    this.postAuthorId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesAsync = ref.watch(commentRepliesProvider(comment.id));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: comment.authorPhotoUrl != null ? NetworkImage(comment.authorPhotoUrl!) : null,
                child: comment.authorPhotoUrl == null ? const Icon(Icons.person, size: 18, color: Colors.grey) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(comment.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 8),
                        const Text('58m ago', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const Spacer(),
                        const Icon(Icons.more_horiz, size: 18, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ParsedText(text: comment.content, style: const TextStyle(fontSize: 14, height: 1.4)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => context.push('/comment-detail', extra: comment),
                          child: const Text('Reply', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        const Icon(Icons.favorite_border, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        const Text('5', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          repliesAsync.when(
            data: (replies) {
              if (replies.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 12.0),
                child: Column(
                  children: replies.map((reply) => ReplyItem(
                    reply: reply,
                    isAuthor: reply.uid == postAuthorId,
                  )).toList(),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
