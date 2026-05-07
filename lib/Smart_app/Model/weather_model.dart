class WeatherModel {
  final double temperature;
  final double windSpeed;
  final int humidity;
  final double feelsLike;
  final int weatherCode;

  WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ??
        json['current_weather'] as Map<String, dynamic>? ??
        {};
    final hourly = json['hourly'] as Map<String, dynamic>? ?? {};

    // Get humidity from hourly data (first entry) if available
    final humidityList = hourly['relative_humidity_2m'] as List<dynamic>?;
    final feelsLikeList = hourly['apparent_temperature'] as List<dynamic>?;

    return WeatherModel(
      temperature: (current['temperature_2m'] ?? current['temperature'] ?? 0).toDouble(),
      windSpeed: (current['wind_speed_10m'] ?? current['windspeed'] ?? 0).toDouble(),
      humidity: humidityList != null && humidityList.isNotEmpty
          ? (humidityList[0] as num).toInt()
          : 0,
      feelsLike: feelsLikeList != null && feelsLikeList.isNotEmpty
          ? (feelsLikeList[0] as num).toDouble()
          : (current['temperature_2m'] ?? current['temperature'] ?? 0).toDouble(),
      weatherCode: (current['weather_code'] ?? current['weathercode'] ?? 0).toInt(),
    );
  }

  String get weatherDescription {
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
        return 'Snowy';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 95:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }

  String get weatherIcon {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
      case 3:
        return '⛅';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return '🌧️';
      case 71:
      case 73:
      case 75:
        return '❄️';
      case 95:
        return '⛈️';
      default:
        return '🌤️';
    }
  }
}
