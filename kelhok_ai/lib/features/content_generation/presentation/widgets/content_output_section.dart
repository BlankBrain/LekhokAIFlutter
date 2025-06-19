import 'package:flutter/material.dart';
import '../../../../core/utils/constants.dart';
import '../providers/content_generation_state.dart';

/// Reusable widget for displaying generated content
class ContentOutputSection extends StatelessWidget {
  final ContentGenerationState state;
  final String labelText;
  final String copyButtonText;
  final Function(String) onCopy;

  const ContentOutputSection({
    super.key,
    required this.state,
    required this.labelText,
    required this.copyButtonText,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          labelText,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        
        const SizedBox(height: 8.0),
        
        // Content Area
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: _buildContent(context),
          ),
        ),
        
        // Copy Button (only show when there's content to copy)
        if (_hasContent())
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => onCopy(_getContent()),
                icon: const Icon(Icons.copy),
                label: Text(copyButtonText),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the content based on the current state
  Widget _buildContent(BuildContext context) {
    return switch (state) {
      ContentGenerationInitial() => _buildPlaceholder(context),
      ContentGenerationLoading() => _buildLoading(context),
      StoryGenerationSuccess(story: final story) => _buildGeneratedContent(context, story.content),
      CaptionGenerationSuccess(caption: final caption) => _buildGeneratedContent(context, caption.content),
      ContentGenerationError(message: final message) => _buildError(context, message),
      _ => _buildPlaceholder(context), // Default case for any other state
    };
  }

  /// Builds the placeholder content
  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            TextConstants.placeholderText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the loading indicator
  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(TextConstants.loadingText),
        ],
      ),
    );
  }

  /// Builds the generated content display
  Widget _buildGeneratedContent(BuildContext context, String content) {
    return SingleChildScrollView(
      child: SelectableText(
        content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  /// Builds the error display
  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Checks if there's content to copy
  bool _hasContent() {
    return state is StoryGenerationSuccess || state is CaptionGenerationSuccess;
  }

  /// Gets the content to copy
  String _getContent() {
    return switch (state) {
      StoryGenerationSuccess(story: final story) => story.content,
      CaptionGenerationSuccess(caption: final caption) => caption.content,
      _ => '',
    };
  }
} 