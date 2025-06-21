import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../providers/character_providers.dart';
import '../widgets/character_basic_info_step.dart';
import '../widgets/character_appearance_step.dart';
import '../widgets/character_personality_step.dart';
import '../widgets/character_background_step.dart';

class CharacterCreationScreen extends ConsumerWidget {
  const CharacterCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creationState = ref.watch(characterCreationProvider);
    final creationNotifier = ref.read(characterCreationProvider.notifier);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, creationState, creationNotifier),
              _buildProgressIndicator(creationState),
              Expanded(
                child: PageView(
                  controller: PageController(initialPage: creationState.currentStep),
                  onPageChanged: (index) => creationNotifier.setStep(index),
                  children: [
                    CharacterBasicInfoStep(
                      character: creationState.character,
                      onUpdate: creationNotifier.updateCharacter,
                    ),
                    CharacterAppearanceStep(
                      character: creationState.character,
                      onUpdate: creationNotifier.updateCharacter,
                    ),
                    CharacterPersonalityStep(
                      character: creationState.character,
                      onUpdate: creationNotifier.updateCharacter,
                    ),
                    CharacterBackgroundStep(
                      character: creationState.character,
                      onUpdate: creationNotifier.updateCharacter,
                    ),
                  ],
                ),
              ),
              _buildNavigationButtons(context, creationState, creationNotifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CharacterCreationState state, CharacterCreationNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          const SizedBox(width: AppSizes.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Character',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _getStepTitle(state.currentStep),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (state.character.name.isNotEmpty)
            IconButton(
              onPressed: () => _showTemplateDialog(context, notifier),
              icon: const Icon(Icons.save_alt, color: AppColors.primary),
              tooltip: 'Save as Template',
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(CharacterCreationState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
      child: GlassmorphicContainer(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingS),
          child: Row(
            children: List.generate(4, (index) {
              final isActive = index == state.currentStep;
              final isCompleted = index < state.currentStep;
              
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < 3 ? AppSizes.spacingXS : 0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: isCompleted || isActive
                              ? AppColors.primary
                              : AppColors.surfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingXS),
                      Text(
                        _getStepLabel(index),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isCompleted || isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, CharacterCreationState state, CharacterCreationNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Row(
        children: [
          if (state.currentStep > 0)
            Expanded(
              child: GlassmorphicContainer(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: notifier.previousStep,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                          const SizedBox(width: AppSizes.spacingXS),
                          Text(
                            'Previous',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (state.currentStep > 0 && state.currentStep < 3)
            const SizedBox(width: AppSizes.spacingM),
          if (state.currentStep < 3)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _canProceed(state) ? notifier.nextStep : null,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: _canProceed(state) ? Colors.white : Colors.white54,
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacingXS),
                          Icon(
                            Icons.arrow_forward,
                            color: _canProceed(state) ? Colors.white : Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (state.currentStep == 3)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: state.isLoading ? null : () => _saveCharacter(context, notifier),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          else ...[
                            const Icon(Icons.save, color: Colors.white),
                            const SizedBox(width: AppSizes.spacingXS),
                            Text(
                              'Create Character',
                              style: AppTextStyles.buttonMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'Physical Appearance';
      case 2:
        return 'Personality & Traits';
      case 3:
        return 'Background & History';
      default:
        return '';
    }
  }

  String _getStepLabel(int step) {
    switch (step) {
      case 0:
        return 'Basic';
      case 1:
        return 'Appearance';
      case 2:
        return 'Personality';
      case 3:
        return 'Background';
      default:
        return '';
    }
  }

  bool _canProceed(CharacterCreationState state) {
    switch (state.currentStep) {
      case 0:
        return state.character.name.isNotEmpty && state.character.description.isNotEmpty;
      case 1:
        return true; // Appearance is optional
      case 2:
        return state.character.personality.traits.isNotEmpty;
      case 3:
        return true; // Background is optional
      default:
        return false;
    }
  }

  Future<void> _saveCharacter(BuildContext context, CharacterCreationNotifier notifier) async {
    await notifier.saveCharacter();
    
    if (context.mounted) {
      final state = notifier.state;
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${state.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Character created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, state.character);
      }
    }
  }

  void _showTemplateDialog(BuildContext context, CharacterCreationNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Load Template',
          style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose a character template to start with:',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.spacingM),
            Consumer(
              builder: (context, ref, child) {
                final templatesAsync = ref.watch(characterTemplatesProvider);
                
                return templatesAsync.when(
                  data: (templates) => Column(
                    children: templates.map((template) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          template.name[0].toUpperCase(),
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        template.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        template.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        notifier.loadTemplate(template);
                        Navigator.pop(context);
                      },
                    )).toList(),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text(
                    'Error loading templates',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 