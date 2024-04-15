import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_loc/main.dart'; // Import the main app widget

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // Create and start the app

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget); // Check if '0' is found on the screen
    expect(find.text('1'), findsNothing); // Check if '1' is not found on the screen

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add)); // Simulate tapping the '+' icon
    await tester.pump(); // Trigger a frame update

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing); // Check if '0' is not found anymore
    expect(find.text('1'), findsOneWidget); // Check if '1' is now found on the screen
  });
}
