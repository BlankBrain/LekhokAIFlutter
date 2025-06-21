import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../models/character_models.dart';
import '../providers/character_providers.dart';

class CharacterSelector extends ConsumerStatefulWidget {
  final List<Character> selectedCharacters;
  final Function(List<Character>) onSelectionChanged;
  final int maxSelection;
  final bool allowMultiple;

  const CharacterSelector({
    super.key,
    required this.selectedCharacters,
    required this.onSelectionChanged,
    this.maxSelection = 5,
    this.allowMultiple = true,
  });

  @override
  ConsumerState<CharacterSelector> createState() => _CharacterSelectorState();
}

class _CharacterSelectorState extends ConsumerState<CharacterSelector> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedArchetype;
  bool _showFavoritesOnly = false;

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
    final charactersAsync = ref.watch(charactersProvider);

    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSizes.md),
          _buildSearchBar(),
          const SizedBox(height: AppSizes.sm),
          _buildFilters(),
          const SizedBox(height: AppSizes.md),
          _buildSelectedCharacters(),
          const SizedBox(height: AppSizes.md),
          Expanded(
            child: charactersAsync.when(
              data: (characters) {
                final filteredCharacters = _filterCharacters(characters);
                return _buildCharacterGrid(filteredCharacters);
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
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.people,
          color: AppColors.karigorGold,
          size: 24,
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Characters',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              Text(
                widget.allowMultiple 
                    ? 'Choose up to ${widget.maxSelection} characters for your story'
                    : 'Choose one character for your story',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        if (widget.selectedCharacters.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.karigorGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              '${widget.selectedCharacters.length}/${widget.maxSelection}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.karigorGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.primaryText,
      ),
      decoration: InputDecoration(
        hintText: 'Search characters...',
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide(color: AppColors.karigorGold),
        ),
        filled: true,
        fillColor: AppColors.glassBackground.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
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
              'Clear',
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

  Widget _buildSelectedCharacters() {
    if (widget.selectedCharacters.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.glassBackground.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.secondaryText,
              size: 20,
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              'No characters selected',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Characters:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: widget.selectedCharacters.map((character) => _buildSelectedCharacterChip(character)).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectedCharacterChip(Character character) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.karigorGold.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: AppColors.karigorGold,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.karigorGold.withOpacity(0.3),
            ),
            child: Center(
              child: Text(
                character.name[0].toUpperCase(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.karigorGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            character.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.karigorGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          GestureDetector(
            onTap: () => _removeCharacter(character),
            child: Icon(
              Icons.close,
              size: 16,
              color: AppColors.karigorGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrid(List<Character> characters) {
    if (characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: AppColors.secondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'No characters found',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        final isSelected = widget.selectedCharacters.any((c) => c.id == character.id);
        return _buildCharacterSelectCard(character, isSelected);
      },
    );
  }

  Widget _buildCharacterSelectCard(Character character, bool isSelected) {
    final canSelect = widget.allowMultiple 
        ? widget.selectedCharacters.length < widget.maxSelection || isSelected
        : !isSelected || widget.selectedCharacters.isEmpty;

    return GestureDetector(
      onTap: canSelect ? () => _toggleCharacter(character) : null,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.karigorGold.withOpacity(0.2)
              : AppColors.glassBackground.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: isSelected 
                ? AppColors.karigorGold
                : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.karigorGold.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Text(
                      character.name[0].toUpperCase(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.karigorGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.karigorGold,
                    size: 20,
                  )
                else if (!canSelect)
                  Icon(
                    Icons.block,
                    color: AppColors.secondaryText,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              character.name,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSizes.xs),
            if (character.personality.archetype != null)
              Text(
                character.personality.archetype!.displayName,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
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
            size: 48,
            color: AppColors.error.withOpacity(0.5),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Error loading characters',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            error,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Character> _filterCharacters(List<Character> characters) {
    var filtered = characters;
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((character) {
        return character.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            character.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            character.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }
    
    // Apply favorites filter
    if (_showFavoritesOnly) {
      filtered = filtered.where((character) => character.isFavorite).toList();
    }
    
    // Apply archetype filter
    if (_selectedArchetype != null) {
      filtered = filtered.where((character) => 
        character.personality.archetype?.displayName == _selectedArchetype
      ).toList();
    }
    
    return filtered;
  }

  void _toggleCharacter(Character character) {
    final currentSelection = List<Character>.from(widget.selectedCharacters);
    final isSelected = currentSelection.any((c) => c.id == character.id);
    
    if (isSelected) {
      currentSelection.removeWhere((c) => c.id == character.id);
    } else {
      if (widget.allowMultiple) {
        if (currentSelection.length < widget.maxSelection) {
          currentSelection.add(character);
        }
      } else {
        currentSelection.clear();
        currentSelection.add(character);
      }
    }
    
    widget.onSelectionChanged(currentSelection);
  }

  void _removeCharacter(Character character) {
    final currentSelection = List<Character>.from(widget.selectedCharacters);
    currentSelection.removeWhere((c) => c.id == character.id);
    widget.onSelectionChanged(currentSelection);
  }
}