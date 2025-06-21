// Social Feed Screen for KarigorAI Premium Features
// Task 4.2.1: Social Features Implementation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/widgets/advanced_glass_components.dart';
import '../../../shared/widgets/micro_interactions.dart';
import '../../../shared/widgets/advanced_loading_animations.dart';
import '../../../core/theme/app_theme.dart';

class SocialFeedScreen extends ConsumerStatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'trending';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withOpacity(0.9),
                AppTheme.accentColor.withOpacity(0.9),
              ],
            ),
          ),
        ),
        actions: [
          MicroInteractionButton(
            onPressed: _showFilterDialog,
            child: const Icon(Icons.filter_list, color: Colors.white),
          ),
          const SizedBox(width: 8),
          MicroInteractionButton(
            onPressed: _navigateToCreatePost,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Trending'),
            Tab(text: 'Following'),
            Tab(text: 'My Posts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTrendingFeed(),
          _buildFollowingFeed(),
          _buildMyPostsFeed(),
        ],
      ),
      floatingActionButton: MorphingFAB(
        actions: [
          FABAction(
            icon: Icons.auto_stories,
            label: 'Share Story',
            onPressed: () => _shareContent('story'),
          ),
          FABAction(
            icon: Icons.image,
            label: 'Share Image',
            onPressed: () => _shareContent('image'),
          ),
          FABAction(
            icon: Icons.people,
            label: 'Share Character',
            onPressed: () => _shareContent('character'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingFeed() {
    return RefreshIndicator(
      onRefresh: _refreshFeed,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Mock data
        itemBuilder: (context, index) => _buildPostCard(index),
      ),
    );
  }

  Widget _buildFollowingFeed() {
    return RefreshIndicator(
      onRefresh: _refreshFeed,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Mock data
        itemBuilder: (context, index) => _buildPostCard(index, isFollowing: true),
      ),
    );
  }

  Widget _buildMyPostsFeed() {
    return RefreshIndicator(
      onRefresh: _refreshFeed,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // Mock data
        itemBuilder: (context, index) => _buildPostCard(index, isMyPost: true),
      ),
    );
  }

  Widget _buildPostCard(int index, {bool isFollowing = false, bool isMyPost = false}) {
    final mockData = _getMockPostData(index);
    
    return AdvancedGlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(mockData, isMyPost),
            const SizedBox(height: 12),
            _buildPostContent(mockData),
            const SizedBox(height: 12),
            _buildPostActions(mockData),
            if (mockData['comments'].isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildCommentsPreview(mockData['comments']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(Map<String, dynamic> post, bool isMyPost) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.primaryColor,
          child: Text(
            post['author'][0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post['author'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (post['isVerified']) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.verified,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                  ],
                ],
              ),
              Text(
                post['timestamp'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (isMyPost)
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white.withOpacity(0.7),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit Post'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Post'),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: Text('View Stats'),
              ),
            ],
            onSelected: (value) => _handlePostAction(value, post),
          ),
      ],
    );
  }

  Widget _buildPostContent(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post['title'] != null) ...[
          Text(
            post['title'],
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          post['content'],
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        if (post['image'] != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.3),
                    AppTheme.accentColor.withOpacity(0.3),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 64,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
        if (post['tags'].isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: post['tags'].map<Widget>((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildPostActions(Map<String, dynamic> post) {
    return Row(
      children: [
        MicroInteractionButton(
          onPressed: () => _toggleLike(post),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                color: post['isLiked'] ? Colors.red : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                post['likes'].toString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        MicroInteractionButton(
          onPressed: () => _showComments(post),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.comment_outlined,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                post['comments'].length.toString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        MicroInteractionButton(
          onPressed: () => _sharePost(post),
          child: const Icon(
            Icons.share_outlined,
            color: Colors.white70,
            size: 20,
          ),
        ),
        const Spacer(),
        MicroInteractionButton(
          onPressed: () => _bookmarkPost(post),
          child: Icon(
            post['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
            color: post['isBookmarked'] ? AppTheme.accentColor : Colors.white70,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsPreview(List<dynamic> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.white.withOpacity(0.2)),
        const SizedBox(height: 8),
        ...comments.take(2).map((comment) => _buildCommentItem(comment)),
        if (comments.length > 2)
          GestureDetector(
            onTap: () => _showAllComments(comments),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'View ${comments.length - 2} more comments',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            TextSpan(
              text: comment['author'] + ' ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: comment['text'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getMockPostData(int index) {
    final mockPosts = [
      {
        'id': '1',
        'author': 'Sarah Chen',
        'isVerified': true,
        'timestamp': '2 hours ago',
        'title': 'The Dragon\'s Last Song',
        'content': 'Just finished this epic fantasy piece! The dragon finally found peace after centuries of guarding the ancient treasure. Sometimes the most powerful magic is forgiveness.',
        'image': 'dragon_story.jpg',
        'tags': ['fantasy', 'dragon', 'epic', 'magic'],
        'likes': 47,
        'isLiked': false,
        'isBookmarked': true,
        'comments': [
          {'author': 'Mike', 'text': 'This gave me chills! Amazing world-building.'},
          {'author': 'Emma', 'text': 'The emotional depth is incredible.'},
          {'author': 'Alex', 'text': 'I need more stories in this universe!'},
        ],
      },
      {
        'id': '2',
        'author': 'David Park',
        'isVerified': false,
        'timestamp': '4 hours ago',
        'title': null,
        'content': 'Character spotlight: Meet Zara, the time-traveling historian who accidentally saves the wrong timeline. Her motto: "When in doubt, blame paradoxes."',
        'image': null,
        'tags': ['character', 'time-travel', 'sci-fi'],
        'likes': 23,
        'isLiked': true,
        'isBookmarked': false,
        'comments': [
          {'author': 'Lisa', 'text': 'Love the character concept!'},
        ],
      },
      {
        'id': '3',
        'author': 'Maria Rodriguez',
        'isVerified': true,
        'timestamp': '6 hours ago',
        'title': 'Writing Challenge Result',
        'content': 'Completed the 500-word flash fiction challenge! Theme was "unexpected friendship" and I wrote about a grumpy lighthouse keeper and a lost alien. Sometimes the shortest stories have the biggest hearts.',
        'image': 'lighthouse.jpg',
        'tags': ['challenge', 'flash-fiction', 'friendship'],
        'likes': 31,
        'isLiked': false,
        'isBookmarked': false,
        'comments': [
          {'author': 'Tom', 'text': 'Can\'t wait to read it!'},
          {'author': 'Ava', 'text': 'Lighthouse stories are my weakness 💙'},
        ],
      },
    ];
    
    return mockPosts[index % mockPosts.length];
  }

  Future<void> _refreshFeed() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {});
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedGlassCard(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Content',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterOption('trending', 'Trending', Icons.trending_up),
              _buildFilterOption('recent', 'Most Recent', Icons.access_time),
              _buildFilterOption('popular', 'Most Popular', Icons.star),
              _buildFilterOption('followed', 'From Followed Users', Icons.people),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() => _selectedFilter = value);
        Navigator.pop(context);
      },
      trailing: isSelected ? Icon(Icons.check, color: AppTheme.primaryColor) : null,
    );
  }

  void _navigateToCreatePost() {
    // Navigate to create post screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create post feature coming soon!'),
        backgroundColor: Color(0xFF2196F3),
      ),
    );
  }

  void _shareContent(String contentType) {
    // Handle different content sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share $contentType feature coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _toggleLike(Map<String, dynamic> post) {
    setState(() {
      post['isLiked'] = !post['isLiked'];
      post['likes'] += post['isLiked'] ? 1 : -1;
    });
  }

  void _showComments(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => AdvancedGlassCard(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Comments',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    MicroInteractionButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: post['comments'].length,
                  itemBuilder: (context, index) {
                    final comment = post['comments'][index];
                    return _buildDetailedCommentItem(comment);
                  },
                ),
              ),
              _buildCommentInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.accentColor,
            child: Text(
              comment['author'][0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['author'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comment['text'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '2h',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          MicroInteractionButton(
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sharePost(Map<String, dynamic> post) {
    Share.share(
      'Check out this amazing ${post['title'] ?? 'post'} on KarigorAI!\n\n${post['content']}',
      subject: post['title'],
    );
  }

  void _bookmarkPost(Map<String, dynamic> post) {
    setState(() {
      post['isBookmarked'] = !post['isBookmarked'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          post['isBookmarked'] ? 'Post bookmarked!' : 'Bookmark removed',
        ),
        backgroundColor: post['isBookmarked'] ? AppTheme.primaryColor : Colors.grey,
      ),
    );
  }

  void _showAllComments(List<dynamic> comments) {
    // Implementation to show all comments
  }

  void _handlePostAction(String action, Map<String, dynamic> post) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit post feature coming soon!')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(post);
        break;
      case 'stats':
        _showPostStats(post);
        break;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: AdvancedGlassCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Delete Post?',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: MicroInteractionButton(
                        onPressed: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MicroInteractionButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post deleted successfully'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPostStats(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedGlassCard(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post Statistics',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildStatRow('Views', '1,247'),
              _buildStatRow('Likes', post['likes'].toString()),
              _buildStatRow('Comments', post['comments'].length.toString()),
              _buildStatRow('Shares', '23'),
              _buildStatRow('Bookmarks', '67'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 