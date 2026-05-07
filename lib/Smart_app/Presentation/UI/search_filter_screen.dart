import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/smart_provider.dart';
import 'widgets/place_card.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<SmartProvider>();
    _searchController.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SmartProvider>();
    final filteredPlaces = provider.places;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: provider.updateSearch,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search places...',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (provider.hasActiveFilters)
                    GestureDetector(
                      onTap: () {
                        provider.clearFilters();
                        _searchController.clear();
                      },
                      child: Text(
                        'Clear All',
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

            const SizedBox(height: 20),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Sort By
                  _buildFilterDropdown(
                    context,
                    label: 'Sort By',
                    value: _sortByLabel(provider.sortBy),
                    items: SortBy.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(_sortByLabel(s)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) provider.setSortBy(value);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Show
                  _buildFilterDropdown(
                    context,
                    label: 'Show',
                    value: _filterLabel(provider.activeFilter),
                    items: PlaceFilter.values.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(_filterLabel(f)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) provider.setFilter(value);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Region
                  _buildRegionDropdown(context, provider),
                ],
              ),
            ),

            const SizedBox(height: 20),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Results',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filteredPlaces.length}',
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

            const SizedBox(height: 12),

           
            Expanded(
              child: filteredPlaces.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 72,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.25),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.5),
                                ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              provider.clearFilters();
                              _searchController.clear();
                            },
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = filteredPlaces[index];
                        return _buildCompactCard(context, provider, place);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(
    BuildContext context,
    SmartProvider provider,
    dynamic place,
  ) {
    return GestureDetector(
      onTap: () {
        provider.addToRecent(place);
        Navigator.pushNamed(context, '/detail', arguments: place);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                place.thumbnailImageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.image_rounded,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place.location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.6),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Favorite icon
            IconButton(
              onPressed: () => provider.toggleFavorite(place),
              icon: Icon(
                place.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: place.isFavorite
                    ? const Color(0xFFFF6B6B)
                    : Theme.of(context).iconTheme.color?.withOpacity(0.4),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown<T>(
    BuildContext context, {
    required String label,
    required String value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.12) ??
              Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
                ),
          ),
          const Spacer(),
          DropdownButton<T>(
            value: items.first.value,
            items: items,
            onChanged: onChanged,
            underline: const SizedBox.shrink(),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            dropdownColor: Theme.of(context).cardColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRegionDropdown(BuildContext context, SmartProvider provider) {
    final regions = provider.availableRegions;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.12) ??
              Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Text(
            'Region',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
                ),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: provider.regionFilter,
            items: regions.map((r) {
              return DropdownMenuItem(value: r, child: Text(r));
            }).toList(),
            onChanged: (value) {
              if (value != null) provider.setRegionFilter(value);
            },
            underline: const SizedBox.shrink(),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            dropdownColor: Theme.of(context).cardColor,
          ),
        ],
      ),
    );
  }

  String _sortByLabel(SortBy sort) {
    switch (sort) {
      case SortBy.nameAsc:
        return 'Name (A-Z)';
      case SortBy.nameDesc:
        return 'Name (Z-A)';
      case SortBy.locationAsc:
        return 'Location';
    }
  }

  String _filterLabel(PlaceFilter filter) {
    switch (filter) {
      case PlaceFilter.all:
        return 'All Places';
      case PlaceFilter.favorites:
        return 'Favorites Only';
      case PlaceFilter.recent:
        return 'Recently Viewed';
    }
  }
}
