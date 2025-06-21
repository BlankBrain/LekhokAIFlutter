import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_button.dart';
import '../../../shared/widgets/animations/loading_animations.dart';
import '../models/image_generation_models.dart';
import '../widgets/image_style_selector.dart';
import '../widgets/image_viewer_widget.dart';

class ImageGenerationScreen extends ConsumerStatefulWidget {
  final String? initialPrompt;
  final String? storyId;

  const ImageGenerationScreen({
    Key? key,
    this.initialPrompt,
    this.storyId,
  }) : super(key: key);

  @override
  ConsumerState<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends ConsumerState<ImageGenerationScreen>
    with TickerProviderStateMixin {
  final _promptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _refreshController = RefreshController(initialRefresh: false);
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isGenerating = false;
  GeneratedImage? _generatedImage;
  String _selectedStyle = 'realistic';
  int _characterCount = 0;
  double? _generationProgress;
  
  static const int _maxCharacters = 300;
  static const int _minCharacters = 5;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _promptController.addListener(_updateCharacterCount);
    
    // Initialize with provided prompt
    if (widget.initialPrompt != null) {
      _promptController.text = widget.initialPrompt!;
      _updateCharacterCount();
    }
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
      _characterCount = _promptController.text.length;
    });
  }

  @override
  void dispose() {
    _promptController.removeListener(_updateCharacterCount);
    _promptController.dispose();
    _refreshController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Future<void> _generateImage() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isGenerating = true;
      _generationProgress = 0.0;
    });
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    try {
      // Simulate progressive image generation
      for (int i = 0; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          setState(() {
            _generationProgress = i / 10.0;
          });
        }
      }
      
      // Simulate generated image
      setState(() {
        _generatedImage = GeneratedImage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imageUrl: 'https://picsum.photos/512/512?random=${DateTime.now().millisecondsSinceEpoch}',
          thumbnailUrl: 'https://picsum.photos/256/256?random=${DateTime.now().millisecondsSinceEpoch}',
          prompt: _promptController.text,
          style: _selectedStyle,
          storyId: widget.storyId,
          createdAt: DateTime.now(),
        );
        _isGenerating = false;
        _generationProgress = null;
      });
      
      // Success haptic feedback
      HapticFeedback.heavyImpact();
      
    } catch (error) {
      setState(() {
        _isGenerating = false;
        _generationProgress = null;
      });
      
      // Error haptic feedback
      HapticFeedback.heavyImpact();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate image: $error'),
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
                        _buildPromptSection(),
                        SizedBox(height: AppSizes.xl),
                        _buildStyleSelector(),
                        SizedBox(height: AppSizes.xl),
                        _buildGenerateSection(),
                        if (_generatedImage != null) ...[
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
          'Generate Image',
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
                AppColors.info.withOpacity(0.1),
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
            AppColors.info,
            AppColors.info.withOpacity(0.8),
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(
              Icons.image_outlined,
              size: 48,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSizes.md),
          Text(
            'AI Image Generator',
            style: AppTextStyles.headingMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            'Transform your ideas into stunning visual art with AI',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPromptSection() {
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
                  color: AppColors.info,
                  size: 24,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  'Image Description',
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
                controller: _promptController,
                maxLines: 4,
                maxLength: _maxCharacters,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Describe the image you want to create... (e.g., "A magical forest with glowing mushrooms at sunset")',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.quaternaryText,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(AppSizes.md),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an image description';
                  }
                  if (value.trim().length < _minCharacters) {
                    return 'Description should be at least $_minCharacters characters long';
                  }
                  if (value.length > _maxCharacters) {
                    return 'Description should not exceed $_maxCharacters characters';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: AppColors.glassBorder,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_characterCount / _maxCharacters).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: _characterCount > _maxCharacters 
                              ? AppColors.error
                              : _characterCount < _minCharacters
                                  ? AppColors.warning
                                  : AppColors.success,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '$_characterCount/$_maxCharacters',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _characterCount > _maxCharacters 
                        ? AppColors.error
                        : AppColors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleSelector() {
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                color: AppColors.info,
                size: 24,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                'Art Style',
                style: AppTextStyles.headingMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.md),
          ImageStyleSelector(
            selectedStyle: _selectedStyle,
            onStyleChanged: (style) {
              setState(() {
                _selectedStyle = style;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateSection() {
    return KCard(
      child: Column(
        children: [
          if (_isGenerating) ...[
            SizedBox(
              height: 200,
              child: LoadingAnimations.storyGenerationLoader(
                message: 'Creating your masterpiece...',
                progress: _generationProgress,
                primaryColor: AppColors.info,
              ),
            ),
          ] else ...[
            KButton(
              onPressed: _generateImage,
              text: 'Generate Image',
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
    if (_generatedImage == null) return const SizedBox.shrink();
    
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                'Image Generated',
                style: AppTextStyles.headingMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _shareImage(),
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Share Image',
              ),
            ],
          ),
          SizedBox(height: AppSizes.md),
          ImageViewerWidget(
            imageUrl: _generatedImage!.imageUrl,
            thumbnailUrl: _generatedImage!.thumbnailUrl,
            heroTag: 'generated-image',
          ),
          SizedBox(height: AppSizes.md),
          Container(
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prompt',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                Text(
                  _generatedImage!.prompt,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        _generatedImage!.style.toUpperCase(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Generated ${_timeAgo(_generatedImage!.createdAt)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryText,
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

  void _shareImage() {
    if (_generatedImage != null) {
      Share.share(
        'Check out this AI-generated image: ${_generatedImage!.imageUrl}',
        subject: 'AI Generated Image',
      );
    }
  }

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
} 