import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/styles/app_text_styles.dart';
import '../../../shared/styles/app_colors.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../services/enhanced_image_service.dart';
import '../models/enhanced_image_models.dart';
import '../models/scene_composition_models.dart';
import '../services/scene_composition_service.dart';
import 'package:dio/dio.dart';

// Providers
final storyIllustrationServiceProvider = Provider<EnhancedImageService>((ref) {
  return EnhancedImageService(Dio());
});

final sceneServiceProvider = Provider<SceneCompositionService>((ref) {
  return SceneCompositionService(Dio());
});

final storyIllustrationsProvider = StateProvider<List<StoryIllustration>>((ref) => []);
final isGeneratingIllustrationProvider = StateProvider<bool>((ref) => false);

class StoryIllustration {
  final String id;
  final String sceneDescription;
  final String imageUrl;
  final ImageStyle style;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const StoryIllustration({
    required this.id,
    required this.sceneDescription,
    required this.imageUrl,
    required this.style,
    required this.createdAt,
    required this.metadata,
  });

  StoryIllustration copyWith({
    String? id,
    String? sceneDescription,
    String? imageUrl,
    ImageStyle? style,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return StoryIllustration(
      id: id ?? this.id,
      sceneDescription: sceneDescription ?? this.sceneDescription,
      imageUrl: imageUrl ?? this.imageUrl,
      style: style ?? this.style,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

class StoryIllustrationWidget extends ConsumerStatefulWidget {
  final String storyText;
  final List<String>? characterNames;
  final ImageStyle? preferredStyle;
  final Function(List<StoryIllustration>)? onIllustrationsGenerated;

  const StoryIllustrationWidget({
    super.key,
    required this.storyText,
    this.characterNames,
    this.preferredStyle,
    this.onIllustrationsGenerated,
  });

  @override
  ConsumerState<StoryIllustrationWidget> createState() => _StoryIllustrationWidgetState();
}

class _StoryIllustrationWidgetState extends ConsumerState<StoryIllustrationWidget> {
  List<String> _extractedScenes = [];
  ImageStyle _selectedStyle = ImageStyle.fantasy;

  @override
  void initState() {
    super.initState();
    _selectedStyle = widget.preferredStyle ?? ImageStyle.fantasy;
    _extractScenesFromStory();
  }

  @override
  Widget build(BuildContext context) {
    final illustrations = ref.watch(storyIllustrationsProvider);
    final isGenerating = ref.watch(isGeneratingIllustrationProvider);

    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          
          if (_extractedScenes.isNotEmpty) ...[
            _buildScenesList(),
            const SizedBox(height: 16),
          ],
          
          _buildStyleSelector(),
          const SizedBox(height: 16),
          
          _buildActionButtons(isGenerating),
          
          if (illustrations.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildIllustrationsGrid(illustrations),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.photo_library,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Story Illustrations',
                style: AppTextStyles.headingSmall,
              ),
              Text(
                'Generate visual scenes from your story',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _showIllustrationOptions,
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  Widget _buildScenesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detected Scenes (${_extractedScenes.length})',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _extractedScenes.length,
            itemBuilder: (context, index) {
              final scene = _extractedScenes[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: GlassmorphicContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scene ${index + 1}',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            scene,
                            style: AppTextStyles.bodySmall,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Illustration Style',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ImageStyle.values.length,
            itemBuilder: (context, index) {
              final style = ImageStyle.values[index];
              final isSelected = _selectedStyle == style;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStyle = style;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primary
                          : AppColors.surface.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          style.displayName,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isSelected 
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isGenerating) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isGenerating ? null : _generateKeyIllustrations,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
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
              isGenerating ? 'Generating...' : 'Generate Key Scenes',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: isGenerating ? null : _generateAllScenes,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface.withOpacity(0.3),
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: const Icon(Icons.view_carousel),
          label: Text(
            'All Scenes',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildIllustrationsGrid(List<StoryIllustration> illustrations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generated Illustrations',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _exportIllustrations,
              icon: const Icon(Icons.download),
              label: const Text('Export All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: illustrations.length,
          itemBuilder: (context, index) {
            final illustration = illustrations[index];
            return _buildIllustrationCard(illustration, index);
          },
        ),
      ],
    );
  }

  Widget _buildIllustrationCard(StoryIllustration illustration, int index) {
    return GestureDetector(
      onTap: () => _showIllustrationDetails(illustration),
      child: GlassmorphicContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: illustration.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: AppColors.surface.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surface.withOpacity(0.3),
                    child: const Icon(Icons.error_outline),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scene ${index + 1}',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    illustration.sceneDescription,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _extractScenesFromStory() {
    // Simple scene extraction logic - in real implementation, use NLP
    final sentences = widget.storyText.split(RegExp(r'[.!?]+'));
    final scenes = <String>[];
    
    for (final sentence in sentences) {
      final trimmed = sentence.trim();
      if (trimmed.isNotEmpty && trimmed.length > 20) {
        // Look for action words or scene descriptors
        if (_containsSceneKeywords(trimmed)) {
          scenes.add(trimmed);
        }
      }
    }
    
    setState(() {
      _extractedScenes = scenes.take(6).toList(); // Limit to 6 scenes
    });
  }

  bool _containsSceneKeywords(String text) {
    const keywords = [
      'walked', 'entered', 'saw', 'looked', 'appeared', 'stood', 'sitting',
      'room', 'forest', 'castle', 'mountain', 'beach', 'city', 'house',
      'suddenly', 'then', 'meanwhile', 'later', 'morning', 'evening',
      'battle', 'fight', 'dance', 'sing', 'run', 'fly', 'magic',
    ];
    
    final lowerText = text.toLowerCase();
    return keywords.any((keyword) => lowerText.contains(keyword));
  }

  Future<void> _generateKeyIllustrations() async {
    if (_extractedScenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No scenes detected in the story'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ref.read(isGeneratingIllustrationProvider.notifier).state = true;
    
    try {
      final service = ref.read(storyIllustrationServiceProvider);
      final illustrations = <StoryIllustration>[];
      
      // Generate illustrations for key scenes (first 3)
      final keyScenes = _extractedScenes.take(3).toList();
      
      for (int i = 0; i < keyScenes.length; i++) {
        final scene = keyScenes[i];
        final enhancedPrompt = _enhanceScenePrompt(scene);
        
        // Mock image generation - replace with actual service call
        await Future.delayed(const Duration(seconds: 2));
        
        final illustration = StoryIllustration(
          id: 'ill_${DateTime.now().millisecondsSinceEpoch}_$i',
          sceneDescription: scene,
          imageUrl: 'https://picsum.photos/512/512?random=${DateTime.now().millisecondsSinceEpoch + i}',
          style: _selectedStyle,
          createdAt: DateTime.now(),
          metadata: {
            'prompt': enhancedPrompt,
            'style': _selectedStyle.name,
            'characters': widget.characterNames ?? [],
          },
        );
        
        illustrations.add(illustration);
      }
      
      ref.read(storyIllustrationsProvider.notifier).state = illustrations;
      widget.onIllustrationsGenerated?.call(illustrations);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Generated ${illustrations.length} illustrations!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate illustrations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      ref.read(isGeneratingIllustrationProvider.notifier).state = false;
    }
  }

  Future<void> _generateAllScenes() async {
    if (_extractedScenes.isEmpty) return;

    ref.read(isGeneratingIllustrationProvider.notifier).state = true;
    
    try {
      final service = ref.read(storyIllustrationServiceProvider);
      final illustrations = <StoryIllustration>[];
      
      for (int i = 0; i < _extractedScenes.length; i++) {
        final scene = _extractedScenes[i];
        final enhancedPrompt = _enhanceScenePrompt(scene);
        
        // Mock image generation
        await Future.delayed(const Duration(milliseconds: 1500));
        
        final illustration = StoryIllustration(
          id: 'ill_${DateTime.now().millisecondsSinceEpoch}_$i',
          sceneDescription: scene,
          imageUrl: 'https://picsum.photos/512/512?random=${DateTime.now().millisecondsSinceEpoch + i * 10}',
          style: _selectedStyle,
          createdAt: DateTime.now(),
          metadata: {
            'prompt': enhancedPrompt,
            'style': _selectedStyle.name,
            'characters': widget.characterNames ?? [],
          },
        );
        
        illustrations.add(illustration);
      }
      
      ref.read(storyIllustrationsProvider.notifier).state = illustrations;
      widget.onIllustrationsGenerated?.call(illustrations);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Generated ${illustrations.length} illustrations!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate illustrations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      ref.read(isGeneratingIllustrationProvider.notifier).state = false;
    }
  }

  String _enhanceScenePrompt(String scene) {
    final styleModifier = _selectedStyle.description;
    final characterInfo = widget.characterNames?.isNotEmpty == true 
        ? 'featuring ${widget.characterNames!.join(', ')}, '
        : '';
    
    return '$characterInfo$scene, $styleModifier, high quality, detailed';
  }

  void _showIllustrationDetails(StoryIllustration illustration) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: illustration.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Scene Description',
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  illustration.sceneDescription,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Style: ${illustration.style.displayName}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement download functionality
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
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

  void _showIllustrationOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Illustration Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.auto_awesome),
                title: const Text('Auto-detect Scenes'),
                subtitle: const Text('Automatically find visual scenes'),
                onTap: () {
                  Navigator.pop(context);
                  _extractScenesFromStory();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Custom Scenes'),
                subtitle: const Text('Manually select scenes to illustrate'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement custom scene selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Style Gallery'),
                subtitle: const Text('Browse available art styles'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement style gallery
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _exportIllustrations() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon!'),
      ),
    );
  }
} 