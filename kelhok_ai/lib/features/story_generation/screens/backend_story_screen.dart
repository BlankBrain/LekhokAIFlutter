import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../../../core/constants/app_constants.dart';
import '../providers/backend_story_provider.dart';
import '../services/backend_story_service.dart';

class BackendStoryScreen extends ConsumerStatefulWidget {
  const BackendStoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BackendStoryScreen> createState() => _BackendStoryScreenState();
}

class _BackendStoryScreenState extends ConsumerState<BackendStoryScreen>
    with TickerProviderStateMixin {
  final _storyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  
  // Animations
  late Animation<double> _backgroundAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Gentle background gradient animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    // Content fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  void _startAnimations() {
    _backgroundController.repeat();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fadeController.forward();
    });
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  Future<void> _generateStory() async {
    if (!_formKey.currentState!.validate()) return;
    
    final selectedCharacter = ref.read(selectedCharacterProvider);
    final storyNotifier = ref.read(backendStoryProvider.notifier);
    
    await storyNotifier.generateStory(
      storyIdea: _storyController.text.trim(),
      characterId: selectedCharacter?.id,
    );
  }

  void _copyStory(String story) {
    Clipboard.setData(ClipboardData(text: story));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Story copied to clipboard'),
        backgroundColor: AppColors.success.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }

  void _shareStory(String story) {
    Share.share(story, subject: 'Generated Story from KarigorAI');
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_backgroundAnimation.value * 0.3 * math.pi),
              colors: [
                const Color(0xFFFF9A8B).withOpacity(0.4), // Softer coral
                const Color(0xFFFEAD5E).withOpacity(0.5), // Softer orange
                const Color(0xFFE6A426).withOpacity(0.6), // Karigor gold
                const Color(0xFF22345C).withOpacity(0.8), // Techno navy
                const Color(0xFF667EEA).withOpacity(0.5), // Soft purple
              ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsets? margin}) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(AppSizes.lg),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.technoNavy,
            fontFamily: 'SF Pro Text',
          ),
        ),
        SizedBox(height: AppSizes.sm),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  validator: validator,
                  style: TextStyle(
                    color: AppColors.technoNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: AppColors.technoNavy.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(AppSizes.md),
                    errorStyle: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassDropdown({
    required String label,
    required BackendCharacter? value,
    required List<BackendCharacter> characters,
    required void Function(BackendCharacter?) onChanged,
    required bool isLoading,
    String? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.technoNavy,
            fontFamily: 'SF Pro Text',
          ),
        ),
        SizedBox(height: AppSizes.sm),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: isLoading
                  ? Padding(
                      padding: EdgeInsets.all(AppSizes.md),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.technoNavy),
                            ),
                          ),
                          SizedBox(width: AppSizes.sm),
                          Text(
                            'Loading characters...',
                            style: TextStyle(
                              color: AppColors.technoNavy.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : error != null
                    ? Padding(
                        padding: EdgeInsets.all(AppSizes.md),
                        child: Text(
                          'Error: $error',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : DropdownButtonFormField<BackendCharacter>(
                        value: value,
                        decoration: InputDecoration(
                          hintText: 'Choose a character',
                          hintStyle: TextStyle(
                            color: AppColors.technoNavy.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(AppSizes.md),
                        ),
                        style: TextStyle(
                          color: AppColors.technoNavy,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        dropdownColor: Colors.white.withOpacity(0.95),
                        items: [
                          if (characters.any((c) => c.name.toLowerCase() != 'himu'))
                            DropdownMenuItem<BackendCharacter>(
                              value: null,
                              child: Text('No character'),
                            ),
                          ...characters.map((character) => 
                            DropdownMenuItem<BackendCharacter>(
                              value: character,
                              child: Text('${character.name} (${character.usageCount} uses)'),
                            ),
                          ),
                        ],
                        onChanged: onChanged,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isPrimary = true,
  }) {
    return Container(
      width: double.infinity,
      height: AppSizes.buttonHeightLg,
      decoration: BoxDecoration(
        gradient: onPressed == null
          ? LinearGradient(
              colors: [Colors.grey.withOpacity(0.5), Colors.grey.withOpacity(0.3)],
            )
          : isPrimary
            ? LinearGradient(
                colors: [
                  AppColors.karigorGold,
                  AppColors.karigorGold.withOpacity(0.9),
                  AppColors.karigorGold.withOpacity(0.8),
                ],
              )
            : null,
        color: !isPrimary ? Colors.white.withOpacity(0.2) : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: !isPrimary ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
        boxShadow: isPrimary ? [
          BoxShadow(
            color: AppColors.karigorGold.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Center(
            child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charactersState = ref.watch(backendCharactersProvider);
    final storyState = ref.watch(backendStoryProvider);
    final selectedCharacter = ref.watch(selectedCharacterProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom app bar
                Container(
                  padding: EdgeInsets.all(AppSizes.md),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(AppSizes.sm),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Generate Story',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'SF Pro Display',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(backendCharactersProvider.notifier).refreshCharacters();
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSizes.sm),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Scrollable content
                Expanded(
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.all(AppSizes.md),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Character Selection Card
                                _buildGlassCard(
                                  child: Column(
                                    children: [
                                      _buildGlassDropdown(
                                        label: 'Select Character (Optional)',
                                        value: selectedCharacter,
                                        characters: charactersState.characters,
                                        onChanged: (BackendCharacter? character) {
                                          ref.read(selectedCharacterProvider.notifier).state = character;
                                        },
                                        isLoading: charactersState.isLoading,
                                        error: charactersState.error,
                                      ),
                                      
                                      if (selectedCharacter != null) ...[
                                        SizedBox(height: AppSizes.md),
                                        Container(
                                          padding: EdgeInsets.all(AppSizes.sm),
                                          decoration: BoxDecoration(
                                            color: AppColors.karigorGold.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                            border: Border.all(
                                              color: AppColors.karigorGold.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.person_rounded,
                                                color: AppColors.karigorGold,
                                                size: 18,
                                              ),
                                              SizedBox(width: AppSizes.sm),
                                              Expanded(
                                                child: Text(
                                                  'Selected: ${selectedCharacter.name} (Used ${selectedCharacter.usageCount} times)',
                                                  style: TextStyle(
                                                    color: AppColors.karigorGold,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                
                                SizedBox(height: AppSizes.lg),
                                
                                // Story Prompt Card
                                _buildGlassCard(
                                  child: _buildGlassTextField(
                                    controller: _storyController,
                                    label: 'Story Prompt',
                                    hintText: 'Enter your story idea here...',
                                    maxLines: 4,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Please enter a story idea';
                                      }
                                      if (value.trim().length < 10) {
                                        return 'Please enter at least 10 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                
                                SizedBox(height: AppSizes.lg),
                                
                                // Generate Button
                                _buildGlassButton(
                                  text: storyState.isGenerating ? 'Generating...' : 'Generate Story',
                                  onPressed: storyState.isGenerating ? null : _generateStory,
                                  isLoading: storyState.isGenerating,
                                ),
                                
                                // Error Display
                                if (storyState.error != null) ...[
                                  SizedBox(height: AppSizes.lg),
                                  _buildGlassCard(
                                    child: Container(
                                      padding: EdgeInsets.all(AppSizes.sm),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                        border: Border.all(
                                          color: AppColors.error.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.error_outline_rounded,
                                                color: AppColors.error,
                                                size: 20,
                                              ),
                                              SizedBox(width: AppSizes.sm),
                                              Text(
                                                'Error',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.error,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: AppSizes.sm),
                                          Text(
                                            storyState.error!,
                                            style: TextStyle(
                                              color: AppColors.error.withOpacity(0.8),
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: AppSizes.md),
                                          _buildGlassButton(
                                            text: 'Try Again',
                                            onPressed: () {
                                              ref.read(backendStoryProvider.notifier).clearError();
                                            },
                                            isPrimary: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                
                                // Generated Story Display
                                if (storyState.story != null) ...[
                                  SizedBox(height: AppSizes.lg),
                                  _buildGlassCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.auto_stories_rounded,
                                              color: AppColors.technoNavy,
                                              size: 24,
                                            ),
                                            SizedBox(width: AppSizes.sm),
                                            Text(
                                              'Generated Story',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.technoNavy,
                                                fontFamily: 'SF Pro Display',
                                              ),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () => _copyStory(storyState.story!.story),
                                              child: Container(
                                                padding: EdgeInsets.all(AppSizes.xs),
                                                decoration: BoxDecoration(
                                                  color: AppColors.technoNavy.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                                ),
                                                child: Icon(
                                                  Icons.copy_rounded,
                                                  color: AppColors.technoNavy,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: AppSizes.sm),
                                            GestureDetector(
                                              onTap: () => _shareStory(storyState.story!.story),
                                              child: Container(
                                                padding: EdgeInsets.all(AppSizes.xs),
                                                decoration: BoxDecoration(
                                                  color: AppColors.technoNavy.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                                ),
                                                child: Icon(
                                                  Icons.share_rounded,
                                                  color: AppColors.technoNavy,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: AppSizes.md),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(AppSizes.md),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.4),
                                            ),
                                          ),
                                          child: SelectableText(
                                            storyState.story!.story,
                                            style: TextStyle(
                                              color: AppColors.technoNavy,
                                              fontSize: 16,
                                              height: 1.6,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                        ),
                                        if (storyState.story!.modelName != null) ...[
                                          SizedBox(height: AppSizes.sm),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.smart_toy_rounded,
                                                color: AppColors.technoNavy.withOpacity(0.6),
                                                size: 16,
                                              ),
                                              SizedBox(width: AppSizes.xs),
                                              Text(
                                                'Generated by: ${storyState.story!.modelName}',
                                                style: TextStyle(
                                                  color: AppColors.technoNavy.withOpacity(0.6),
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                                
                                SizedBox(height: AppSizes.xl),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 