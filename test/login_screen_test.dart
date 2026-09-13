import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nownowww/features/auth/presentation/screens/login_screen.dart';
import 'package:nownowww/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  testWidgets('LoginScreen has email and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Welcome to\nNOWNOWWW'), findsOneWidget);
    expect(find.byType(AuthTextField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
