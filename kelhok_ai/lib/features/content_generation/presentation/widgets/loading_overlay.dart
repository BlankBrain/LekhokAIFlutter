import 'package:flutter/material.dart';
import '../../../../core/utils/constants.dart';

/// Loading overlay widget that covers the screen during API calls
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.defaultPadding * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  TextConstants.loadingText,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 