import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextParserService {
  static final RegExp mentionRegex = RegExp(r'@([a-zA-Z0-9_]+)');
  static final RegExp topicRegex = RegExp(r'#([a-zA-Z0-9_]+)');

  static List<InlineSpan> parseText(
    String text, {
    required Function(String) onMentionTap,
    required Function(String) onTopicTap,
    TextStyle? baseStyle,
    TextStyle? linkStyle,
  }) {
    final List<InlineSpan> spans = [];
    
    // Combine both regexes to find all matches in order
    final combinedRegex = RegExp(r'(@[a-zA-Z0-9_]+)|(#[a-zA-Z0-9_]+)');
    
    int lastMatchEnd = 0;
    
    for (final match in combinedRegex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: baseStyle,
        ));
      }
      
      final matchText = match.group(0)!;
      final isMention = matchText.startsWith('@');
      
      spans.add(
        TextSpan(
          text: matchText,
          style: linkStyle ?? const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (isMention) {
                onMentionTap(matchText.substring(1));
              } else {
                onTopicTap(matchText.substring(1));
              }
            },
        ),
      );
      
      lastMatchEnd = match.end;
    }
    
    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: baseStyle,
      ));
    }
    
    return spans;
  }
}
