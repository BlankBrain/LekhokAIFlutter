import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_text_field.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _stories = [
    {
      'title': 'A brave cat story that changes everything',
      'character': 'Himu',
      'preview': 'Once upon a time in a magical kingdom, there lived a brave cat who had extraordinary powers...',
      'timeAgo': '2 hours ago',
      'isFavorite': true,
      'category': 'recent',
    },
    {
      'title': 'Adventure in the magical city',
      'character': 'Harry Potter',
      'preview': 'The young wizard found himself in a bustling magical city where every corner held new mysteries...',
      'timeAgo': 'Yesterday',
      'isFavorite': false,
      'category': 'recent',
    },
    {
      'title': 'The detective\'s greatest case',
      'character': 'Sherlock Holmes',
      'preview': 'In the foggy streets of London, the brilliant detective encountered his most challenging case yet...',
      'timeAgo': '3 days ago',
      'isFavorite': true,
      'category': 'favorites',
    },
    {
      'title': 'Wonder Woman saves the day',
      'character': 'Wonder Woman',
      'preview': 'With her golden lasso and unwavering courage, the Amazon warrior faced the ultimate threat...',
      'timeAgo': '1 week ago',
      'isFavorite': true,
      'category': 'favorites',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredStories {
    final currentTab = _tabController.index;
    final searchQuery = _searchController.text.toLowerCase();

    List<Map<String, dynamic>> filtered = _stories;

    // Filter by tab
    if (currentTab == 1) {
      // Favorites tab
      filtered = _stories.where((story) => story['isFavorite']).toList();
    } else if (currentTab == 2) {
      // Recent tab
      filtered = _stories.where((story) => story['category'] == 'recent').toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((story) =>
          story['title'].toLowerCase().contains(searchQuery) ||
          story['character'].toLowerCase().contains(searchQuery)).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'History',
          style: AppTextStyles.headingMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Search
            },
            icon: Icon(
              Icons.search,
              color: AppColors.primaryText,
            ),
          ),
          IconButton(
            onPressed: () {
              // More options
            },
            icon: Icon(
              Icons.more_vert,
              color: AppColors.primaryText,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.karigorGold,
          unselectedLabelColor: AppColors.quaternaryText,
          indicatorColor: AppColors.karigorGold,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Favorites'),
            Tab(text: 'Recent'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildStoriesList()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.all(AppSizes.md),
      child: KSearchField(
        controller: _searchController,
        hintText: AppStrings.searchStories,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildStoriesList() {
    final stories = _filteredStories;

    if (stories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_outlined,
              size: 64,
              color: AppColors.quaternaryText,
            ),
            SizedBox(height: AppSizes.md),
            Text(
              'No stories found',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.quaternaryText,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              'Start creating stories to see them here',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.quaternaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildStoryList(stories),
        _buildStoryList(stories),
        _buildStoryList(stories),
      ],
    );
  }

  Widget _buildStoryList(List<Map<String, dynamic>> stories) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.md),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.md),
          child: _buildStoryCard(story),
        );
      },
    );
  }

  Widget _buildStoryCard(Map<String, dynamic> story) {
    return KCard(
      onTap: () {
        _showStoryModal(story);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_stories,
                          size: 16,
                          color: AppColors.karigorGold,
                        ),
                        SizedBox(width: AppSizes.xs),
                        Expanded(
                          child: Text(
                            story['title'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (story['isFavorite'])
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: AppColors.karigorGold,
                          ),
                      ],
                    ),
                    SizedBox(height: AppSizes.xs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.karigorGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                      ),
                      child: Text(
                        'Generated with ${story['character']}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.karigorGold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            story['preview'],
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryText,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                story['timeAgo'],
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.quaternaryText,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Expand',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.karigorGold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: AppSizes.xs),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 16,
                    color: AppColors.karigorGold,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStoryModal(Map<String, dynamic> story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusLg),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.quaternaryText,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story['title'],
                        style: AppTextStyles.headingMedium,
                      ),
                      SizedBox(height: AppSizes.sm),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.karigorGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                        ),
                        child: Text(
                          'Generated with ${story['character']}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.karigorGold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.md),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Text(
                            '${story['preview']}\n\nThis is the full story content that would be displayed in the modal. The story continues with more details and adventures...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.md),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Share story
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.karigorGold,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.sm),
                          IconButton(
                            onPressed: () {
                              // Toggle favorite
                            },
                            icon: Icon(
                              story['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                              color: AppColors.karigorGold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Edit story
                            },
                            icon: Icon(
                              Icons.edit_outlined,
                              color: AppColors.quaternaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 