import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_weather_dash/main.dart';

void main() {
  testWidgets('Weather Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyWeatherDashApp());

    // Verify that the app title is present
    expect(find.text('My Weather Dashboard'), findsOneWidget);

    // Verify that the weather icon is present
    expect(find.byIcon(Icons.wb_sunny), findsOneWidget);

    // Verify that the refresh button is present
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    // Wait for the weather data to load
    await tester.pumpAndSettle();

    // Verify that the weather info is displayed
    expect(find.text('Weather Dashboard Ready'), findsOneWidget);

    // Tap the refresh button
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Verify loading state
    expect(find.text('Loading weather data...'), findsOneWidget);

    // Wait for the refresh to complete
    await tester.pumpAndSettle();

    // Verify weather info is displayed again
    expect(find.text('Weather Dashboard Ready'), findsOneWidget);
  });

  testWidgets('MyWeatherDashApp has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWeatherDashApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'My Weather Dashboard');
  });
}
