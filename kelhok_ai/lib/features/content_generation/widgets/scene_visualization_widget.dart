import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../services/enhanced_image_service.dart';
import '../models/enhanced_image_models.dart';
import '../models/scene_composition_models.dart';
import 'package:dio/dio.dart';

// Providers
final sceneVisualizationServiceProvider = Provider<EnhancedImageService>((ref) {
  return EnhancedImageService(Dio());
});

final storyboardProvider = StateProvider<List<StoryboardFrame>>((ref) => []);
final isGeneratingStoryboardProvider = StateProvider<bool>((ref) => false);

class StoryboardFrame {
  final String id;
  final String sceneText;
  final String visualDescription;
  final String imageUrl;
  final int sequenceNumber;
  final ImageStyle style;
  final DateTime createdAt;

  const StoryboardFrame({
    required this.id,
    required this.sceneText,
    required this.visualDescription,
    required this.imageUrl,
    required this.sequenceNumber,
    required this.style,
    required this.createdAt,
  });
}

class SceneVisualizationWidget extends ConsumerStatefulWidget {
  final String storyText;
  final List<String>? characterNames;
  final ImageStyle? preferredStyle;
  final Function(List<StoryboardFrame>)? onStoryboardGenerated;

  const SceneVisualizationWidget({
    super.key,
    required this.storyText,
    this.characterNames,
    this.preferredStyle,
    this.onStoryboardGenerated,
  });

  @override
  ConsumerState<SceneVisualizationWidget> createState() => _SceneVisualizationWidgetState();
}

class _SceneVisualizationWidgetState extends ConsumerState<SceneVisualizationWidget> {
  List<String> _detectedScenes = [];
  ImageStyle _selectedStyle = ImageStyle.fantasy;
  StoryboardType _storyboardType = StoryboardType.keyScenes;

  @override
  void initState() {
    super.initState();
    _selectedStyle = widget.preferredStyle ?? ImageStyle.fantasy;
    _analyzeStoryForScenes();
  }

  @override
  Widget build(BuildContext context) {
    final storyboard = ref.watch(storyboardProvider);
    final isGenerating = ref.watch(isGeneratingStoryboardProvider);

    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSizes.md),
          
          if (_detectedScenes.isNotEmpty) ...[
            _buildSceneAnalysis(),
            const SizedBox(height: AppSizes.md),
          ],
          
          _buildVisualizationOptions(),
          const SizedBox(height: AppSizes.md),
          
          _buildGenerateButton(isGenerating),
          
          if (storyboard.isNotEmpty) ...[
            const SizedBox(height: AppSizes.lg),
            _buildStoryboard(storyboard),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.movie,
          color: AppColors.karigorGold,
          size: 24,
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scene Visualization',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              Text(
                'Create visual storyboards from your narrative',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _showVisualizationOptions,
          icon: Icon(
            Icons.settings,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildSceneAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scene Analysis',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.glassBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detected Scenes: ${_detectedScenes.length}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.auto_awesome,
                    color: AppColors.karigorGold,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                'AI analysis found ${_detectedScenes.length} visual scenes ready for illustration',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisualizationOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visualization Settings',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        
        // Storyboard Type
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storyboard Type',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: StoryboardType.values.map((type) {
                final isSelected = _storyboardType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSizes.sm),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _storyboardType = type;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.karigorGold
                            : AppColors.glassBackground.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        type.displayName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected 
                              ? Colors.white
                              : AppColors.primaryText,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.md),
        
        // Style Selector
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visual Style',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _getVisualizationStyles().length,
                itemBuilder: (context, index) {
                  final style = _getVisualizationStyles()[index];
                  final isSelected = _selectedStyle == style;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.sm),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStyle = style;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: AppSizes.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.karigorGold
                              : AppColors.glassBackground.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          border: Border.all(
                            color: isSelected 
                                ? AppColors.karigorGold
                                : AppColors.glassBorder,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            style.displayName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isSelected 
                                  ? Colors.white
                                  : AppColors.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenerateButton(bool isGenerating) {
    final canGenerate = _detectedScenes.isNotEmpty && !isGenerating;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canGenerate ? _generateStoryboard : null,
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
            : const Icon(Icons.video_library),
        label: Text(
          isGenerating 
              ? 'Creating Storyboard...' 
              : _detectedScenes.isEmpty
                  ? 'No Scenes Detected'
                  : 'Generate ${_storyboardType.displayName}',
          style: AppTextStyles.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildStoryboard(List<StoryboardFrame> frames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generated Storyboard (${frames.length} frames)',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            TextButton.icon(
              onPressed: _exportStoryboard,
              icon: Icon(Icons.download, color: AppColors.karigorGold),
              label: Text(
                'Export',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.karigorGold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        
        // Storyboard Timeline
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: frames.length,
            itemBuilder: (context, index) {
              final frame = frames[index];
              return _buildStoryboardFrame(frame, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoryboardFrame(StoryboardFrame frame, int index) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: AppSizes.sm),
      child: GestureDetector(
        onTap: () => _showFrameDetails(frame),
        child: GlassmorphicContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Frame number
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xs,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.karigorGold,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                ),
                child: Text(
                  'Frame ${frame.sequenceNumber}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.xs),
              
              // Frame image
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: CachedNetworkImage(
                    imageUrl: frame.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      color: AppColors.glassBackground.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.glassBackground.withOpacity(0.3),
                      child: const Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.xs),
              
              // Scene description
              Text(
                frame.visualDescription,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ImageStyle> _getVisualizationStyles() {
    return [
      ImageStyle.fantasy,
      ImageStyle.digitalArt,
      ImageStyle.anime,
      ImageStyle.cyberpunk,
      ImageStyle.oilPainting,
      ImageStyle.pencilSketch,
    ];
  }

  void _analyzeStoryForScenes() {
    // Simple scene detection logic
    final sentences = widget.storyText.split(RegExp(r'[.!?]+'));
    final scenes = <String>[];
    
    for (final sentence in sentences) {
      final trimmed = sentence.trim();
      if (trimmed.isNotEmpty && trimmed.length > 30) {
        // Look for visual keywords
        if (_containsVisualKeywords(trimmed)) {
          scenes.add(trimmed);
        }
      }
    }
    
    setState(() {
      _detectedScenes = scenes.take(8).toList(); // Limit to 8 scenes
    });
  }

  bool _containsVisualKeywords(String text) {
    const keywords = [
      'see', 'look', 'appear', 'show', 'reveal', 'display', 'stand', 'sit',
      'walk', 'run', 'fly', 'dance', 'fight', 'embrace', 'smile', 'frown',
      'light', 'dark', 'bright', 'shadow', 'color', 'beautiful', 'ugly',
      'room', 'forest', 'mountain', 'ocean', 'city', 'castle', 'house',
      'character', 'person', 'figure', 'face', 'eyes', 'hair', 'dress',
    ];
    
    final lowerText = text.toLowerCase();
    return keywords.any((keyword) => lowerText.contains(keyword));
  }

  Future<void> _generateStoryboard() async {
    if (_detectedScenes.isEmpty) return;

    ref.read(isGeneratingStoryboardProvider.notifier).state = true;
    
    try {
      final frames = <StoryboardFrame>[];
      final scenesToVisualize = _storyboardType == StoryboardType.keyScenes 
          ? _detectedScenes.take(4).toList()
          : _detectedScenes;
      
      for (int i = 0; i < scenesToVisualize.length; i++) {
        final scene = scenesToVisualize[i];
        final visualDescription = _enhanceSceneForVisualization(scene);
        
        // Mock generation - replace with actual service call
        await Future.delayed(const Duration(seconds: 2));
        
        final frame = StoryboardFrame(
          id: 'frame_${DateTime.now().millisecondsSinceEpoch}_$i',
          sceneText: scene,
          visualDescription: visualDescription,
          imageUrl: 'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch + i}',
          sequenceNumber: i + 1,
          style: _selectedStyle,
          createdAt: DateTime.now(),
        );
        
        frames.add(frame);
      }
      
      ref.read(storyboardProvider.notifier).state = frames;
      widget.onStoryboardGenerated?.call(frames);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Generated storyboard with ${frames.length} frames!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate storyboard: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      ref.read(isGeneratingStoryboardProvider.notifier).state = false;
    }
  }

  String _enhanceSceneForVisualization(String scene) {
    final buffer = StringBuffer();
    
    // Add style descriptor
    buffer.write('${_selectedStyle.description}, ');
    
    // Add character information if available
    if (widget.characterNames?.isNotEmpty == true) {
      buffer.write('featuring ${widget.characterNames!.join(', ')}, ');
    }
    
    // Add scene content
    buffer.write(scene);
    
    // Add quality descriptors
    buffer.write(', cinematic composition, detailed, high quality');
    
    return buffer.toString();
  }

  void _showFrameDetails(StoryboardFrame frame) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.primaryBackground,
          child: Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frame ${frame.sequenceNumber}',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: CachedNetworkImage(
                    imageUrl: frame.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Scene Description:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  frame.sceneText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Visual Description:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  frame.visualDescription,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
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

  void _showVisualizationOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryBackground,
          title: Text(
            'Visualization Options',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.auto_fix_high, color: AppColors.karigorGold),
                title: Text(
                  'Auto Scene Detection',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                subtitle: Text(
                  'Automatically identify visual scenes',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _analyzeStoryForScenes();
                },
              ),
              ListTile(
                leading: Icon(Icons.timeline, color: AppColors.karigorGold),
                title: Text(
                  'Timeline View',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                subtitle: Text(
                  'View story progression chronologically',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Show timeline view
                },
              ),
            ],
          ),
          actions: [
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
        );
      },
    );
  }

  void _exportStoryboard() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon!'),
      ),
    );
  }
}

enum StoryboardType {
  keyScenes,
  fullStoryboard;

  String get displayName {
    switch (this) {
      case StoryboardType.keyScenes:
        return 'Key Scenes';
      case StoryboardType.fullStoryboard:
        return 'Full Storyboard';
    }
  }

  String get description {
    switch (this) {
      case StoryboardType.keyScenes:
        return 'Generate key moments only';
      case StoryboardType.fullStoryboard:
        return 'Generate all detected scenes';
    }
  }
}
