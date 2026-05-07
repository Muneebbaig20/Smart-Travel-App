import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/weather_model.dart';

class WeatherApi {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Fetch current weather for given coordinates
  static Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url =
        '$_baseUrl?latitude=$latitude&longitude=$longitude'
        '&current=temperature_2m,wind_speed_10m,weather_code'
        '&hourly=relative_humidity_2m,apparent_temperature'
        '&forecast_days=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to load weather: ${response.statusCode}');
    }
  }
}
