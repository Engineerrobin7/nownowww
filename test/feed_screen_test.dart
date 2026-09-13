import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nownowww/features/posts/presentation/screens/feed_screen.dart';

void main() {
  testWidgets('FeedScreen shows loading state initially', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: FeedScreen(),
        ),
      ),
    );

    expect(find.text('No posts yet. Be the first to share something!'), findsOneWidget);
  });
}
