import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/weather_data.dart';

class WeatherService {
  // Derive coordinates from student index
  static Map<String, double> deriveCoordinates(String index) {
    final numericPart = index.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericPart.length < 4) {
      throw Exception('Index must contain at least 4 digits');
    }

    final firstTwo = int.parse(numericPart.substring(0, 2));
    final nextTwo = int.parse(numericPart.substring(2, 4));
    final latitude = 5 + (firstTwo / 10.0);
    final longitude = 79 + (nextTwo / 10.0);

    return {'latitude': latitude, 'longitude': longitude};
  }

  // Fetch weather from API
  static Future<WeatherData> fetchWeather(String index) async {
    final coords = deriveCoordinates(index);
    final lat = coords['latitude']!;
    final lon = coords['longitude']!;

    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm:ss').format(now);

      return WeatherData.fromJson(jsonData, index, formattedTime, url);
    } else {
      throw Exception('API returned status code: ${response.statusCode}');
    }
  }
}

