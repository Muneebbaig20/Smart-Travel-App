import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/smart_provider.dart';
import '../../Model/place_model.dart';
import 'drawer_menu.dart';
import 'widgets/place_card.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/empty_state.dart';
import 'widgets/offline_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late AnimationController _headerAnimController;
  late Animation<double> _headerFadeAnim;

  @override
  void initState() {
    super.initState();
    _headerAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerFadeAnim = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerAnimController.forward();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<SmartProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SmartProvider>();
    final places = provider.places;
    final isDark = provider.isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Column(
          children: [
      
            FadeTransition(
              opacity: _headerFadeAnim,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    _buildGlassIconButton(
                      icon: Icons.menu_rounded,
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Explore Places',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    Stack(
                      children: [
                        _buildGlassIconButton(
                          icon: Icons.notifications_outlined,
                          onTap: () {
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '🔔 You have ${provider.favoritesCount} favorites!',
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          },
                        ),
                        if (provider.favoritesCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B6B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: provider.updateSearch,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search places...',
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: provider.hasSearchQuery ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 250),
                            child: GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                provider.clearSearch();
                              },
                              child: Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/search');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: PlaceFilter.values.map((filter) {
                  final isActive = provider.activeFilter == filter;
                  final label = filter == PlaceFilter.all
                      ? 'All'
                      : filter == PlaceFilter.favorites
                          ? 'Favorites'
                          : 'Recent';
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => provider.setFilter(filter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            
            Expanded(
              child: _buildContent(provider, places),
            ),
          ],
        ),
      ),

      
      bottomNavigationBar: const SmartBottomNav(),
    );
  }

  Widget _buildContent(SmartProvider provider, List<PlaceModel> places) {
    // Loading state
    if (provider.loadingState == LoadingState.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Discovering places...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (provider.loadingState == LoadingState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ),
            const SizedBox(height: 20),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: provider.loadPlaces,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Offline state banner + content
    if (provider.loadingState == LoadingState.offline && places.isEmpty) {
      return const OfflineState();
    }

    // Empty state
if (places.isEmpty) {
  return const SingleChildScrollView(
    child: EmptyState(),
  );
}

    // Success - show the list
    return Column(
      children: [
        // Offline banner
        if (provider.isOffline)
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, size: 18, color: Colors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Viewing cached data',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                GestureDetector(
                  onTap: provider.refresh,
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (provider.isOffline) const SizedBox(height: 12),

        // Place list
        Expanded(
          child: RefreshIndicator(
            onRefresh: provider.refresh,
            color: Theme.of(context).colorScheme.primary,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: places.length + (provider.isPaginating ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == places.length) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                }

                final place = places[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + (index * 80)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: PlaceCard(
                    place: place,
                    onTap: () {
                      provider.addToRecent(place);
                      Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: place,
                      );
                    },
                    onFavorite: () => provider.toggleFavorite(place),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}
