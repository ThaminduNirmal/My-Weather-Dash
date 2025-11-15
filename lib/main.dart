import 'package:flutter/material.dart';

void main() {
  runApp(const MyWeatherDashApp());
}

class MyWeatherDashApp extends StatelessWidget {
  const MyWeatherDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Weather Dash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(title: 'My Weather Dashboard'),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key, required this.title});

  final String title;

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.wb_sunny,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to My Weather Dashboard',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            const Text(
              'Your weather information will appear here',
            ),
          ],
        ),
      ),
    );
  }
}
