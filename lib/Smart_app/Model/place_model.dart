import 'dart:convert';

class PlaceModel {
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;
  bool isFavorite;

  // Derived fields for travel context
  String get name => _formatTitle(title);
  String get location => _locations[id % _locations.length];
  String get description => _descriptions[id % _descriptions.length];
  double get latitude => _coordinates[id % _coordinates.length]['lat']!;
  double get longitude => _coordinates[id % _coordinates.length]['lng']!;
  String get imageUrl =>
      'https://picsum.photos/seed/place$id/800/600';
  String get thumbnailImageUrl =>
      'https://picsum.photos/seed/place$id/400/300';

  PlaceModel({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    this.isFavorite = false,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as int,
      albumId: json['albumId'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'albumId': albumId,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'isFavorite': isFavorite,
    };
  }

  factory PlaceModel.fromCacheJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as int,
      albumId: json['albumId'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  static String _formatTitle(String raw) {
    if (raw.isEmpty) return raw;
    final words = raw.split(' ');
    return words
        .take(4)
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1)}'
            : w)
        .join(' ');
  }

  static const List<String> _locations = [
    'New Zealand',
    'Switzerland',
    'Norway',
    'Iceland',
    'Japan',
    'Canada',
    'Italy',
    'Greece',
    'Australia',
    'Peru',
    'Scotland',
    'Maldives',
    'Patagonia',
    'Nepal',
    'Portugal',
    'Croatia',
    'Tanzania',
    'Vietnam',
    'Morocco',
    'Bali, Indonesia',
  ];

  static const List<String> _descriptions = [
    'A breathtaking destination surrounded by crystal-clear waters and towering mountains. The landscape offers a perfect blend of serenity and adventure, making it ideal for both relaxation and exploration. Visitors often describe the sunrise here as one of the most magical experiences of their lives.',
    'Nestled in the heart of nature, this place offers stunning panoramic views of rolling hills and lush valleys. The local culture adds a unique charm that captivates every traveler. Ancient traditions blend seamlessly with modern hospitality to create an unforgettable experience.',
    'Known for its pristine beauty and unspoiled wilderness, this destination is a paradise for nature lovers and adventure seekers alike. Hiking trails wind through dense forests, leading to hidden waterfalls and secluded viewpoints that few tourists ever discover.',
    'A hidden gem featuring dramatic coastlines, ancient architecture, and vibrant local cuisine. The sunsets here paint the sky in shades of gold and crimson. Every corner tells a story of centuries past, from crumbling castles to perfectly preserved medieval streets.',
    'This enchanting locale boasts azure waters, white sandy beaches, and a rich cultural heritage that dates back centuries. Traditional fishing villages dot the coastline, offering authentic experiences and the freshest seafood you will ever taste.',
    'A remarkable destination where snow-capped peaks meet emerald green meadows, creating a picture-perfect landscape that inspires photographers and artists from around the world. The alpine air is crisp and invigorating, perfect for outdoor activities year-round.',
    'Famous for its dramatic fjords, colorful northern lights, and warm hospitality, this region offers experiences found nowhere else on Earth. The midnight sun in summer and aurora borealis in winter make every season special.',
    'An ancient land of temples, cherry blossoms, and cutting-edge innovation. The contrast between old and new creates a fascinating travel experience. Zen gardens provide peaceful retreats while bustling markets overflow with energy and flavor.',
    'A vast wilderness of red deserts, turquoise reefs, and unique wildlife. The stargazing opportunities here are unparalleled due to minimal light pollution. Aboriginal heritage adds deep cultural significance to every landscape.',
    'High-altitude ruins and misty mountain trails make this one of the most mystical travel destinations on the planet. Ancient civilizations left behind incredible stone architecture that continues to puzzle archaeologists today.',
    'Rugged highlands, mysterious lochs, and centuries-old castles define this majestic landscape. The ever-changing weather adds drama to the scenery, with rainbows frequently arching across brooding skies.',
    'Overwater bungalows, vibrant coral reefs, and the most incredible shades of blue define this tropical paradise. Each island offers a unique character, from lively resort destinations to completely private hideaways.',
    'Glaciers, granite spires, and pristine lakes form one of the most spectacular mountain landscapes on Earth. The wind-swept steppes give way to dense forests, home to pumas, condors, and guanacos.',
    'The roof of the world, where ancient monasteries cling to impossibly steep mountainsides. Prayer flags flutter in the thin mountain air, and the warmth of Sherpa hospitality makes every trekker feel welcome.',
    'Colorful coastal cities, world-class surf breaks, and pastéis de nata that melt in your mouth. The tile-covered buildings of old towns create Instagram-worthy scenes at every turn.',
    'A stunning Adriatic coast with medieval walled cities, thousand island archipelagos, and crystal waters perfect for sailing. The local wine and olive oil are among the Mediterranean finest.',
    'From the Serengeti to Kilimanjaro, this East African gem offers unparalleled wildlife encounters. The Great Migration is one of nature most awe-inspiring spectacles, with millions of animals crossing the plains.',
    'Emerald rice paddies, ancient temples, and bustling floating markets create a sensory feast. The cuisine is legendary, and the warmth of the people makes even first-time visitors feel at home.',
    'Labyrinthine medinas, golden desert dunes, and vibrant souks overflowing with spices and crafts. The blend of Arab, Berber, and French influences creates a culture unlike anywhere else.',
    'Terraced rice paddies, ancient Hindu temples, and world-class surfing await on this Island of the Gods. The spiritual energy is palpable, from dawn yoga sessions to elaborate temple ceremonies.',
  ];

  static const List<Map<String, double>> _coordinates = [
    {'lat': -44.0040, 'lng': 170.4730}, // Lake Tekapo, NZ
    {'lat': 46.8182, 'lng': 8.2275},    // Switzerland
    {'lat': 60.4720, 'lng': 8.4689},    // Norway
    {'lat': 64.9631, 'lng': -19.0208},  // Iceland
    {'lat': 36.2048, 'lng': 138.2529},  // Japan
    {'lat': 56.1304, 'lng': -106.3468}, // Canada
    {'lat': 41.8719, 'lng': 12.5674},   // Italy
    {'lat': 39.0742, 'lng': 21.8243},   // Greece
    {'lat': -25.2744, 'lng': 133.7751}, // Australia
    {'lat': -9.1900, 'lng': -75.0152},  // Peru
    {'lat': 56.4907, 'lng': -4.2026},   // Scotland
    {'lat': 3.2028, 'lng': 73.2207},    // Maldives
    {'lat': -50.3400, 'lng': -72.2646}, // Patagonia
    {'lat': 28.3949, 'lng': 84.1240},   // Nepal
    {'lat': 39.3999, 'lng': -8.2245},   // Portugal
    {'lat': 45.1000, 'lng': 15.2000},   // Croatia
    {'lat': -6.3690, 'lng': 34.8888},   // Tanzania
    {'lat': 14.0583, 'lng': 108.2772},  // Vietnam
    {'lat': 31.7917, 'lng': -7.0926},   // Morocco
    {'lat': -8.3405, 'lng': 115.0920},  // Bali
  ];
}
