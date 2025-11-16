import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';

class StorageService {
  static const String _weatherDataKey = 'last_weather_data';
  static const String _weatherIndexKey = 'last_weather_index';
  static const String _lastUpdatedKey = 'last_updated_time';
  static const String _apiUrlKey = 'last_api_url';

  // Save weather data to cache
  static Future<void> saveWeatherData(WeatherData weatherData, String jsonResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherDataKey, jsonResponse);
    await prefs.setString(_weatherIndexKey, weatherData.index);
    await prefs.setString(_lastUpdatedKey, weatherData.lastUpdated);
    await prefs.setString(_apiUrlKey, weatherData.apiUrl);
  }

  // Load cached weather data
  static Future<WeatherData?> loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_weatherDataKey);
      final cachedIndex = prefs.getString(_weatherIndexKey);
      final cachedTime = prefs.getString(_lastUpdatedKey);
      final cachedUrl = prefs.getString(_apiUrlKey);

      if (cachedData != null && cachedTime != null && cachedUrl != null && cachedIndex != null) {
        final jsonData = json.decode(cachedData);
        return WeatherData.fromJson(jsonData, cachedIndex, cachedTime, cachedUrl)
            .copyWith(isCached: true);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Clear cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherDataKey);
    await prefs.remove(_weatherIndexKey);
    await prefs.remove(_lastUpdatedKey);
    await prefs.remove(_apiUrlKey);
  }
}

