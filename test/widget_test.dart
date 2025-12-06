import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PurnimaApp());
    
    // Verify that the splash screen is displayed
    expect(find.text('Purnima'), findsOneWidget);
    expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
  });
}
