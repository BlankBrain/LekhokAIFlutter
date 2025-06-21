import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/story_template_models.dart';
import '../../../core/constants/app_constants.dart';

class GenreSelector extends StatefulWidget {
  final List<StoryGenre> genres;
  final List<String> selectedGenres;
  final Function(List<String>) onSelectionChanged;
  final int maxSelections;
  final bool showSelectAll;

  const GenreSelector({
    super.key,
    required this.genres,
    required this.selectedGenres,
    required this.onSelectionChanged,
    this.maxSelections = 5,
    this.showSelectAll = true,
  });

  @override
  State<GenreSelector> createState() => _GenreSelectorState();
}

class _GenreSelectorState extends State<GenreSelector> {
  late List<String> _selectedGenres;

  @override
  void initState() {
    super.initState();
    _selectedGenres = List.from(widget.selectedGenres);
  }

  @override
  void didUpdateWidget(GenreSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGenres != widget.selectedGenres) {
      _selectedGenres = List.from(widget.selectedGenres);
    }
  }

  void _toggleGenre(String genreId) {
    setState(() {
      if (_selectedGenres.contains(genreId)) {
        _selectedGenres.remove(genreId);
      } else {
        if (_selectedGenres.length < widget.maxSelections) {
          _selectedGenres.add(genreId);
        } else {
          _showMaxSelectionSnackBar();
          return;
        }
      }
    });
    
    widget.onSelectionChanged(_selectedGenres);
    HapticFeedback.selectionClick();
  }

  void _selectAll() {
    setState(() {
      if (_selectedGenres.length == widget.genres.length) {
        _selectedGenres.clear();
      } else {
        _selectedGenres = widget.genres
            .take(widget.maxSelections)
            .map((g) => g.id)
            .toList();
      }
    });
    
    widget.onSelectionChanged(_selectedGenres);
    HapticFeedback.mediumImpact();
  }

  void _clearSelection() {
    setState(() {
      _selectedGenres.clear();
    });
    
    widget.onSelectionChanged(_selectedGenres);
    HapticFeedback.lightImpact();
  }

  void _showMaxSelectionSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Maximum ${widget.maxSelections} genres can be selected'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: AppSizes.sm),
        _buildGenreGrid(),
        if (_selectedGenres.isNotEmpty) ...[
          const SizedBox(height: AppSizes.sm),
          _buildSelectedGenres(),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Genres (${_selectedGenres.length}/${widget.maxSelections})',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            if (widget.showSelectAll)
              TextButton(
                onPressed: _selectAll,
                child: Text(
                  _selectedGenres.length == widget.genres.length 
                      ? 'Deselect All' 
                      : 'Select All',
                  style: const TextStyle(
                    color: AppColors.technoNavy,
                    fontSize: 12,
                  ),
                ),
              ),
            if (_selectedGenres.isNotEmpty)
              TextButton(
                onPressed: _clearSelection,
                child: Text(
                  'Clear',
                  style: const TextStyle(
                    color: AppColors.karigorGold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenreGrid() {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: widget.genres.map((genre) {
        final isSelected = _selectedGenres.contains(genre.id);
        final canSelect = isSelected || _selectedGenres.length < widget.maxSelections;
        
        return GestureDetector(
          onTap: canSelect ? () => _toggleGenre(genre.id) : null,
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Color(int.parse('0xFF${genre.colorHex.substring(1)}'))
                  : Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: isSelected 
                    ? Color(int.parse('0xFF${genre.colorHex.substring(1)}'))
                    : canSelect 
                        ? Colors.grey[300]!
                        : Colors.grey[200]!,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Color(int.parse('0xFF${genre.colorHex.substring(1)}')).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getGenreIcon(genre.iconName),
                  size: 16,
                  color: isSelected 
                      ? Colors.white 
                      : canSelect
                          ? Color(int.parse('0xFF${genre.colorHex.substring(1)}'))
                          : Colors.grey[400],
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  genre.name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected 
                        ? Colors.white 
                        : canSelect
                            ? AppColors.primaryText
                            : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectedGenres() {
    if (_selectedGenres.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.technoNavy.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: AppColors.technoNavy.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Genres:',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.technoNavy,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Wrap(
            spacing: AppSizes.xs,
            runSpacing: AppSizes.xs,
            children: _selectedGenres.map((genreId) {
              final genre = widget.genres.firstWhere((g) => g.id == genreId);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF${genre.colorHex.substring(1)}')).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getGenreIcon(genre.iconName),
                      size: 12,
                      color: Color(int.parse('0xFF${genre.colorHex.substring(1)}')),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      genre.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(int.parse('0xFF${genre.colorHex.substring(1)}')),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _toggleGenre(genreId),
                      child: Icon(
                        Icons.close,
                        size: 12,
                        color: Color(int.parse('0xFF${genre.colorHex.substring(1)}')),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getGenreIcon(String iconName) {
    switch (iconName) {
      case 'adventure':
        return Icons.explore;
      case 'heart':
        return Icons.favorite;
      case 'search':
        return Icons.search;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'rocket_launch':
        return Icons.rocket_launch;
      default:
        return Icons.category;
    }
  }
} 