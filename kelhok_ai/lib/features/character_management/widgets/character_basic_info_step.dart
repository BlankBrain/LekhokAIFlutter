import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../models/character_models.dart';

class CharacterBasicInfoStep extends StatefulWidget {
  final Character character;
  final Function(Character) onUpdate;

  const CharacterBasicInfoStep({
    super.key,
    required this.character,
    required this.onUpdate,
  });

  @override
  State<CharacterBasicInfoStep> createState() => _CharacterBasicInfoStepState();
}

class _CharacterBasicInfoStepState extends State<CharacterBasicInfoStep> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.character.name);
    _descriptionController = TextEditingController(text: widget.character.description);
    _tagsController = TextEditingController(text: widget.character.tags.join(', '));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _updateCharacter() {
    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final updatedCharacter = widget.character.copyWith(
      name: _nameController.text,
      description: _descriptionController.text,
      tags: tags,
      updatedAt: DateTime.now(),
    );

    widget.onUpdate(updatedCharacter);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Start by giving your character a name and description',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          // Character Name
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Character Name *',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                TextField(
                  controller: _nameController,
                  onChanged: (_) => _updateCharacter(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter character name...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      borderSide: BorderSide(color: AppColors.karigorGold),
                    ),
                    filled: true,
                    fillColor: AppColors.glassBackground.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Character Description
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Character Description *',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                TextField(
                  controller: _descriptionController,
                  onChanged: (_) => _updateCharacter(),
                  maxLines: 4,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Describe your character in a few sentences...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      borderSide: BorderSide(color: AppColors.karigorGold),
                    ),
                    filled: true,
                    fillColor: AppColors.glassBackground.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Character Tags
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tags',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Add tags to help categorize your character (comma-separated)',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                TextField(
                  controller: _tagsController,
                  onChanged: (_) => _updateCharacter(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'hero, warrior, protagonist...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      borderSide: BorderSide(color: AppColors.karigorGold),
                    ),
                    filled: true,
                    fillColor: AppColors.glassBackground.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Quick Templates
          Text(
            'Quick Start Templates',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Choose a template to get started quickly',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          
          // Template buttons
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: [
              _buildTemplateChip('Hero', 'Brave protagonist'),
              _buildTemplateChip('Villain', 'Formidable antagonist'),
              _buildTemplateChip('Mentor', 'Wise guide'),
              _buildTemplateChip('Sidekick', 'Loyal companion'),
              _buildTemplateChip('Love Interest', 'Romantic partner'),
              _buildTemplateChip('Anti-Hero', 'Morally complex'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateChip(String title, String description) {
    return GestureDetector(
      onTap: () => _loadQuickTemplate(title, description),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.karigorGold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: AppColors.karigorGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.karigorGold,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadQuickTemplate(String title, String description) {
    _nameController.text = 'The $title';
    _descriptionController.text = description;
    _tagsController.text = title.toLowerCase();
    _updateCharacter();
  }
} 