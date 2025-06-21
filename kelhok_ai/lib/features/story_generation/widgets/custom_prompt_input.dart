import 'package:flutter/material.dart';
import '../models/story_template_models.dart';
import '../../../core/constants/app_constants.dart';

class CustomPromptInput extends StatelessWidget {
  final StoryTemplate template;
  final Map<String, TextEditingController> promptControllers;
  final TextEditingController customPromptController;

  const CustomPromptInput({
    super.key,
    required this.template,
    required this.promptControllers,
    required this.customPromptController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template Prompts Section
        if (template.prompts.isNotEmpty) ...[
          _buildSectionTitle('Template Prompts'),
          const SizedBox(height: AppSizes.md),
          ...template.prompts.map((prompt) => _buildPromptEditor(prompt)),
          const SizedBox(height: AppSizes.xl),
        ],
        
        // Custom Prompt Section
        _buildSectionTitle('Custom Prompt'),
        const SizedBox(height: AppSizes.sm),
        Text(
          'Add your own custom prompt to enhance the story generation',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        _buildCustomPromptEditor(),
        
        const SizedBox(height: AppSizes.md),
        
        // Prompt Tips
        _buildPromptTips(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.headingMedium.copyWith(
        color: AppColors.primaryText,
        fontSize: 18,
      ),
    );
  }

  Widget _buildPromptEditor(TemplatePrompt prompt) {
    final controller = promptControllers[prompt.id];
    if (controller == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note,
                size: 20,
                color: AppColors.karigorGold,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                prompt.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: TextField(
              controller: controller,
              maxLines: 4,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
              ),
              decoration: InputDecoration(
                hintText: 'Edit the prompt template...',
                hintStyle: TextStyle(
                  color: AppColors.secondaryText,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppSizes.md),
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          // Character count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Use {placeholders} for dynamic content',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                '${controller.text.length} characters',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomPromptEditor() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          TextField(
            controller: customPromptController,
            maxLines: 6,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryText,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your custom prompt here...\n\nExample: Write a story about {character} who discovers {object} and must {action} to save {place}.',
              hintStyle: TextStyle(
                color: AppColors.secondaryText,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSizes.md),
            ),
          ),
          
          // Footer with character count and actions
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryBackground.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppSizes.radiusMd),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${customPromptController.text.length} characters',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => customPromptController.clear(),
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondaryText,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: 4,
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

  Widget _buildPromptTips() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: AppColors.info,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Prompt Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          _buildTipItem('Use {placeholders} for dynamic content that users can fill in'),
          _buildTipItem('Be specific about the style, tone, and length you want'),
          _buildTipItem('Include context about characters, setting, and plot elements'),
          _buildTipItem('Consider the target audience and genre conventions'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 8),
            decoration: BoxDecoration(
              color: AppColors.info,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}