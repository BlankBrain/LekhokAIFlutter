import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/styles/app_text_styles.dart';
import '../../../shared/styles/app_colors.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../widgets/scene_builder_widget.dart';
import '../models/scene_composition_models.dart';
import '../services/scene_composition_service.dart';
import '../services/enhanced_image_service.dart';
import 'package:dio/dio.dart';

// Providers
final sceneCompositionServiceProvider = Provider<SceneCompositionService>((ref) {
  return SceneCompositionService(Dio());
});

final enhancedImageServiceProvider = Provider<EnhancedImageService>((ref) {
  return EnhancedImageService(Dio());
});

final elementLibraryProvider = FutureProvider<List<SceneElement>>((ref) async {
  final service = ref.read(sceneCompositionServiceProvider);
  return service.getElementLibrary();
});

final currentCompositionProvider = StateProvider<SceneComposition?>((ref) {
  return null;
});

final isGeneratingProvider = StateProvider<bool>((ref) => false);
final generatedImageUrlProvider = StateProvider<String?>((ref) => null);

class SceneCompositionScreen extends ConsumerStatefulWidget {
  const SceneCompositionScreen({super.key});

  @override
  ConsumerState<SceneCompositionScreen> createState() => _SceneCompositionScreenState();
}

class _SceneCompositionScreenState extends ConsumerState<SceneCompositionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initializeWithTemplate();
  }

  void _initializeWithTemplate() {
    final service = ref.read(sceneCompositionServiceProvider);
    final template = service.createFromTemplate('Character Portrait');
    ref.read(currentCompositionProvider.notifier).state = template;
  }

  @override
  Widget build(BuildContext context) {
    final composition = ref.watch(currentCompositionProvider);
    final elementLibraryAsync = ref.watch(elementLibraryProvider);
    final isGenerating = ref.watch(isGeneratingProvider);
    final generatedImageUrl = ref.watch(generatedImageUrlProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: LoadingOverlay(
        isLoading: isGenerating,
        child: composition == null
            ? _buildInitialSetup()
            : PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildTemplateSelectionPage(),
                  _buildSceneBuilderPage(composition, elementLibraryAsync),
                  _buildGenerationPage(composition, generatedImageUrl),
                ],
              ),
      ),
      bottomNavigationBar: composition != null ? _buildBottomNavigation() : null,
      floatingActionButton: composition != null && _currentPage == 1 
          ? _buildGenerateButton() 
          : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        'Scene Composer',
        style: AppTextStyles.headingMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        if (ref.watch(currentCompositionProvider) != null)
          IconButton(
            onPressed: _saveComposition,
            icon: const Icon(Icons.save),
          ),
        IconButton(
          onPressed: _showCompositionInfo,
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }

  Widget _buildInitialSetup() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_camera_back,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Scene Composer',
            style: AppTextStyles.headingLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Create complex scenes with drag-and-drop elements',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              'Get Started',
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a Template',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start with a pre-designed scene template or create from scratch',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Create from scratch option
          GestureDetector(
            onTap: _createBlankComposition,
            child: GlassmorphicContainer(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create from Scratch',
                      style: AppTextStyles.headingSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start with an empty canvas',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Templates',
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 16),
          
          // Template grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: SceneTemplates.templates.length,
            itemBuilder: (context, index) {
              final template = SceneTemplates.templates[index];
              return _buildTemplateCard(template);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    return GestureDetector(
      onTap: () => _selectTemplate(template),
      child: GlassmorphicContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.landscape,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                template['name'],
                style: AppTextStyles.headingSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                template['description'],
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(template['elements'] as List).length} elements',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSceneBuilderPage(SceneComposition composition, AsyncValue<List<SceneElement>> elementLibraryAsync) {
    return elementLibraryAsync.when(
      data: (elementLibrary) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  composition.name,
                  style: AppTextStyles.headingSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: _editCompositionName,
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SceneBuilderWidget(
                composition: composition,
                onCompositionChanged: (updatedComposition) {
                  ref.read(currentCompositionProvider.notifier).state = updatedComposition;
                },
                elementLibrary: elementLibrary,
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load element library',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.refresh(elementLibraryProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerationPage(SceneComposition composition, String? generatedImageUrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generated Scene',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 16),
          
          if (generatedImageUrl != null)
            GlassmorphicContainer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  generatedImageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 300,
                      color: AppColors.surface.withOpacity(0.3),
                      child: const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            )
          else
            GlassmorphicContainer(
              child: Container(
                width: double.infinity,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_camera_back,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Generate your scene to see it here',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Scene prompt
          GlassmorphicContainer(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generated Prompt',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    composition.generateScenePrompt(),
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Scene elements summary
          GlassmorphicContainer(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scene Elements',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 12),
                  ...SceneElementType.values.map((type) {
                    final elements = composition.getElementsByType(type);
                    if (elements.isEmpty) return const SizedBox.shrink();
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            _getElementTypeIcon(type),
                            size: 16,
                            color: _getElementTypeColor(type),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${type.displayName}s: ${elements.length}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.view_list, 'Templates'),
          _buildNavItem(1, Icons.edit, 'Builder'),
          _buildNavItem(2, Icons.photo, 'Generate'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentPage == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return FloatingActionButton.extended(
      onPressed: _generateScene,
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.auto_awesome, color: Colors.white),
      label: Text(
        'Generate',
        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      ),
    );
  }

  void _selectTemplate(Map<String, dynamic> template) {
    final service = ref.read(sceneCompositionServiceProvider);
    final composition = SceneTemplates.createFromTemplate(template);
    ref.read(currentCompositionProvider.notifier).state = composition;
    
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _createBlankComposition() {
    final composition = SceneComposition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'My Scene',
      description: 'Custom scene composition',
      layout: SceneLayout.eyeLevel,
      elements: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    ref.read(currentCompositionProvider.notifier).state = composition;
    
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _generateScene() async {
    final composition = ref.read(currentCompositionProvider);
    if (composition == null) return;

    ref.read(isGeneratingProvider.notifier).state = true;
    
    try {
      final service = ref.read(sceneCompositionServiceProvider);
      final imageUrl = await service.generateSceneImage(composition);
      
      ref.read(generatedImageUrlProvider.notifier).state = imageUrl;
      
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate scene: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      ref.read(isGeneratingProvider.notifier).state = false;
    }
  }

  Future<void> _saveComposition() async {
    final composition = ref.read(currentCompositionProvider);
    if (composition == null) return;

    try {
      final service = ref.read(sceneCompositionServiceProvider);
      await service.saveComposition(composition);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scene saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save scene: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editCompositionName() {
    final composition = ref.read(currentCompositionProvider);
    if (composition == null) return;

    showDialog(
      context: context,
      builder: (context) {
        String newName = composition.name;
        return AlertDialog(
          title: const Text('Edit Scene Name'),
          content: TextField(
            onChanged: (value) => newName = value,
            decoration: const InputDecoration(
              hintText: 'Enter scene name',
            ),
            controller: TextEditingController(text: composition.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedComposition = composition.copyWith(name: newName);
                ref.read(currentCompositionProvider.notifier).state = updatedComposition;
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showCompositionInfo() {
    final composition = ref.read(currentCompositionProvider);
    if (composition == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(composition.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Layout: ${composition.layout.displayName}'),
              const SizedBox(height: 8),
              Text('Elements: ${composition.elements.length}'),
              const SizedBox(height: 8),
              Text('Created: ${composition.createdAt.toString().split(' ')[0]}'),
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

  Color _getElementTypeColor(SceneElementType type) {
    switch (type) {
      case SceneElementType.character:
        return AppColors.primary;
      case SceneElementType.object:
        return Colors.orange;
      case SceneElementType.background:
        return Colors.green;
      case SceneElementType.lighting:
        return Colors.yellow;
      case SceneElementType.effect:
        return Colors.purple;
    }
  }

  IconData _getElementTypeIcon(SceneElementType type) {
    switch (type) {
      case SceneElementType.character:
        return Icons.person;
      case SceneElementType.object:
        return Icons.category;
      case SceneElementType.background:
        return Icons.landscape;
      case SceneElementType.lighting:
        return Icons.lightbulb;
      case SceneElementType.effect:
        return Icons.auto_awesome;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}