import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../services/enhanced_image_service.dart';
import '../models/enhanced_image_models.dart';
import '../../character_management/models/character_models.dart';
import 'package:dio/dio.dart';

class CharacterPortrait {
  final String id;
  final Character character;
  final String imageUrl;
  final ImageStyle style;
  final String prompt;
  final DateTime createdAt;

  const CharacterPortrait({
    required this.id,
    required this.character,
    required this.imageUrl,
    required this.style,
    required this.prompt,
    required this.createdAt,
  });
}

class CharacterPortraitGenerator extends StatefulWidget {
  final List<Character> availableCharacters;

  const CharacterPortraitGenerator({
    super.key,
    required this.availableCharacters,
  });

  @override
  State<CharacterPortraitGenerator> createState() => _CharacterPortraitGeneratorState();
}

class _CharacterPortraitGeneratorState extends State<CharacterPortraitGenerator> {
  List<Character> selectedCharacters = [];
  List<CharacterPortrait> generatedPortraits = [];
  bool isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Character Portraits',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          
          if (widget.availableCharacters.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                children: [
                  Icon(
                    Icons.person_add,
                    size: 48,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'No Characters Available',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            _buildCharacterSelector(),
            const SizedBox(height: AppSizes.md),
            _buildGenerateButton(),
          ],
          
          if (generatedPortraits.isNotEmpty) ...[
            const SizedBox(height: AppSizes.lg),
            _buildPortraitsGrid(),
          ],
        ],
      ),
    );
  }

  Widget _buildCharacterSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Characters',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.availableCharacters.length,
            itemBuilder: (context, index) {
              final character = widget.availableCharacters[index];
              final isSelected = selectedCharacters.contains(character);
              
              return GestureDetector(
                onTap: () => _toggleCharacterSelection(character),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: AppSizes.sm),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                      color: isSelected ? AppColors.karigorGold : AppColors.glassBorder,
                      width: 2,
                    ),
                    color: isSelected 
                        ? AppColors.karigorGold.withOpacity(0.1)
                        : AppColors.glassBackground.withOpacity(0.3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.karigorGold.withOpacity(0.2),
                        child: Text(
                          character.name[0].toUpperCase(),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.karigorGold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        character.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: AppColors.karigorGold,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    final canGenerate = selectedCharacters.isNotEmpty && !isGenerating;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canGenerate ? _generatePortraits : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.karigorGold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        ),
        icon: isGenerating 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.auto_awesome),
        label: Text(
          isGenerating 
              ? 'Generating Portraits...' 
              : selectedCharacters.isEmpty
                  ? 'Select Characters to Generate'
                  : 'Generate ${selectedCharacters.length} Portrait${selectedCharacters.length == 1 ? '' : 's'}',
          style: AppTextStyles.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildPortraitsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Generated Portraits (${generatedPortraits.length})',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.sm,
            mainAxisSpacing: AppSizes.sm,
            childAspectRatio: 0.8,
          ),
          itemCount: generatedPortraits.length,
          itemBuilder: (context, index) {
            final portrait = generatedPortraits[index];
            return _buildPortraitCard(portrait);
          },
        ),
      ],
    );
  }

  Widget _buildPortraitCard(CharacterPortrait portrait) {
    return GestureDetector(
      onTap: () => _showPortraitDetails(portrait),
      child: GlassmorphicContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: CachedNetworkImage(
                  imageUrl: portrait.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: AppColors.glassBackground.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.glassBackground.withOpacity(0.3),
                    child: const Icon(Icons.error_outline),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Text(
                portrait.character.name,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCharacterSelection(Character character) {
    setState(() {
      if (selectedCharacters.contains(character)) {
        selectedCharacters.remove(character);
      } else {
        selectedCharacters.add(character);
      }
    });
  }

  Future<void> _generatePortraits() async {
    if (selectedCharacters.isEmpty) return;

    setState(() {
      isGenerating = true;
    });
    
    try {
      final portraits = <CharacterPortrait>[];
      
      for (final character in selectedCharacters) {
        await Future.delayed(const Duration(seconds: 2));
        
        final portrait = CharacterPortrait(
          id: 'portrait_${DateTime.now().millisecondsSinceEpoch}_${character.id}',
          character: character,
          imageUrl: 'https://picsum.photos/512/768?random=${DateTime.now().millisecondsSinceEpoch}',
          style: ImageStyle.photorealistic,
          prompt: 'Portrait of ${character.name}',
          createdAt: DateTime.now(),
        );
        
        portraits.add(portrait);
      }
      
      setState(() {
        generatedPortraits = portraits;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Generated ${portraits.length} portrait${portraits.length == 1 ? '' : 's'}!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate portraits: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }

  void _showPortraitDetails(CharacterPortrait portrait) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.primaryBackground,
          child: Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: CachedNetworkImage(
                    imageUrl: portrait.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  portrait.character.name,
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
