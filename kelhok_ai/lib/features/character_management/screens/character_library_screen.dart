import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../providers/character_providers.dart';
import '../models/character_models.dart';
import '../widgets/character_card.dart';
import 'character_creation_screen.dart';
import 'character_detail_screen.dart';

class CharacterLibraryScreen extends ConsumerStatefulWidget {
  const CharacterLibraryScreen({super.key});

  @override
  ConsumerState<CharacterLibraryScreen> createState() => _CharacterLibraryScreenState();
}

class _CharacterLibraryScreenState extends ConsumerState<CharacterLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedArchetype;
  bool _showFavoritesOnly = false;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(allCharactersProvider);
    final searchResults = ref.watch(characterSearchProvider(_searchQuery));

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildSearchAndFilters(),
              Expanded(
                child: charactersAsync.when(
                  data: (characters) {
                    final filteredCharacters = _filterCharacters(
                      _searchQuery.isEmpty ? characters : searchResults.asData?.value ?? [],
                    );
                    
                    if (filteredCharacters.isEmpty) {
                      return _buildEmptyState();
                    }
                    
                    return _isGridView 
                        ? _buildGridView(filteredCharacters)
                        : _buildListView(filteredCharacters);
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.karigorGold),
                    ),
                  ),
                  error: (error, stack) => _buildErrorState(error.toString()),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCharacterCreation(context),
        backgroundColor: AppColors.karigorGold,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'New Character',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Character Library',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final charactersAsync = ref.watch(allCharactersProvider);
                    return charactersAsync.when(
                      data: (characters) => Text(
                        '${characters.length} characters',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      loading: () => Text(
                        'Loading...',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: AppColors.primaryText,
            ),
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Column(
        children: [
          // Search Bar
          GlassmorphicContainer(
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
              ),
              decoration: InputDecoration(
                hintText: 'Search characters by name, description, or traits...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.secondaryText,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.secondaryText,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Favorites',
                  _showFavoritesOnly,
                  Icons.favorite,
                  () => setState(() => _showFavoritesOnly = !_showFavoritesOnly),
                ),
                
                const SizedBox(width: AppSizes.sm),
                
                _buildArchetypeFilter(),
                
                const SizedBox(width: AppSizes.sm),
                
                if (_selectedArchetype != null || _showFavoritesOnly)
                  _buildClearFiltersButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.karigorGold.withOpacity(0.2)
              : AppColors.glassBackground.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: isSelected 
                ? AppColors.karigorGold
                : AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected 
                  ? AppColors.karigorGold
                  : AppColors.secondaryText,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected 
                    ? AppColors.karigorGold
                    : AppColors.primaryText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchetypeFilter() {
    return PopupMenuButton<String>(
      onSelected: (archetype) => setState(() => _selectedArchetype = archetype),
      itemBuilder: (context) => PersonalityArchetype.values.map((archetype) => 
        PopupMenuItem(
          value: archetype.displayName,
          child: Text(
            archetype.displayName,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
        ),
      ).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: _selectedArchetype != null 
              ? AppColors.karigorGold.withOpacity(0.2)
              : AppColors.glassBackground.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: _selectedArchetype != null 
                ? AppColors.karigorGold
                : AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category,
              size: 16,
              color: _selectedArchetype != null 
                  ? AppColors.karigorGold
                  : AppColors.secondaryText,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              _selectedArchetype ?? 'Archetype',
              style: AppTextStyles.bodySmall.copyWith(
                color: _selectedArchetype != null 
                    ? AppColors.karigorGold
                    : AppColors.primaryText,
                fontWeight: _selectedArchetype != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: AppSizes.xs),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: _selectedArchetype != null 
                  ? AppColors.karigorGold
                  : AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearFiltersButton() {
    return GestureDetector(
      onTap: () => setState(() {
        _selectedArchetype = null;
        _showFavoritesOnly = false;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: AppColors.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.clear,
              size: 16,
              color: AppColors.error,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              'Clear Filters',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<Character> characters) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: AppSizes.md,
          mainAxisSpacing: AppSizes.md,
        ),
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];
          return CharacterCard(
            character: character,
            onTap: () => _navigateToCharacterDetail(context, character),
            onFavoriteToggle: () => _toggleFavorite(character),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<Character> characters) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.md),
          child: CharacterCard(
            character: character,
            isListView: true,
            onTap: () => _navigateToCharacterDetail(context, character),
            onFavoriteToggle: () => _toggleFavorite(character),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty || _selectedArchetype != null || _showFavoritesOnly) {
      return _buildNoResultsState();
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: AppColors.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'No Characters Yet',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Create your first character to get started',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.lg),
          ElevatedButton.icon(
            onPressed: () => _navigateToCharacterCreation(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Character'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.karigorGold,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'No Results Found',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Try adjusting your search or filters',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.lg),
          ElevatedButton.icon(
            onPressed: () => setState(() {
              _searchController.clear();
              _searchQuery = '';
              _selectedArchetype = null;
              _showFavoritesOnly = false;
            }),
            icon: const Icon(Icons.refresh),
            label: const Text('Clear All Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.karigorGold,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.error.withOpacity(0.5),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Something went wrong',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            error,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.lg),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(allCharactersProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.karigorGold,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<Character> _filterCharacters(List<Character> characters) {
    var filtered = characters;
    
    if (_showFavoritesOnly) {
      filtered = filtered.where((character) => character.isFavorite).toList();
    }
    
    if (_selectedArchetype != null) {
      filtered = filtered.where((character) => 
        character.personality.archetype?.displayName == _selectedArchetype
      ).toList();
    }
    
    return filtered;
  }

  Future<void> _navigateToCharacterCreation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CharacterCreationScreen(),
      ),
    );
    
    if (result != null) {
      // Refresh the character list
      ref.refresh(allCharactersProvider);
    }
  }

  Future<void> _navigateToCharacterDetail(BuildContext context, Character character) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterDetailScreen(character: character),
      ),
    );
    
    if (result != null) {
      // Refresh the character list
      ref.refresh(allCharactersProvider);
    }
  }

  Future<void> _toggleFavorite(Character character) async {
    final notifier = ref.read(characterManagementProvider.notifier);
    await notifier.toggleFavorite(character.id);
  }
} 
 