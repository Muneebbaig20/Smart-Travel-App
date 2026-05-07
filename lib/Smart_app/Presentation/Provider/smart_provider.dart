import 'dart:async';
import 'package:flutter/material.dart';
import '../../Domain/place_api.dart';
import '../../Domain/weather_api.dart';
import '../../Domain/cache_service.dart';
import '../../Model/place_model.dart';
import '../../Model/weather_model.dart';

enum LoadingState { initial, loading, loaded, error, offline }
enum PlaceFilter { all, favorites, recent }
enum SortBy { nameAsc, nameDesc, locationAsc }

class SmartProvider extends ChangeNotifier {
  
  List<PlaceModel> _allPlaces = [];
  List<PlaceModel> _recentlyViewed = [];
  String _searchQuery = '';
  PlaceFilter _activeFilter = PlaceFilter.all;
  SortBy _sortBy = SortBy.nameAsc;
  String _regionFilter = 'All';
  bool _darkMode = false;
  LoadingState _loadingState = LoadingState.initial;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isPaginating = false;
  bool _isOffline = false;
  int _selectedNavIndex = 0;

  // Weather cache
  final Map<int, WeatherModel> _weatherCache = {};
  final Map<int, LoadingState> _weatherLoadingStates = {};

  // Debounce timer
  Timer? _debounceTimer;

  
  List<PlaceModel> get places => _getFilteredPlaces();
  List<PlaceModel> get allPlaces => List.unmodifiable(_allPlaces);
  List<PlaceModel> get favoritePlaces =>
      List.unmodifiable(_allPlaces.where((p) => p.isFavorite));
  List<PlaceModel> get recentPlaces => List.unmodifiable(_recentlyViewed);

  String get searchQuery => _searchQuery;
  bool get hasSearchQuery => _searchQuery.isNotEmpty;
  PlaceFilter get activeFilter => _activeFilter;
  SortBy get sortBy => _sortBy;
  String get regionFilter => _regionFilter;
  bool get isDarkMode => _darkMode;
  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isPaginating => _isPaginating;
  bool get isOffline => _isOffline;
  int get selectedNavIndex => _selectedNavIndex;
  int get favoritesCount => _allPlaces.where((p) => p.isFavorite).length;

  List<String> get availableRegions {
    final regions = <String>{'All'};
    for (final place in _allPlaces) {
      regions.add(place.location);
    }
    return regions.toList()..sort();
  }


  Future<void> loadPlaces() async {
    _loadingState = LoadingState.loading;
    _currentPage = 1;
    notifyListeners();

    try {
      final places = await PlaceApi.fetchPlaces(page: 1);

      
      final favoriteIds = await CacheService.getFavoriteIds();
      for (final place in places) {
        place.isFavorite = favoriteIds.contains(place.id);
      }

      _allPlaces = places;
      _loadingState = LoadingState.loaded;
      _isOffline = false;
      _hasMore = places.length >= 20;

      
      await CacheService.cachePlaces(places);
    } catch (e) {
      
      final cached = await CacheService.getOfflineCache();
      if (cached != null && cached.isNotEmpty) {
        _allPlaces = cached;
        _loadingState = LoadingState.offline;
        _isOffline = true;
        _errorMessage = 'You are viewing cached data';
      } else {
        _loadingState = LoadingState.error;
        _errorMessage = 'Failed to load places. Please check your connection.';
      }
    }
    notifyListeners();
  }

  /// Load next page
  Future<void> loadMore() async {
    if (_isPaginating || !_hasMore) return;
    _isPaginating = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final newPlaces = await PlaceApi.fetchPlaces(page: nextPage);

      // Restore favorites
      final favoriteIds = await CacheService.getFavoriteIds();
      for (final place in newPlaces) {
        place.isFavorite = favoriteIds.contains(place.id);
      }

      _allPlaces.addAll(newPlaces);
      _currentPage = nextPage;
      _hasMore = newPlaces.length >= 20;

      // Update cache
      await CacheService.cachePlaces(_allPlaces);
    } catch (e) {
      // Silently fail pagination
    }
    _isPaginating = false;
    notifyListeners();
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadPlaces();
  }

  
  WeatherModel? getWeather(int placeId) => _weatherCache[placeId];
  LoadingState getWeatherState(int placeId) =>
      _weatherLoadingStates[placeId] ?? LoadingState.initial;

  Future<void> fetchWeather(PlaceModel place) async {
    if (_weatherCache.containsKey(place.id)) return;

    _weatherLoadingStates[place.id] = LoadingState.loading;
    notifyListeners();

    try {
      final weather = await WeatherApi.fetchWeather(
        latitude: place.latitude,
        longitude: place.longitude,
      );
      _weatherCache[place.id] = weather;
      _weatherLoadingStates[place.id] = LoadingState.loaded;
    } catch (e) {
      _weatherLoadingStates[place.id] = LoadingState.error;
    }
    notifyListeners();
  }

  
  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();

    // Debounce heavy operations
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      notifyListeners();
    });
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  
  void setFilter(PlaceFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void setSortBy(SortBy sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void setRegionFilter(String region) {
    _regionFilter = region;
    notifyListeners();
  }

  void clearFilters() {
    _activeFilter = PlaceFilter.all;
    _sortBy = SortBy.nameAsc;
    _regionFilter = 'All';
    _searchQuery = '';
    notifyListeners();
  }

  bool get hasActiveFilters =>
      _activeFilter != PlaceFilter.all ||
      _sortBy != SortBy.nameAsc ||
      _regionFilter != 'All' ||
      _searchQuery.isNotEmpty;

  
  void toggleFavorite(PlaceModel place) {
    place.isFavorite = !place.isFavorite;
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final ids = _allPlaces.where((p) => p.isFavorite).map((p) => p.id).toList();
    await CacheService.saveFavorites(ids);
  }

  
  void addToRecent(PlaceModel place) {
    _recentlyViewed.removeWhere((p) => p.id == place.id);
    _recentlyViewed.insert(0, place);
    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.sublist(0, 10);
    }
    notifyListeners();
  }

  
  void toggleTheme() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  
  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  
  List<PlaceModel> _getFilteredPlaces() {
    List<PlaceModel> result;

    // Apply category filter
    switch (_activeFilter) {
      case PlaceFilter.all:
        result = List.from(_allPlaces);
        break;
      case PlaceFilter.favorites:
        result = _allPlaces.where((p) => p.isFavorite).toList();
        break;
      case PlaceFilter.recent:
        result = List.from(_recentlyViewed);
        break;
    }

    // Apply region filter
    if (_regionFilter != 'All') {
      result = result.where((p) => p.location == _regionFilter).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q) ||
            p.title.toLowerCase().contains(q);
      }).toList();
    }

    // Apply sort
    switch (_sortBy) {
      case SortBy.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortBy.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortBy.locationAsc:
        result.sort((a, b) => a.location.compareTo(b.location));
        break;
    }

    return result;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
