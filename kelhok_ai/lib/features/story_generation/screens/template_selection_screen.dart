import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/story_template_models.dart';
import '../services/story_template_service.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_button.dart';
import '../widgets/template_card.dart';
import '../widgets/template_category_chip.dart';
import '../widgets/genre_selector.dart';
import 'template_customization_screen.dart';

class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({super.key});

  @override
  State<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen>
    with TickerProviderStateMixin {
  late final StoryTemplateService _templateService;
  late final TabController _tabController;
  late final AnimationController _searchAnimationController;
  late final Animation<double> _searchAnimation;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<StoryTemplate> _templates = [];
  List<TemplateCategory> _categories = [];
  List<StoryGenre> _genres = [];
  List<StoryTemplate> _filteredTemplates = [];
  
  bool _isLoading = true;
  bool _isSearching = false;
  String _selectedCategory = 'all';
  String _selectedDifficulty = 'all';
  List<String> _selectedGenres = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _templateService = StoryTemplateService(ApiClient());
    _tabController = TabController(length: 3, vsync: this);
    _searchAnimationController = AnimationController(
      duration: AppConstants.animationDurationMedium,
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
    
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchAnimationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final results = await Future.wait([
        _templateService.getTemplates(),
        _templateService.getCategories(),
        _templateService.getGenres(),
      ]);

      _templates = results[0] as List<StoryTemplate>;
      _categories = results[1] as List<TemplateCategory>;
      _genres = results[2] as List<StoryGenre>;
      
      _applyFilters();
    } catch (e) {
      _showErrorSnackBar('Failed to load templates: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
    
    if (query.isNotEmpty) {
      _searchAnimationController.forward();
      _performSearch(query);
    } else {
      _searchAnimationController.reverse();
      _applyFilters();
    }
  }

  Future<void> _performSearch(String query) async {
    try {
      final searchResults = await _templateService.searchTemplates(query);
      setState(() {
        _filteredTemplates = searchResults;
      });
    } catch (e) {
      _showErrorSnackBar('Search failed: $e');
    }
  }

  void _applyFilters() {
    var filtered = List<StoryTemplate>.from(_templates);

    if (_selectedCategory != 'all') {
      filtered = filtered.where((t) => t.category == _selectedCategory).toList();
    }

    if (_selectedDifficulty != 'all') {
      filtered = filtered.where((t) => t.difficulty == _selectedDifficulty).toList();
    }

    if (_selectedGenres.isNotEmpty) {
      filtered = filtered
          .where((t) => t.genres.any((g) => _selectedGenres.contains(g)))
          .toList();
    }

    setState(() {
      _filteredTemplates = filtered;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
    HapticFeedback.selectionClick();
  }

  void _onDifficultySelected(String difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
    });
    _applyFilters();
    HapticFeedback.selectionClick();
  }

  void _onGenresSelected(List<String> genres) {
    setState(() {
      _selectedGenres = genres;
    });
    _applyFilters();
    HapticFeedback.selectionClick();
  }

  void _onTemplateSelected(StoryTemplate template) {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateCustomizationScreen(template: template),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          _buildSearchBar(),
          if (!_isSearching) ...[
            _buildCategoryFilter(),
            _buildAdvancedFilters(),
          ],
          _buildTemplateGrid(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Story Templates',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConstants.primaryColor.withOpacity(0.1),
                AppConstants.accentColor.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search templates...',
              prefixIcon: AnimatedBuilder(
                animation: _searchAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _searchAnimation.value * 0.5,
                    child: Icon(
                      Icons.search,
                      color: AppConstants.primaryColor,
                    ),
                  );
                },
              ),
              suffixIcon: _isSearching
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          itemCount: _categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return TemplateCategoryChip(
                label: 'All',
                isSelected: _selectedCategory == 'all',
                onTap: () => _onCategorySelected('all'),
              );
            }
            
            final category = _categories[index - 1];
            return TemplateCategoryChip(
              label: category.name,
              isSelected: _selectedCategory == category.id,
              onTap: () => _onCategorySelected(category.id),
              color: Color(int.parse('0xFF${category.colorHex.substring(1)}')),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        child: ExpansionTile(
          title: Text(
            'Advanced Filters',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            // Difficulty Filter
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Difficulty Level',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Wrap(
                    spacing: AppConstants.spacingSmall,
                    children: ['all', 'easy', 'medium', 'hard'].map((difficulty) {
                      return FilterChip(
                        label: Text(difficulty.toUpperCase()),
                        selected: _selectedDifficulty == difficulty,
                        onSelected: (_) => _onDifficultySelected(difficulty),
                        selectedColor: AppConstants.primaryColor.withOpacity(0.2),
                        checkmarkColor: AppConstants.primaryColor,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Genre Filter
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
              child: GenreSelector(
                genres: _genres,
                selectedGenres: _selectedGenres,
                onSelectionChanged: _onGenresSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateGrid() {
    if (_isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_filteredTemplates.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              Text(
                _isSearching ? 'No templates found' : 'No templates available',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                _isSearching 
                    ? 'Try adjusting your search terms'
                    : 'Check back later for new templates',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: AppConstants.spacingMedium,
          mainAxisSpacing: AppConstants.spacingMedium,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final template = _filteredTemplates[index];
            return TemplateCard(
              template: template,
              onTap: () => _onTemplateSelected(template),
            );
          },
          childCount: _filteredTemplates.length,
        ),
      ),
    );
  }
} 