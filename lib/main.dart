import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyWeatherDashApp(),
    ),
  );
}

class MyWeatherDashApp extends StatelessWidget {
  const MyWeatherDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'My Weather Dash',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Start directly at home screen - no white flash, no splash
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

