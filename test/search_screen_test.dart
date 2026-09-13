import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nownowww/features/search/presentation/screens/search_screen.dart';

void main() {
  testWidgets('SearchScreen has tabs and search field', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SearchScreen(),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Topics'), findsOneWidget);
  });
}
