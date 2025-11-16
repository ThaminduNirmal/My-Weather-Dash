import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';
import '../providers/theme_provider.dart';
import '../widgets/theme_toggle_button.dart';

class WeatherDetailsScreen extends StatefulWidget {
  final WeatherData weatherData;

  const WeatherDetailsScreen({
    super.key,
    required this.weatherData,
  });

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late WeatherData _currentWeatherData;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _currentWeatherData = widget.weatherData;
    _searchController.text = widget.weatherData.index;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchWeather() async {
    setState(() {
      _isSearching = true;
    });

    try {
      final index = _searchController.text.trim();
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
        _currentWeatherData = weatherData;
        _isSearching = false;
      });
    } catch (e) {
      // If offline, try to load cached data
      final cachedData = await StorageService.loadCachedData();

      setState(() {
        _isSearching = false;
      });

      if (cachedData != null) {
        setState(() {
          _currentWeatherData = cachedData;
        });
      } else {
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to fetch weather. No internet connection.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildSimpleCard({
    required String label,
    required String value,
    required IconData icon,
    required ThemeProvider themeProvider,
    bool isLarge = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6C63FF).withValues(alpha: 0.8),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.textColorWithOpacity(0.5),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isLarge ? 32 : 18,
                    fontWeight: isLarge ? FontWeight.bold : FontWeight.w600,
                    color: themeProvider.textColor,
                    letterSpacing: isLarge ? -0.5 : 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Compact metric tile with colored icon for the 2x2 grid
  Widget _metricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color accent,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      padding: const EdgeInsets.all(16), // increased for more space
      decoration: BoxDecoration(
        color: themeProvider.metricCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeProvider.borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.shadowColor,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: accent.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 50, // increased for better visibility
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.25),
                  accent.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: accent, size: 26), // increased icon size
          ),
          const SizedBox(height: 10), // slightly more spacing
          // Value (bold & larger)
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22, // increased +1 from 21
              fontWeight: FontWeight.w800,
              color: themeProvider.textColor,
              letterSpacing: -0.5,
              height: 1.1, // slightly more breathing room
            ),
          ),
          const SizedBox(height: 4), // more spacing between value and label
          // Label (not bold, medium visibility)
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12, // increased +2 from 10 for readability
              fontWeight: FontWeight.w500,
              color: themeProvider.textColorWithOpacity(0.75), // slightly brighter
              letterSpacing: 0.3,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: themeProvider.textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Weather Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                    const Spacer(),
                    if (_currentWeatherData.isCached)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Text(
                          'CACHED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    if (_currentWeatherData.isCached)
                      const SizedBox(width: 8),
                    const ThemeToggleButton(),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          color: themeProvider.textColor,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter student index',
                          hintStyle: TextStyle(color: themeProvider.hintTextColor),
                          filled: true,
                          fillColor: themeProvider.inputFieldColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6C63FF),
                            Color(0xFFFF6584),
                          ],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isSearching ? null : _searchWeather,
                          borderRadius: BorderRadius.circular(12),
                          child: Center(
                            child: _isSearching
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Last Updated - Small text at top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: themeProvider.textColorWithOpacity(0.4),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Updated ${_currentWeatherData.lastUpdated}',
                          style: TextStyle(
                            fontSize: 12,
                            color: themeProvider.textColorWithOpacity(0.4),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Student Index
                    _buildSimpleCard(
                      label: 'Student Index',
                      value: _currentWeatherData.index,
                      icon: Icons.badge,
                      themeProvider: themeProvider,
                    ),
                    const SizedBox(height: 12),

                    // 2x2 Grid for metrics (visible without scrolling)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const double tileHeight = 145; // increased for better readability
                        const double spacing = 12;
                        final double gridHeight = (tileHeight * 2) + spacing; // two rows + one spacing
                        final double tileWidth = (constraints.maxWidth - spacing) / 2; // two columns
                        final double aspectRatio = tileWidth / tileHeight;

                        return SizedBox(
                          height: gridHeight,
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            childAspectRatio: aspectRatio,
                            children: [
                              _metricTile(
                                label: 'Temperature',
                                value: '${_currentWeatherData.temperature.toStringAsFixed(1)}°C',
                                icon: Icons.thermostat,
                                accent: const Color(0xFFFFA726), // orange
                                themeProvider: themeProvider,
                              ),
                              _metricTile(
                                label: 'Coordinates',
                                value:
                                    '${_currentWeatherData.latitude.toStringAsFixed(2)}, ${_currentWeatherData.longitude.toStringAsFixed(2)}',
                                icon: Icons.my_location,
                                accent: const Color(0xFF42A5F5), // blue
                                themeProvider: themeProvider,
                              ),
                              _metricTile(
                                label: 'Wind Speed',
                                value: '${_currentWeatherData.windSpeed.toStringAsFixed(1)} km/h',
                                icon: Icons.air,
                                accent: const Color(0xFF26C6DA), // cyan
                                themeProvider: themeProvider,
                              ),
                              _metricTile(
                                label: 'Weather Code',
                                value: _currentWeatherData.weatherCode.toString(),
                                icon: Icons.cloud,
                                accent: const Color(0xFFAB47BC), // purple
                                themeProvider: themeProvider,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // API URL - Improved readability
                    Container(
                      padding: const EdgeInsets.all(18), // increased padding
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? Colors.white.withValues(alpha: 0.08) // increased opacity
                            : const Color(0xFF1A1A2E).withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: themeProvider.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.link, size: 14, color: themeProvider.textColorWithOpacity(0.6)), // increased size and opacity
                              const SizedBox(width: 8),
                              Text(
                                'API Request',
                                style: TextStyle(
                                  fontSize: 12, // increased from 10
                                  color: themeProvider.textColorWithOpacity(0.6), // increased opacity
                                  fontWeight: FontWeight.w600, // bolder
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10), // increased spacing
                          SelectableText( // made selectable for copy/paste
                            _currentWeatherData.apiUrl,
                            style: TextStyle(
                              fontSize: 11.5, // increased from 10
                              color: themeProvider.textColorWithOpacity(0.5), // increased opacity from 0.35
                              fontFamily: 'monospace',
                              height: 1.4, // line height for better readability
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
