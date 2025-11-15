import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_weather_dash/main.dart';

void main() {
  testWidgets('Weather dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyWeatherDashApp());

    // Verify that our welcome message is displayed.
    expect(find.text('Welcome to My Weather Dashboard'), findsOneWidget);
    expect(find.text('Your weather information will appear here'), findsOneWidget);
    
    // Verify the weather icon is present.
    expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
  });
}
