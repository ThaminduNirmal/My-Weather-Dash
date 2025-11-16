// Weather data model
class WeatherData {
  final String index;
  final double latitude;
  final double longitude;
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String lastUpdated;
  final String apiUrl;
  final bool isCached;

  WeatherData({
    required this.index,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.lastUpdated,
    required this.apiUrl,
    this.isCached = false,
  });

  // Convert from JSON
  factory WeatherData.fromJson(
    Map<String, dynamic> json,
    String index,
    String time,
    String url,
  ) {
    final currentWeather = json['current_weather'];
    return WeatherData(
      index: index,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      temperature: currentWeather['temperature']?.toDouble() ?? 0.0,
      windSpeed: currentWeather['windspeed']?.toDouble() ?? 0.0,
      weatherCode: currentWeather['weathercode']?.toInt() ?? 0,
      lastUpdated: time,
      apiUrl: url,
    );
  }

  // Create a copy with cached flag
  WeatherData copyWith({bool? isCached}) {
    return WeatherData(
      index: index,
      latitude: latitude,
      longitude: longitude,
      temperature: temperature,
      windSpeed: windSpeed,
      weatherCode: weatherCode,
      lastUpdated: lastUpdated,
      apiUrl: apiUrl,
      isCached: isCached ?? this.isCached,
    );
  }
}

