import 'package:flutter/material.dart';
import 'package:nownowww/features/comments/domain/models/comment_model.dart';
import 'package:nownowww/shared/widgets/parsed_text.dart';

class ReplyItem extends StatelessWidget {
  final ReplyModel reply;
  final bool isAuthor;

  const ReplyItem({
    super.key, 
    required this.reply,
    this.isAuthor = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.only(right: 16),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: reply.authorPhotoUrl != null ? NetworkImage(reply.authorPhotoUrl!) : null,
                    child: reply.authorPhotoUrl == null ? const Icon(Icons.person, size: 14, color: Colors.grey) : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(reply.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            if (isAuthor) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(color: Colors.blue.withAlpha(20), borderRadius: BorderRadius.circular(4)),
                                child: const Text('Author', style: TextStyle(color: Colors.blue, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ],
                            const SizedBox(width: 8),
                            const Text('55m ago', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        ParsedText(text: reply.content, style: const TextStyle(fontSize: 13, height: 1.4)),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Text('Reply', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                            Spacer(),
                            Icon(Icons.favorite_border, size: 12, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('2', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
