import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/smart_provider.dart';

class SmartBottomNav extends StatelessWidget {
  const SmartBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SmartProvider>();
    final selectedIndex = provider.selectedNavIndex;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(provider.isDarkMode ? 0.3 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
            selectedIndex: selectedIndex,
            onTap: () {
              provider.setNavIndex(0);
              provider.setFilter(PlaceFilter.all);
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.search_rounded,
            label: 'Search',
            index: 1,
            selectedIndex: selectedIndex,
            onTap: () {
              provider.setNavIndex(1);
              Navigator.pushNamed(context, '/search');
            },
          ),

          // Center action button
          GestureDetector(
            onTap: () {
              provider.refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✨ Discovering new places...'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          _buildNavItem(
            context,
            icon: Icons.favorite_rounded,
            label: 'Favorites',
            index: 3,
            selectedIndex: selectedIndex,
            badge: provider.favoritesCount > 0
                ? provider.favoritesCount.toString()
                : null,
            onTap: () {
              provider.setNavIndex(3);
              provider.setFilter(PlaceFilter.favorites);
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.person_rounded,
            label: 'Profile',
            index: 4,
            selectedIndex: selectedIndex,
            onTap: () {
              provider.setNavIndex(4);
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
    String? badge,
  }) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .iconTheme
                            .color
                            ?.withOpacity(0.4),
                  ),
                ),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.4) ?? Colors.grey,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 20 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
