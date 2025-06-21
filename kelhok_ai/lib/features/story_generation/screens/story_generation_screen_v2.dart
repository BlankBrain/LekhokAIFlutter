import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_button.dart';
import '../../../shared/widgets/animations/loading_animations.dart';
import '../widgets/character_counter_widget.dart';
import '../widgets/content_preview_card.dart';
import '../../character_management/models/character_models.dart';
import '../../character_management/widgets/character_selector.dart';

class StoryGenerationScreenV2 extends ConsumerStatefulWidget {
  const StoryGenerationScreenV2({Key? key}) : super(key: key);

  @override
  ConsumerState<StoryGenerationScreenV2> createState() => _StoryGenerationScreenV2State();
}

class _StoryGenerationScreenV2State extends ConsumerState<StoryGenerationScreenV2>
    with TickerProviderStateMixin {
  final _storyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _refreshController = RefreshController(initialRefresh: false);
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isGenerating = false;
  String? _generatedStory;
  String? _imagePrompt;
  int _characterCount = 0;
  List<Character> _selectedCharacters = [];
  bool _showCharacterSelector = false;
  
  static const int _maxCharacters = 500;
  static const int _minCharacters = 10;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _storyController.addListener(_updateCharacterCount);
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppAnimations.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: AppAnimations.easeInOut,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _storyController.text.length;
    });
  }

  @override
  void dispose() {
    _storyController.removeListener(_updateCharacterCount);
    _storyController.dispose();
    _refreshController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Future<void> _generateStory() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isGenerating = true;
    });
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    try {
      // Simulate API call - replace with actual story generation logic
      await Future.delayed(const Duration(seconds: 3));
      
      setState(() {
        _generatedStory = "Once upon a time, ${_storyController.text}... This is a beautifully generated story that captures the essence of your prompt and brings it to life with vivid details and compelling narrative.";
        _imagePrompt = "A beautiful illustration of ${_storyController.text} in a fantasy art style";
        _isGenerating = false;
      });
      
      // Success haptic feedback
      HapticFeedback.heavyImpact();
      
    } catch (error) {
      setState(() {
        _isGenerating = false;
      });
      
      // Error haptic feedback
      HapticFeedback.heavyImpact();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate story: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                slivers: [
                  _buildGlassAppBar(),
                  SliverPadding(
                    padding: EdgeInsets.all(AppSizes.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeroSection(),
                        SizedBox(height: AppSizes.xl),
                        _buildInputSection(),
                        SizedBox(height: AppSizes.xl),
                        _buildCharacterSelection(),
                        SizedBox(height: AppSizes.xl),
                        _buildGenerateSection(),
                        if (_generatedStory != null) ...[
                          SizedBox(height: AppSizes.xl),
                          _buildResultSection(),
                        ],
                        SizedBox(height: AppSizes.xxl),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.glassBackground,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: AppSizes.md,
          bottom: AppSizes.md,
        ),
        title: Text(
          'Create Story',
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w900,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.technoNavy.withOpacity(0.1),
                AppColors.karigorGold.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.technoNavy,
            AppColors.technoNavy.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: AppSizes.glassShadowBlur,
            offset: const Offset(0, AppSizes.glassShadowOffset),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.karigorGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(
              Icons.auto_stories,
              size: 48,
              color: AppColors.karigorGold,
            ),
          ),
          SizedBox(height: AppSizes.md),
          Text(
            'AI Story Generator',
            style: AppTextStyles.headingMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            'Transform your ideas into amazing stories with AI-powered creativity',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return KCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: AppColors.karigorGold,
                  size: 24,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  'Story Idea',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Container(
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: _characterCount > _maxCharacters 
                      ? AppColors.error 
                      : AppColors.glassBorder,
                  width: 1,
                ),
              ),
              child: TextFormField(
                controller: _storyController,
                maxLines: 6,
                maxLength: _maxCharacters,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: AppStrings.enterStoryPrompt,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.quaternaryText,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(AppSizes.md),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a story idea';
                  }
                  if (value.trim().length < _minCharacters) {
                    return 'Story idea should be at least $_minCharacters characters long';
                  }
                  if (value.length > _maxCharacters) {
                    return 'Story idea should not exceed $_maxCharacters characters';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: AppSizes.sm),
            CharacterCounterWidget(
              currentCount: _characterCount,
              maxCount: _maxCharacters,
              minCount: _minCharacters,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterSelection() {
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people_outline,
                color: AppColors.karigorGold,
                size: 24,
              ),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  'Characters',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (_selectedCharacters.isNotEmpty)
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
                    '${_selectedCharacters.length} selected',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.karigorGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.md),
          
          // Character selection toggle button
          GestureDetector(
            onTap: () => setState(() => _showCharacterSelector = !_showCharacterSelector),
            child: Container(
              padding: EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.glassBackground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: _showCharacterSelector 
                      ? AppColors.karigorGold 
                      : AppColors.glassBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _selectedCharacters.isEmpty 
                        ? Icons.person_add_outlined 
                        : Icons.people,
                    color: _selectedCharacters.isEmpty 
                        ? AppColors.secondaryText 
                        : AppColors.karigorGold,
                    size: 24,
                  ),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCharacters.isEmpty 
                              ? 'Add Characters to Your Story'
                              : 'Characters Selected',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_selectedCharacters.isNotEmpty) ...[
                          SizedBox(height: AppSizes.xs),
                          Text(
                            _selectedCharacters.map((c) => c.name).join(', '),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.secondaryText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ] else ...[
                          SizedBox(height: AppSizes.xs),
                          Text(
                            'Optional: Select characters to include in your story',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _showCharacterSelector 
                        ? Icons.keyboard_arrow_up 
                        : Icons.keyboard_arrow_down,
                    color: AppColors.secondaryText,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          
          // Character selector panel
          AnimatedContainer(
            duration: AppAnimations.medium,
            height: _showCharacterSelector ? 400 : 0,
            child: _showCharacterSelector 
                ? Container(
                    margin: EdgeInsets.only(top: AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.glassBackground.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: AppColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      child: CharacterSelector(
                        selectedCharacters: _selectedCharacters,
                        onSelectionChanged: (characters) {
                          setState(() {
                            _selectedCharacters = characters;
                          });
                        },
                        maxSelection: 3,
                        allowMultiple: true,
                      ),
                    ),
                  )
                : null,
          ),
          
          // Selected characters display
          if (_selectedCharacters.isNotEmpty && !_showCharacterSelector) ...[
            SizedBox(height: AppSizes.md),
            Container(
              padding: EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.karigorGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(
                  color: AppColors.karigorGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Characters:',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.karigorGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSizes.sm),
                  Wrap(
                    spacing: AppSizes.sm,
                    runSpacing: AppSizes.sm,
                    children: _selectedCharacters.map((character) => _buildCharacterChip(character)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCharacterChip(Character character) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
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
            width: 20,
            height: 20,
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
                  fontSize: 10,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.xs),
          Text(
            character.name,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.karigorGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppSizes.xs),
          GestureDetector(
            onTap: () => _removeCharacter(character),
            child: Icon(
              Icons.close,
              size: 14,
              color: AppColors.karigorGold,
            ),
          ),
        ],
      ),
    );
  }

  void _removeCharacter(Character character) {
    setState(() {
      _selectedCharacters.removeWhere((c) => c.id == character.id);
    });
    HapticFeedback.lightImpact();
  }

  Widget _buildGenerateSection() {
    return KCard(
      child: Column(
        children: [
          if (_isGenerating) ...[
            SizedBox(
              height: 200,
              child: LoadingAnimations.storyGenerationLoader(
                message: 'Crafting your amazing story...',
                progress: null, // Can be updated with real progress
              ),
            ),
          ] else ...[
            KButton(
              onPressed: _generateStory,
              text: AppStrings.generateStory,
              icon: const Icon(Icons.auto_awesome),
              type: KButtonType.primary,
              size: KButtonSize.large,
              fullWidth: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    if (_generatedStory == null) return const SizedBox.shrink();
    
    return ContentPreviewCard(
      story: _generatedStory!,
      imagePrompt: _imagePrompt,
      onShare: () => _shareStory(),
      onCopy: () => _copyStory(),
      onFavorite: () => _toggleFavorite(),
    );
  }

  void _shareStory() {
    if (_generatedStory != null) {
      Share.share(
        _generatedStory!,
        subject: 'My AI Generated Story',
      );
    }
  }

  void _copyStory() {
    if (_generatedStory != null) {
      Clipboard.setData(ClipboardData(text: _generatedStory!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Story copied to clipboard'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleFavorite() {
    // Implement favorite functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to favorites'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 