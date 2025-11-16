import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';
import '../widgets/gradient_button.dart';
import '../widgets/theme_toggle_button.dart';
import '../providers/theme_provider.dart';
import 'weather_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _indexController = TextEditingController(text: '194174B');
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _indexController.dispose();
    super.dispose();
  }

  void _showOfflineNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cloud_off, color: Colors.orange, size: 20),
            const SizedBox(width: 12),
            const Text('You\'re offline - showing cached data'),
          ],
        ),
        backgroundColor: const Color(0xFF2A2A3E),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final index = _indexController.text.trim();
      final weatherData = await WeatherService.fetchWeather(index);

      // Save to cache
      final coords = WeatherService.deriveCoordinates(index);
      final url =
          'https://api.open-meteo.com/v1/forecast?latitude=${coords['latitude']}&longitude=${coords['longitude']}&current_weather=true';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await StorageService.saveWeatherData(weatherData, response.body);
      }

      setState(() {
        _isLoading = false;
      });

      // Navigate to details screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherDetailsScreen(weatherData: weatherData),
          ),
        );
      }
    } catch (e) {
      // If offline, try to load cached data
      final cachedData = await StorageService.loadCachedData();

      setState(() {
        _isLoading = false;
      });

      if (cachedData != null) {
        // Show offline notification
        _showOfflineNotification();

        // Show cached data
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeatherDetailsScreen(weatherData: cachedData),
            ),
          );
        }
      } else {
        // No cached data available
        setState(() {
          _errorMessage = 'Failed to fetch weather. Check your internet connection.\nNo cached data available.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.gradientColors,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Icon
                    Icon(
                      Icons.wb_sunny,
                      size: 80,
                      color: const Color(0xFF6C63FF),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'My Weather Dash',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your student index',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeProvider.textColorWithOpacity(0.6),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Input Field
                    TextField(
                      controller: _indexController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeProvider.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g., 194174B',
                        hintStyle: TextStyle(color: themeProvider.hintTextColor),
                        filled: true,
                        fillColor: themeProvider.inputFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Search Button
                    GradientButton(
                      text: 'Search Weather',
                      icon: Icons.search,
                      onPressed: _fetchWeather,
                      isLoading: _isLoading,
                    ),

                    // Error Message
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red.shade200),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Theme Toggle Button - Top Right
              Positioned(
                top: 16,
                right: 16,
                child: const ThemeToggleButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
