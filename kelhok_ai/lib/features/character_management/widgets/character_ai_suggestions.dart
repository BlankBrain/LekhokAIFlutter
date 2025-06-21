import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../models/character_models.dart';
import '../services/character_service.dart';
import 'package:dio/dio.dart';

class CharacterAISuggestions extends ConsumerStatefulWidget {
  final String? storyPrompt;
  final List<Character> existingCharacters;
  final Function(Character) onCharacterSelected;
  final Function(Character) onCharacterCustomize;

  const CharacterAISuggestions({
    super.key,
    this.storyPrompt,
    this.existingCharacters = const [],
    required this.onCharacterSelected,
    required this.onCharacterCustomize,
  });

  @override
  ConsumerState<CharacterAISuggestions> createState() => _CharacterAISuggestionsState();
}

class _CharacterAISuggestionsState extends ConsumerState<CharacterAISuggestions> {
  List<Character> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateSuggestions();
  }

  @override
  void didUpdateWidget(CharacterAISuggestions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.storyPrompt != widget.storyPrompt) {
      _generateSuggestions();
    }
  }

  Future<void> _generateSuggestions() async {
    if (widget.storyPrompt == null || widget.storyPrompt!.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = CharacterService(Dio());
      final suggestions = await service.generateCharacterSuggestions(
        storyContext: widget.storyPrompt!,
        limit: 3,
      );

      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSizes.md),
          if (_isLoading) _buildLoadingState(),
          if (_error != null) _buildErrorState(),
          if (_suggestions.isNotEmpty) _buildSuggestionsList(),
          if (!_isLoading && _error == null && _suggestions.isEmpty) _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.karigorGold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            Icons.psychology,
            color: AppColors.karigorGold,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Character Suggestions',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Characters tailored for your story',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _generateSuggestions,
          icon: Icon(
            Icons.refresh,
            color: AppColors.secondaryText,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.karigorGold),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Analyzing your story...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Creating perfect characters for your narrative',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 32,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Failed to generate suggestions',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            _error!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.md),
          TextButton(
            onPressed: _generateSuggestions,
            child: Text(
              'Try Again',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 48,
              color: AppColors.secondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Enter a story prompt to get character suggestions',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Suggested Characters',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
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
                '${_suggestions.length} suggestions',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.karigorGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _suggestions.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (context, index) {
            final character = _suggestions[index];
            return _buildSuggestionCard(character);
          },
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(Character character) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.glassBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.karigorGold.withOpacity(0.3),
                      AppColors.technoNavy.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    character.name[0].toUpperCase(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.karigorGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (character.personality.archetype != null)
                      Text(
                        character.personality.archetype!.displayName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.karigorGold,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 12,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      'AI',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            character.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (character.personality.traits.isNotEmpty) ...[
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.xs,
              runSpacing: AppSizes.xs,
              children: character.personality.traits.take(3).map((trait) => 
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryText.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                  ),
                  child: Text(
                    trait,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                      fontSize: 10,
                    ),
                  ),
                ),
              ).toList(),
            ),
          ],
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => widget.onCharacterCustomize(character),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.glassBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                  child: Text(
                    'Customize',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => widget.onCharacterSelected(character),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.karigorGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                  child: Text(
                    'Use Character',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 