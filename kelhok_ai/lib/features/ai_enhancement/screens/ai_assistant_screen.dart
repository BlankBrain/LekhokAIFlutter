// AI Assistant Screen for KarigorAI Premium Features
// Task 4.3.1: AI Enhancement Features Implementation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/advanced_glass_components.dart';
import '../../../shared/widgets/micro_interactions.dart';
import '../../../shared/widgets/advanced_loading_animations.dart';
import '../../../core/theme/app_theme.dart';

class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<ChatMessage> _chatMessages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeChat();
  }

  void _initializeChat() {
    _chatMessages.addAll([
      ChatMessage(
        text: "Hello! I'm your AI writing assistant. I can help you with story suggestions, character development, plot improvements, and writing techniques. What would you like to work on today?",
        isUser: false,
        timestamp: DateTime.now(),
        type: ChatMessageType.greeting,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Assistant',
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
            onPressed: _showAISettings,
            child: const Icon(Icons.settings, color: Colors.white),
          ),
          const SizedBox(width: 8),
          MicroInteractionButton(
            onPressed: _clearChat,
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Chat'),
            Tab(text: 'Suggestions'),
            Tab(text: 'Optimizer'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatTab(),
          _buildSuggestionsTab(),
          _buildOptimizerTab(),
          _buildInsightsTab(),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) => _buildChatMessage(_chatMessages[index]),
          ),
        ),
        if (_isLoading) _buildTypingIndicator(),
        _buildChatInput(),
      ],
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppTheme.primaryColor.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  if (message.suggestions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...message.suggestions.map((suggestion) => _buildSuggestionChip(suggestion)),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.accentColor,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: MicroInteractionButton(
        onPressed: () => _applySuggestion(suggestion),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppTheme.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  suggestion,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const TypingIndicatorAnimation(),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
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
              controller: _chatController,
              decoration: InputDecoration(
                hintText: 'Ask me anything about writing...',
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
              maxLines: null,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          MicroInteractionButton(
            onPressed: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                ),
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

  Widget _buildSuggestionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSuggestionCategory('Story Ideas', [
            'A time traveler accidentally prevents their own birth',
            'Two rival bakers discover they\'re using the same secret ingredient',
            'A library where books come alive after midnight',
            'A detective who can only solve crimes in their dreams',
          ]),
          const SizedBox(height: 24),
          _buildSuggestionCategory('Character Concepts', [
            'A reformed villain trying to lead a normal life',
            'A child who can communicate with technology',
            'An immortal being working as a museum curator',
            'A superhero whose power only works on Tuesdays',
          ]),
          const SizedBox(height: 24),
          _buildSuggestionCategory('Plot Twists', [
            'The mentor figure is actually the villain\'s creation',
            'The prophecy was written by the antagonist',
            'The magical item everyone seeks doesn\'t actually exist',
            'The protagonist has been dead since the beginning',
          ]),
          const SizedBox(height: 24),
          _buildSuggestionCategory('Writing Techniques', [
            'Try writing the same scene from three different perspectives',
            'Use only dialogue to advance the plot for one chapter',
            'Write a scene entirely through sensory descriptions',
            'Create tension by limiting your character\'s options',
          ]),
        ],
      ),
    );
  }

  Widget _buildSuggestionCategory(String title, List<String> suggestions) {
    return AdvancedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getCategoryIcon(title),
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...suggestions.map((suggestion) => _buildSuggestionItem(suggestion)),
            const SizedBox(height: 12),
            MicroInteractionButton(
              onPressed: () => _generateMoreSuggestions(title),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Generate More',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              suggestion,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          MicroInteractionButton(
            onPressed: () => _useSuggestion(suggestion),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.add,
                color: AppTheme.primaryColor,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildOptimizerCard(
            'Content Analysis',
            'Analyze your writing for readability, tone, and style',
            Icons.analytics,
            () => _showContentAnalysis(),
          ),
          const SizedBox(height: 16),
          _buildOptimizerCard(
            'Grammar & Style',
            'Get suggestions for grammar, punctuation, and style improvements',
            Icons.spellcheck,
            () => _showGrammarCheck(),
          ),
          const SizedBox(height: 16),
          _buildOptimizerCard(
            'Pacing Analysis',
            'Optimize the flow and pacing of your narrative',
            Icons.speed,
            () => _showPacingAnalysis(),
          ),
          const SizedBox(height: 16),
          _buildOptimizerCard(
            'Character Consistency',
            'Check for character development and consistency',
            Icons.people,
            () => _showCharacterConsistency(),
          ),
          const SizedBox(height: 16),
          _buildOptimizerCard(
            'Dialogue Enhancement',
            'Improve dialogue naturalness and character voice',
            Icons.chat_bubble,
            () => _showDialogueEnhancement(),
          ),
          const SizedBox(height: 16),
          _buildOptimizerCard(
            'Plot Structure',
            'Analyze and optimize your story structure',
            Icons.account_tree,
            () => _showPlotStructure(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizerCard(String title, String description, IconData icon, VoidCallback onTap) {
    return AdvancedGlassCard(
      child: MicroInteractionButton(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInsightCard(
            'Writing Patterns',
            'Your writing shows strong emotional depth and character development. Consider exploring more diverse genres to expand your range.',
            Icons.psychology,
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            'Strengths Analysis',
            'You excel at dialogue and character interactions. Your characters feel authentic and relatable.',
            Icons.star,
            const Color(0xFF2196F3),
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            'Growth Opportunities',
            'Try experimenting with different narrative structures. Non-linear storytelling could add depth to your work.',
            Icons.trending_up,
            const Color(0xFFFF9800),
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            'Reader Engagement',
            'Your stories have high engagement in the middle sections. Consider strengthening your openings and conclusions.',
            Icons.favorite,
            const Color(0xFFE91E63),
          ),
          const SizedBox(height: 24),
          _buildPersonalizedRecommendations(),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String insight, IconData icon, Color color) {
    return AdvancedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insight,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizedRecommendations() {
    return AdvancedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personalized Recommendations',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              'Writing Exercise',
              'Try the "Show, Don\'t Tell" challenge',
              'Rewrite a descriptive paragraph using only actions and dialogue',
              Icons.fitness_center,
            ),
            _buildRecommendationItem(
              'Character Development',
              'Create character relationship maps',
              'Visual mapping can reveal new story possibilities',
              Icons.account_tree,
            ),
            _buildRecommendationItem(
              'Genre Exploration',
              'Experiment with mystery elements',
              'Your character work would translate well to mystery plots',
              Icons.search,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String category, String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          MicroInteractionButton(
            onPressed: () => _applyRecommendation(title),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: AppTheme.primaryColor,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Story Ideas':
        return Icons.auto_stories;
      case 'Character Concepts':
        return Icons.people;
      case 'Plot Twists':
        return Icons.psychology;
      case 'Writing Techniques':
        return Icons.edit;
      default:
        return Icons.lightbulb;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: _chatController.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      type: ChatMessageType.user,
    );

    setState(() {
      _chatMessages.add(userMessage);
      _isLoading = true;
    });

    _chatController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      final aiResponse = _generateAIResponse(userMessage.text);
      setState(() {
        _chatMessages.add(aiResponse);
        _isLoading = false;
      });
      _scrollToBottom();
    });
  }

  ChatMessage _generateAIResponse(String userInput) {
    // Mock AI response generation based on user input
    String response;
    List<String> suggestions = [];

    if (userInput.toLowerCase().contains('character')) {
      response = "Great question about character development! Here are some techniques you can use to create more compelling characters:";
      suggestions = [
        "Give your character a contradictory trait",
        "Create a backstory that explains their motivation",
        "Use dialogue to reveal personality",
        "Show character growth through actions"
      ];
    } else if (userInput.toLowerCase().contains('plot')) {
      response = "Plot development is crucial for engaging storytelling. Here's how you can strengthen your plot:";
      suggestions = [
        "Start with conflict",
        "Use the three-act structure",
        "Create meaningful obstacles",
        "Build toward a satisfying resolution"
      ];
    } else if (userInput.toLowerCase().contains('dialogue')) {
      response = "Dialogue can make or break a story. Here are some tips for writing natural, engaging dialogue:";
      suggestions = [
        "Read dialogue aloud",
        "Give each character a unique voice",
        "Use subtext to add depth",
        "Keep it concise and purposeful"
      ];
    } else {
      response = "That's an interesting point! Here are some general writing tips that might help:";
      suggestions = [
        "Show, don't tell",
        "Write consistently every day",
        "Read widely in your genre",
        "Get feedback from other writers"
      ];
    }

    return ChatMessage(
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
      type: ChatMessageType.response,
      suggestions: suggestions,
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _applySuggestion(String suggestion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied suggestion: $suggestion'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _useSuggestion(String suggestion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Using suggestion: $suggestion'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _generateMoreSuggestions(String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating more $category suggestions...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showContentAnalysis() {
    _showFeatureComingSoon('Content Analysis');
  }

  void _showGrammarCheck() {
    _showFeatureComingSoon('Grammar & Style Check');
  }

  void _showPacingAnalysis() {
    _showFeatureComingSoon('Pacing Analysis');
  }

  void _showCharacterConsistency() {
    _showFeatureComingSoon('Character Consistency Check');
  }

  void _showDialogueEnhancement() {
    _showFeatureComingSoon('Dialogue Enhancement');
  }

  void _showPlotStructure() {
    _showFeatureComingSoon('Plot Structure Analysis');
  }

  void _applyRecommendation(String recommendation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applying recommendation: $recommendation'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showFeatureComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  void _showAISettings() {
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
                'AI Assistant Settings',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Suggestion Level', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Conservative', style: TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 16),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Response Style', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Detailed', style: TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 16),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Auto-suggestions', style: TextStyle(color: Colors.white)),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearChat() {
    setState(() {
      _chatMessages.clear();
      _initializeChat();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }
}

// Supporting Classes
enum ChatMessageType { greeting, user, response, suggestion }

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final ChatMessageType type;
  final List<String> suggestions;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.type,
    this.suggestions = const [],
  });
} 