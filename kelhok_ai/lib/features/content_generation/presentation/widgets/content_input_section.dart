import 'package:flutter/material.dart';
import '../../../../core/utils/constants.dart';

/// Reusable widget for content input section
class ContentInputSection extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String buttonText;
  final VoidCallback onGenerate;

  const ContentInputSection({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.buttonText,
    required this.onGenerate,
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
        
        // Text Input Field
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        
        const SizedBox(height: 16.0),
        
        // Generate Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canGenerate() ? onGenerate : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ],
    );
  }

  /// Checks if the generate button should be enabled
  bool _canGenerate() {
    return controller.text.trim().isNotEmpty;
  }
} 