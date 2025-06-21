import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ToneMoodSelector extends StatelessWidget {
  final String selectedTone;
  final String selectedMood;
  final int targetLength;
  final Function(String) onToneChanged;
  final Function(String) onMoodChanged;
  final Function(int) onLengthChanged;

  const ToneMoodSelector({
    super.key,
    required this.selectedTone,
    required this.selectedMood,
    required this.targetLength,
    required this.onToneChanged,
    required this.onMoodChanged,
    required this.onLengthChanged,
  });

  static const List<Map<String, dynamic>> tones = [
    {
      'id': 'casual',
      'name': 'Casual',
      'description': 'Relaxed and conversational',
      'icon': Icons.chat_bubble_outline,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': 'formal',
      'name': 'Formal',
      'description': 'Professional and structured',
      'icon': Icons.business,
      'color': Color(0xFF2196F3),
    },
    {
      'id': 'dramatic',
      'name': 'Dramatic',
      'description': 'Intense and emotional',
      'icon': Icons.theater_comedy,
      'color': Color(0xFFE91E63),
    },
    {
      'id': 'humorous',
      'name': 'Humorous',
      'description': 'Light-hearted and funny',
      'icon': Icons.sentiment_very_satisfied,
      'color': Color(0xFFFFC107),
    },
    {
      'id': 'mysterious',
      'name': 'Mysterious',
      'description': 'Intriguing and suspenseful',
      'icon': Icons.visibility_off,
      'color': Color(0xFF9C27B0),
    },
    {
      'id': 'romantic',
      'name': 'Romantic',
      'description': 'Warm and affectionate',
      'icon': Icons.favorite,
      'color': Color(0xFFE91E63),
    },
  ];

  static const List<Map<String, dynamic>> moods = [
    {
      'id': 'uplifting',
      'name': 'Uplifting',
      'description': 'Positive and inspiring',
      'icon': Icons.trending_up,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': 'melancholic',
      'name': 'Melancholic',
      'description': 'Thoughtful and reflective',
      'icon': Icons.cloud,
      'color': Color(0xFF607D8B),
    },
    {
      'id': 'exciting',
      'name': 'Exciting',
      'description': 'Energetic and thrilling',
      'icon': Icons.flash_on,
      'color': Color(0xFFFF5722),
    },
    {
      'id': 'peaceful',
      'name': 'Peaceful',
      'description': 'Calm and serene',
      'icon': Icons.spa,
      'color': Color(0xFF009688),
    },
    {
      'id': 'tense',
      'name': 'Tense',
      'description': 'Suspenseful and edgy',
      'icon': Icons.warning,
      'color': Color(0xFFFF9800),
    },
    {
      'id': 'balanced',
      'name': 'Balanced',
      'description': 'Even and harmonious',
      'icon': Icons.balance,
      'color': Color(0xFF2196F3),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tone Selection
        _buildSectionTitle('Story Tone'),
        const SizedBox(height: AppSizes.md),
        _buildToneGrid(),
        
        const SizedBox(height: AppSizes.xl),
        
        // Mood Selection
        _buildSectionTitle('Story Mood'),
        const SizedBox(height: AppSizes.md),
        _buildMoodGrid(),
        
        const SizedBox(height: AppSizes.xl),
        
        // Length Selection
        _buildSectionTitle('Target Length'),
        const SizedBox(height: AppSizes.md),
        _buildLengthSlider(),
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

  Widget _buildToneGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
      ),
      itemCount: tones.length,
      itemBuilder: (context, index) {
        final tone = tones[index];
        final isSelected = selectedTone == tone['id'];
        
        return GestureDetector(
          onTap: () => onToneChanged(tone['id']),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? tone['color'].withOpacity(0.2)
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: isSelected 
                    ? tone['color']
                    : AppColors.glassBorder,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Row(
                children: [
                  Icon(
                    tone['icon'],
                    color: isSelected 
                        ? tone['color']
                        : AppColors.secondaryText,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tone['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? tone['color']
                                : AppColors.primaryText,
                          ),
                        ),
                        Text(
                          tone['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        final isSelected = selectedMood == mood['id'];
        
        return GestureDetector(
          onTap: () => onMoodChanged(mood['id']),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? mood['color'].withOpacity(0.2)
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: isSelected 
                    ? mood['color']
                    : AppColors.glassBorder,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Row(
                children: [
                  Icon(
                    mood['icon'],
                    color: isSelected 
                        ? mood['color']
                        : AppColors.secondaryText,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mood['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? mood['color']
                                : AppColors.primaryText,
                          ),
                        ),
                        Text(
                          mood['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLengthSlider() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Word Count',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.karigorGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$targetLength words',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.karigorGold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.md),
          
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.karigorGold,
              inactiveTrackColor: AppColors.glassBorder,
              thumbColor: AppColors.karigorGold,
              overlayColor: AppColors.karigorGold.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: targetLength.toDouble(),
              min: 100,
              max: 2000,
              divisions: 19,
              onChanged: (value) => onLengthChanged(value.round()),
            ),
          ),
          
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '100 words',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                '2000 words',
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
}