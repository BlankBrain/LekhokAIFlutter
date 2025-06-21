import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_sizes.dart';

/// Accessibility settings provider
class AccessibilitySettings {
  final bool highContrastMode;
  final double fontScale;
  final bool reducedMotion;
  final bool screenReaderEnabled;

  const AccessibilitySettings({
    this.highContrastMode = false,
    this.fontScale = 1.0,
    this.reducedMotion = false,
    this.screenReaderEnabled = false,
  });

  AccessibilitySettings copyWith({
    bool? highContrastMode,
    double? fontScale,
    bool? reducedMotion,
    bool? screenReaderEnabled,
  }) {
    return AccessibilitySettings(
      highContrastMode: highContrastMode ?? this.highContrastMode,
      fontScale: fontScale ?? this.fontScale,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      screenReaderEnabled: screenReaderEnabled ?? this.screenReaderEnabled,
    );
  }
}

/// Accessibility settings notifier
class AccessibilityNotifier extends StateNotifier<AccessibilitySettings> {
  AccessibilityNotifier() : super(const AccessibilitySettings());

  void toggleHighContrast() {
    state = state.copyWith(highContrastMode: !state.highContrastMode);
  }

  void setFontScale(double scale) {
    state = state.copyWith(fontScale: scale.clamp(0.8, 2.0));
  }

  void toggleReducedMotion() {
    state = state.copyWith(reducedMotion: !state.reducedMotion);
  }

  void toggleScreenReader() {
    state = state.copyWith(screenReaderEnabled: !state.screenReaderEnabled);
  }
}

/// Provider for accessibility settings
final accessibilityProvider = StateNotifierProvider<AccessibilityNotifier, AccessibilitySettings>(
  (ref) => AccessibilityNotifier(),
);

/// Accessible wrapper widget
class AccessibleWrapper extends ConsumerWidget {
  final Widget child;
  final String? semanticLabel;
  final String? hint;
  final bool excludeSemantics;

  const AccessibleWrapper({
    super.key,
    required this.child,
    this.semanticLabel,
    this.hint,
    this.excludeSemantics = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);

    if (excludeSemantics) {
      return child;
    }

    return Semantics(
      label: semanticLabel,
      hint: hint,
      child: settings.screenReaderEnabled
          ? Focus(
              child: child,
            )
          : child,
    );
  }
}

/// High contrast colors
class HighContrastColors {
  static const Color background = Colors.black;
  static const Color surface = Color(0xFF1A1A1A);
  static const Color primary = Colors.white;
  static const Color secondary = Color(0xFFCCCCCC);
  static const Color accent = Color(0xFFFFFF00);
  static const Color error = Color(0xFFFF0000);
  static const Color success = Color(0xFF00FF00);
}

/// Accessible button with enhanced features
class AccessibleButton extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? tooltip;
  final bool primary;
  final EdgeInsetsGeometry? padding;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticLabel,
    this.tooltip,
    this.primary = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);
    
    final colors = settings.highContrastMode
        ? _getHighContrastButtonColors()
        : _getNormalButtonColors();

    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        padding: padding ?? const EdgeInsets.all(AppSizes.md),
        minimumSize: const Size(44, 44), // Minimum touch target
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: BorderSide(
            color: colors.border,
            width: settings.highContrastMode ? 2 : 1,
          ),
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: AppTextStyles.bodyLarge.fontSize! * settings.fontScale,
          fontWeight: settings.highContrastMode ? FontWeight.bold : FontWeight.normal,
        ),
        child: child,
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onPressed != null,
      child: button,
    );
  }

  ButtonColors _getHighContrastButtonColors() {
    return primary
        ? const ButtonColors(
            background: HighContrastColors.accent,
            foreground: HighContrastColors.background,
            border: HighContrastColors.primary,
          )
        : const ButtonColors(
            background: HighContrastColors.surface,
            foreground: HighContrastColors.primary,
            border: HighContrastColors.primary,
          );
  }

  ButtonColors _getNormalButtonColors() {
    return primary
        ? ButtonColors(
            background: AppColors.karigorGold,
            foreground: Colors.white,
            border: AppColors.karigorGold,
          )
        : ButtonColors(
            background: AppColors.glassBackground,
            foreground: AppColors.primaryText,
            border: AppColors.glassBorder,
          );
  }
}

/// Accessible text field
class AccessibleTextField extends ConsumerWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? semanticLabel;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const AccessibleTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.semanticLabel,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);
    
    final colors = settings.highContrastMode
        ? _getHighContrastFieldColors()
        : _getNormalFieldColors();

    return Semantics(
      label: semanticLabel ?? labelText,
      textField: true,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: AppTextStyles.bodyLarge.fontSize! * settings.fontScale,
          color: colors.text,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(
            fontSize: AppTextStyles.bodyMedium.fontSize! * settings.fontScale,
            color: colors.label,
            fontWeight: settings.highContrastMode ? FontWeight.bold : FontWeight.normal,
          ),
          hintStyle: TextStyle(
            fontSize: AppTextStyles.bodyMedium.fontSize! * settings.fontScale,
            color: colors.hint,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: BorderSide(
              color: colors.border,
              width: settings.highContrastMode ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: BorderSide(
              color: colors.focusedBorder,
              width: settings.highContrastMode ? 3 : 2,
            ),
          ),
          filled: true,
          fillColor: colors.background,
          contentPadding: const EdgeInsets.all(AppSizes.md),
        ),
      ),
    );
  }

  FieldColors _getHighContrastFieldColors() {
    return const FieldColors(
      background: HighContrastColors.surface,
      text: HighContrastColors.primary,
      label: HighContrastColors.primary,
      hint: HighContrastColors.secondary,
      border: HighContrastColors.primary,
      focusedBorder: HighContrastColors.accent,
    );
  }

  FieldColors _getNormalFieldColors() {
    return FieldColors(
      background: AppColors.glassBackground.withOpacity(0.1),
      text: AppColors.primaryText,
      label: AppColors.primaryText,
      hint: AppColors.secondaryText,
      border: AppColors.glassBorder,
      focusedBorder: AppColors.karigorGold,
    );
  }
}

/// Keyboard navigation helper
class KeyboardNavigationHelper extends StatefulWidget {
  final Widget child;
  final List<FocusNode>? focusNodes;

  const KeyboardNavigationHelper({
    super.key,
    required this.child,
    this.focusNodes,
  });

  @override
  State<KeyboardNavigationHelper> createState() => _KeyboardNavigationHelperState();
}

class _KeyboardNavigationHelperState extends State<KeyboardNavigationHelper> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: widget.child,
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _moveFocus(1);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _moveFocus(-1);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _moveFocus(int direction) {
    final currentFocus = FocusScope.of(context).focusedChild;
    if (currentFocus != null && widget.focusNodes != null) {
      final currentIndex = widget.focusNodes!.indexOf(currentFocus as FocusNode);
      if (currentIndex != -1) {
        final nextIndex = (currentIndex + direction) % widget.focusNodes!.length;
        widget.focusNodes![nextIndex].requestFocus();
      }
    }
  }
}

/// Screen reader announcements
class ScreenReaderAnnouncer {
  static void announce(String message, {bool interrupt = false}) {
    SystemSound.play(SystemSound.click);
    // In a real implementation, you would use platform channels
    // to communicate with native screen readers
    debugPrint('Screen Reader: $message');
  }

  static void announcePageChange(String pageName) {
    announce('Navigated to $pageName');
  }

  static void announceAction(String action) {
    announce('$action completed');
  }

  static void announceError(String error) {
    announce('Error: $error', interrupt: true);
  }
}

/// Accessibility settings screen
class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);
    final notifier = ref.read(accessibilityProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Settings'),
        backgroundColor: settings.highContrastMode 
            ? HighContrastColors.surface 
            : AppColors.primaryBackground,
        foregroundColor: settings.highContrastMode 
            ? HighContrastColors.primary 
            : AppColors.primaryText,
      ),
      backgroundColor: settings.highContrastMode 
          ? HighContrastColors.background 
          : AppColors.primaryBackground,
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.lg),
        children: [
          AccessibleWrapper(
            semanticLabel: 'High contrast mode toggle',
            child: SwitchListTile(
              title: Text(
                'High Contrast Mode',
                style: TextStyle(
                  fontSize: AppTextStyles.bodyLarge.fontSize! * settings.fontScale,
                  color: settings.highContrastMode 
                      ? HighContrastColors.primary 
                      : AppColors.primaryText,
                ),
              ),
              subtitle: Text(
                'Improves text readability',
                style: TextStyle(
                  fontSize: AppTextStyles.bodyMedium.fontSize! * settings.fontScale,
                  color: settings.highContrastMode 
                      ? HighContrastColors.secondary 
                      : AppColors.secondaryText,
                ),
              ),
              value: settings.highContrastMode,
              onChanged: (_) => notifier.toggleHighContrast(),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          Text(
            'Font Size',
            style: TextStyle(
              fontSize: AppTextStyles.bodyLarge.fontSize! * settings.fontScale,
              fontWeight: FontWeight.bold,
              color: settings.highContrastMode 
                  ? HighContrastColors.primary 
                  : AppColors.primaryText,
            ),
          ),
          AccessibleWrapper(
            semanticLabel: 'Font size slider, current value ${(settings.fontScale * 100).round()}%',
            child: Slider(
              value: settings.fontScale,
              min: 0.8,
              max: 2.0,
              divisions: 12,
              label: '${(settings.fontScale * 100).round()}%',
              onChanged: notifier.setFontScale,
              activeColor: settings.highContrastMode 
                  ? HighContrastColors.accent 
                  : AppColors.karigorGold,
            ),
          ),
          Text(
            'Preview: This is how text will look',
            style: TextStyle(
              fontSize: AppTextStyles.bodyMedium.fontSize! * settings.fontScale,
              color: settings.highContrastMode 
                  ? HighContrastColors.primary 
                  : AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          
          AccessibleWrapper(
            semanticLabel: 'Reduced motion toggle',
            child: SwitchListTile(
              title: Text(
                'Reduced Motion',
                style: TextStyle(
                  fontSize: AppTextStyles.bodyLarge.fontSize! * settings.fontScale,
                  color: settings.highContrastMode 
                      ? HighContrastColors.primary 
                      : AppColors.primaryText,
                ),
              ),
              subtitle: Text(
                'Reduces animations and transitions',
                style: TextStyle(
                  fontSize: AppTextStyles.bodyMedium.fontSize! * settings.fontScale,
                  color: settings.highContrastMode 
                      ? HighContrastColors.secondary 
                      : AppColors.secondaryText,
                ),
              ),
              value: settings.reducedMotion,
              onChanged: (_) => notifier.toggleReducedMotion(),
            ),
          ),
          
          AccessibleWrapper(
            semanticLabel: 'Screen reader support toggle',
            child: SwitchListTile(
              title: Text(
                'Screen Reader Support',
                style: TextStyle(
                  fontSize: AppTextStyles.bodyLarge.fontSize! * settings.fontScale,
                  color: settings.highContrastMode 
                      ? HighContrastColors.primary 
                      : AppColors.primaryText,
                ),
              ),
              subtitle: Text(
                'Enhanced navigation for screen readers',
                style: TextStyle(
                  fontSize: AppTextStyles.bodyMedium.fontSize! * settings.fontScale,
                  color: settings.highContrastMode 
                      ? HighContrastColors.secondary 
                      : AppColors.secondaryText,
                ),
              ),
              value: settings.screenReaderEnabled,
              onChanged: (_) => notifier.toggleScreenReader(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper classes
class ButtonColors {
  final Color background;
  final Color foreground;
  final Color border;

  const ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}

class FieldColors {
  final Color background;
  final Color text;
  final Color label;
  final Color hint;
  final Color border;
  final Color focusedBorder;

  const FieldColors({
    required this.background,
    required this.text,
    required this.label,
    required this.hint,
    required this.border,
    required this.focusedBorder,
  });
}
