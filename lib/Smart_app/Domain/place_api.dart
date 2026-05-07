import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/place_model.dart';

class PlaceApi {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/photos';
  static const int _perPage = 20;

  /// Fetch places with pagination support
  static Future<List<PlaceModel>> fetchPlaces({int page = 1}) async {
    final start = (page - 1) * _perPage + 1;
    final url = '$_baseUrl?_start=$start&_limit=$_perPage';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PlaceModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load places: ${response.statusCode}');
    }
  }

  /// Search places by query
  static Future<List<PlaceModel>> searchPlaces(String query) async {
    final url = '$_baseUrl?_limit=50';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final places = data
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (query.isEmpty) return places;

      final q = query.toLowerCase();
      return places.where((place) {
        return place.name.toLowerCase().contains(q) ||
            place.location.toLowerCase().contains(q) ||
            place.title.toLowerCase().contains(q);
      }).toList();
    } else {
      throw Exception('Failed to search places: ${response.statusCode}');
    }
  }
}
