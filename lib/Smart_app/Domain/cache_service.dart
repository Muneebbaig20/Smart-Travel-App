import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/place_model.dart';

class CacheService {
  static const String _placesKey = 'cached_places';
  static const String _favoritesKey = 'favorite_ids';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const Duration _cacheValidity = Duration(hours: 1);

 
  static Future<void> cachePlaces(List<PlaceModel> places) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = places.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList(_placesKey, jsonList);
    await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }


  static Future<List<PlaceModel>?> getCachedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_placesKey);

    if (jsonList == null || jsonList.isEmpty) return null;

 
    final timestamp = prefs.getInt(_cacheTimestampKey) ?? 0;
    final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cachedAt) > _cacheValidity) {
      return null; 
    }

    final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];

    return jsonList.map((jsonStr) {
      final place = PlaceModel.fromCacheJson(json.decode(jsonStr) as Map<String, dynamic>);
      place.isFavorite = favoriteIds.contains(place.id.toString());
      return place;
    }).toList();
  }

  /// Save favorite IDs
  static Future<void> saveFavorites(List<int> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favoritesKey,
      favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  /// Get favorite IDs
  static Future<List<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favoritesKey) ?? [];
    return ids.map((id) => int.parse(id)).toList();
  }

  
  static Future<bool> hasCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_placesKey);
    return jsonList != null && jsonList.isNotEmpty;
  }

  
  static Future<List<PlaceModel>?> getOfflineCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_placesKey);
    if (jsonList == null || jsonList.isEmpty) return null;

    final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];

    return jsonList.map((jsonStr) {
      final place = PlaceModel.fromCacheJson(json.decode(jsonStr) as Map<String, dynamic>);
      place.isFavorite = favoriteIds.contains(place.id.toString());
      return place;
    }).toList();
  }


  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_placesKey);
    await prefs.remove(_cacheTimestampKey);
  }
}
