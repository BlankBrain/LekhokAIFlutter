import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/constants.dart';
import '../providers/providers.dart';
import '../widgets/content_input_section.dart';
import '../widgets/content_output_section.dart';
import '../widgets/loading_overlay.dart';

/// Main screen for content generation (both story and caption)
class ContentGenerationScreen extends ConsumerStatefulWidget {
  const ContentGenerationScreen({super.key});

  @override
  ConsumerState<ContentGenerationScreen> createState() => _ContentGenerationScreenState();
}

class _ContentGenerationScreenState extends ConsumerState<ContentGenerationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _storyController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _storyController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  /// Copies text to clipboard and shows a snackbar
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(TextConstants.copiedToClipboard),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Generates a story based on the input
  void _generateStory() {
    final prompt = _storyController.text.trim();
    if (prompt.isNotEmpty) {
      ref.read(contentGenerationProvider.notifier).generateStory(prompt);
    }
  }

  /// Generates a caption based on the input
  void _generateCaption() {
    final prompt = _captionController.text.trim();
    if (prompt.isNotEmpty) {
      ref.read(contentGenerationProvider.notifier).generateCaption(prompt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextConstants.appBarTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Story Generator'),
            Tab(text: 'Caption Generator'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildStoryTab(),
              _buildCaptionTab(),
            ],
          ),
          if (isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }

  /// Builds the story generation tab
  Widget _buildStoryTab() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input Section
          ContentInputSection(
            controller: _storyController,
            labelText: TextConstants.storyPromptLabel,
            hintText: TextConstants.storyPromptHint,
            buttonText: TextConstants.generateStoryButton,
            onGenerate: _generateStory,
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Output Section
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final storyState = ref.watch(storyStateProvider);
                return ContentOutputSection(
                  state: storyState,
                  labelText: TextConstants.generatedStoryLabel,
                  copyButtonText: TextConstants.copyStoryButton,
                  onCopy: _copyToClipboard,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the caption generation tab
  Widget _buildCaptionTab() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input Section
          ContentInputSection(
            controller: _captionController,
            labelText: TextConstants.captionPromptLabel,
            hintText: TextConstants.captionPromptHint,
            buttonText: TextConstants.generateCaptionButton,
            onGenerate: _generateCaption,
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Output Section
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final captionState = ref.watch(captionStateProvider);
                return ContentOutputSection(
                  state: captionState,
                  labelText: TextConstants.generatedCaptionLabel,
                  copyButtonText: TextConstants.copyCaptionButton,
                  onCopy: _copyToClipboard,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 