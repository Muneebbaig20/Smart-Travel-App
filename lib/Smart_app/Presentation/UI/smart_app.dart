import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Provider/smart_provider.dart';
import '../../Model/place_model.dart';
import 'home_screen.dart';
import 'detail_screen.dart';
import 'search_filter_screen.dart';
import 'map_screen.dart';

class SmartTravelApp extends StatelessWidget {
  const SmartTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SmartProvider()..loadPlaces(),
      child: Consumer<SmartProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Smart Travel',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(builder: (_) => const HomeScreen());
                case '/detail':
                  final place = settings.arguments as PlaceModel;
                  return PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    reverseTransitionDuration: const Duration(
                      milliseconds: 400,
                    ),
                    pageBuilder: (context, animation, secondary) {
                      return FadeTransition(
                        opacity: animation,
                        child: DetailScreen(place: place),
                      );
                    },
                  );
                case '/search':
                  return MaterialPageRoute(
                    builder: (_) => const SearchFilterScreen(),
                  );
                case '/map':
                  final place = settings.arguments as PlaceModel?;
                  if (place == null) {
                    return MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => MapScreen(place: place),
                  );
                default:
                  return MaterialPageRoute(builder: (_) => const HomeScreen());
              }
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    const primary = Color(0xFF6C63FF);
    const accent = Color(0xFFFF6B6B);
    const background = Color(0xFFF8FAFC);
    const surface = Colors.white;
    const onSurface = Color(0xFF1E293B);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        onSurface: onSurface,
      ),
      scaffoldBackgroundColor: background,
      cardColor: surface,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: CircleBorder(),
      ),
      iconTheme: const IconThemeData(color: onSurface),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFF94A3B8),
          fontSize: 14,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    const primary = Color(0xFF6C63FF);
    const accent = Color(0xFFFF6B6B);
    const background = Color(0xFF0F172A);
    const surface = Color(0xFF1E293B);
    const onSurface = Color(0xFFF1F5F9);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        onSurface: onSurface,
      ),
      scaffoldBackgroundColor: background,
      cardColor: surface,
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: onSurface, displayColor: onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: CircleBorder(),
      ),
      iconTheme: const IconThemeData(color: onSurface),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFF64748B),
          fontSize: 14,
        ),
      ),
    );
  }
}
