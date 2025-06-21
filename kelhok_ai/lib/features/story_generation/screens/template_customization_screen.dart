import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story_template_models.dart';
import '../widgets/template_preview_card.dart';
import '../widgets/tone_mood_selector.dart';
import '../widgets/custom_prompt_input.dart';
import '../widgets/genre_selector.dart';
import '../../story_generation/screens/story_generation_screen_v2.dart';
import '../../../core/constants/app_constants.dart';

class TemplateCustomizationScreen extends ConsumerStatefulWidget {
  final StoryTemplate template;

  const TemplateCustomizationScreen({
    super.key,
    required this.template,
  });

  @override
  ConsumerState<TemplateCustomizationScreen> createState() =>
      _TemplateCustomizationScreenState();
}

class _TemplateCustomizationScreenState
    extends ConsumerState<TemplateCustomizationScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Customization data
  late TemplateCustomization _customization;
  final Map<String, TextEditingController> _promptControllers = {};
  final TextEditingController _customPromptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize customization with template defaults
    _customization = TemplateCustomization(
      templateId: widget.template.id,
      selectedGenres: List.from(widget.template.genres),
      selectedTone: widget.template.settings['tone'] ?? 'neutral',
      selectedMood: 'balanced',
      targetLength: widget.template.estimatedLength,
    );

    // Initialize prompt controllers
    for (final prompt in widget.template.prompts) {
      _promptControllers[prompt.id] = TextEditingController(text: prompt.content);
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    for (final controller in _promptControllers.values) {
      controller.dispose();
    }
    _customPromptController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateCustomization(TemplateCustomization newCustomization) {
    setState(() {
      _customization = newCustomization;
    });
  }

  void _generateStory() {
    // Update customization with current prompt values
    final customPrompts = <String, String>{};
    for (final entry in _promptControllers.entries) {
      customPrompts[entry.key] = entry.value.text;
    }

    if (_customPromptController.text.isNotEmpty) {
      customPrompts['custom'] = _customPromptController.text;
    }

    final finalCustomization = TemplateCustomization(
      templateId: _customization.templateId,
      customPrompts: customPrompts,
      selectedGenres: _customization.selectedGenres,
      selectedTone: _customization.selectedTone,
      selectedMood: _customization.selectedMood,
      targetLength: _customization.targetLength,
      characterSettings: _customization.characterSettings,
      plotSettings: _customization.plotSettings,
    );

    // Navigate to story generation screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const StoryGenerationScreenV2(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Customize "${widget.template.name}"',
          style: AppTextStyles.headingMedium.copyWith(color: AppColors.primaryText),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  _buildTemplatePreviewStep(),
                  _buildGenreSelectionStep(),
                  _buildToneMoodStep(),
                  _buildPromptCustomizationStep(),
                ],
              ),
            ),
            
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.karigorGold : AppColors.glassBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < _totalSteps - 1)
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: isCompleted ? AppColors.karigorGold : AppColors.cardBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive ? AppColors.karigorGold : AppColors.glassBorder,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTemplatePreviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Template Preview',
            style: AppTextStyles.headingLarge.copyWith(color: AppColors.primaryText),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Review your selected template before customizing',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: AppSizes.lg),
          
          TemplatePreviewCard(
            template: widget.template,
            customization: _customization,
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Template Details',
                  style: AppTextStyles.headingMedium.copyWith(color: AppColors.primaryText),
                ),
                const SizedBox(height: AppSizes.md),
                _buildDetailRow('Category', widget.template.category.toUpperCase()),
                _buildDetailRow('Difficulty', widget.template.difficulty.toUpperCase()),
                _buildDetailRow('Estimated Length', '${widget.template.estimatedLength} words'),
                _buildDetailRow('Genres', widget.template.genres.join(', ')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Genres',
            style: AppTextStyles.headingLarge.copyWith(color: AppColors.primaryText),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Choose the genres that best fit your story vision',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: AppSizes.lg),
          
          GenreSelector(
            genres: PredefinedTemplates.defaultGenres,
            selectedGenres: _customization.selectedGenres,
            onSelectionChanged: (genres) {
              _updateCustomization(_customization.copyWith(selectedGenres: genres));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToneMoodStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Tone & Mood',
            style: AppTextStyles.headingLarge.copyWith(color: AppColors.primaryText),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Define the emotional atmosphere of your story',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: AppSizes.lg),
          
          ToneMoodSelector(
            selectedTone: _customization.selectedTone,
            selectedMood: _customization.selectedMood,
            targetLength: _customization.targetLength,
            onToneChanged: (tone) {
              _updateCustomization(_customization.copyWith(selectedTone: tone));
            },
            onMoodChanged: (mood) {
              _updateCustomization(_customization.copyWith(selectedMood: mood));
            },
            onLengthChanged: (length) {
              _updateCustomization(_customization.copyWith(targetLength: length));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPromptCustomizationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize Prompts',
            style: AppTextStyles.headingLarge.copyWith(color: AppColors.primaryText),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Fine-tune the story prompts to match your vision',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: AppSizes.lg),
          
          CustomPromptInput(
            template: widget.template,
            promptControllers: _promptControllers,
            customPromptController: _customPromptController,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.glassBorder),
                ),
                child: Text(
                  'Previous',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryText),
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: AppSizes.md),
          
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == _totalSteps - 1 ? _generateStory : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.karigorGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _currentStep == _totalSteps - 1 ? 'Generate Story' : 'Next',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to add copyWith method to TemplateCustomization
extension TemplateCustomizationExtension on TemplateCustomization {
  TemplateCustomization copyWith({
    String? templateId,
    Map<String, String>? customPrompts,
    List<String>? selectedGenres,
    String? selectedTone,
    String? selectedMood,
    int? targetLength,
    Map<String, dynamic>? characterSettings,
    Map<String, dynamic>? plotSettings,
  }) {
    return TemplateCustomization(
      templateId: templateId ?? this.templateId,
      customPrompts: customPrompts ?? this.customPrompts,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      selectedTone: selectedTone ?? this.selectedTone,
      selectedMood: selectedMood ?? this.selectedMood,
      targetLength: targetLength ?? this.targetLength,
      characterSettings: characterSettings ?? this.characterSettings,
      plotSettings: plotSettings ?? this.plotSettings,
    );
  }
}