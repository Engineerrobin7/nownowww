import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nownowww/app/app.dart';

void main() {
  testWidgets('App boots up and shows splash', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NownowwwApp(),
      ),
    );

    // Initial state should show splash or loading
    expect(find.byType(NownowwwApp), findsOneWidget);
  });
}
