import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/text_parser_service.dart';

class ParsedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;

  const ParsedText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        children: TextParserService.parseText(
          text,
          baseStyle: style ?? Theme.of(context).textTheme.bodyMedium,
          linkStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
          onMentionTap: (username) {
            // In a real app, we'd look up the UID for the username
            // For now, navigate to search or profile placeholder
            context.push('/search', extra: username);
          },
          onTopicTap: (topic) {
            context.push('/search', extra: topic);
          },
        ),
      ),
    );
  }
}
