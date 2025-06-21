import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../models/character_models.dart';

class CharacterAppearanceStep extends StatefulWidget {
  final Character character;
  final Function(Character) onUpdate;

  const CharacterAppearanceStep({
    super.key,
    required this.character,
    required this.onUpdate,
  });

  @override
  State<CharacterAppearanceStep> createState() => _CharacterAppearanceStepState();
}

class _CharacterAppearanceStepState extends State<CharacterAppearanceStep> {
  late final TextEditingController _heightController;
  late final TextEditingController _clothingController;
  late final TextEditingController _featuresController;
  
  String? _selectedGender;
  int? _selectedAge;
  String? _selectedBuild;
  String? _selectedHairColor;
  String? _selectedHairStyle;
  String? _selectedEyeColor;
  String? _selectedSkinTone;

  final List<String> _genderOptions = ['Male', 'Female', 'Non-binary', 'Other'];
  final List<String> _buildOptions = ['Slim', 'Athletic', 'Average', 'Muscular', 'Heavy', 'Petite'];
  final List<String> _hairColors = ['Black', 'Brown', 'Blonde', 'Red', 'Gray', 'White', 'Auburn', 'Silver'];
  final List<String> _hairStyles = ['Short', 'Medium', 'Long', 'Curly', 'Straight', 'Wavy', 'Braided', 'Bald'];
  final List<String> _eyeColors = ['Brown', 'Blue', 'Green', 'Hazel', 'Gray', 'Amber', 'Violet'];
  final List<String> _skinTones = ['Fair', 'Light', 'Medium', 'Olive', 'Tan', 'Dark', 'Deep'];

  @override
  void initState() {
    super.initState();
    final appearance = widget.character.appearance;
    
    _heightController = TextEditingController(text: appearance.height ?? '');
    _clothingController = TextEditingController(text: appearance.clothing ?? '');
    _featuresController = TextEditingController(text: appearance.distinctiveFeatures.join(', '));
    
    _selectedGender = appearance.gender;
    _selectedAge = appearance.age;
    _selectedBuild = appearance.build;
    _selectedHairColor = appearance.hairColor;
    _selectedHairStyle = appearance.hairStyle;
    _selectedEyeColor = appearance.eyeColor;
    _selectedSkinTone = appearance.skinTone;
  }

  @override
  void dispose() {
    _heightController.dispose();
    _clothingController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  void _updateCharacter() {
    final features = _featuresController.text
        .split(',')
        .map((feature) => feature.trim())
        .where((feature) => feature.isNotEmpty)
        .toList();

    final updatedAppearance = widget.character.appearance.copyWith(
      gender: _selectedGender,
      age: _selectedAge,
      height: _heightController.text.isEmpty ? null : _heightController.text,
      build: _selectedBuild,
      hairColor: _selectedHairColor,
      hairStyle: _selectedHairStyle,
      eyeColor: _selectedEyeColor,
      skinTone: _selectedSkinTone,
      distinctiveFeatures: features,
      clothing: _clothingController.text.isEmpty ? null : _clothingController.text,
    );

    final updatedCharacter = widget.character.copyWith(
      appearance: updatedAppearance,
      updatedAt: DateTime.now(),
    );

    widget.onUpdate(updatedCharacter);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Physical Appearance',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Define your character\'s physical characteristics',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // Basic Physical Info
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Information',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                // Gender Selection
                _buildDropdownField(
                  'Gender',
                  _selectedGender,
                  _genderOptions,
                  (value) => setState(() {
                    _selectedGender = value;
                    _updateCharacter();
                  }),
                ),
                
                const SizedBox(height: AppSizes.md),
                
                // Age Input
                _buildAgeSlider(),
                
                const SizedBox(height: AppSizes.md),
                
                // Height Input
                _buildTextField(
                  'Height',
                  _heightController,
                  'e.g., 5\'8", 170cm',
                ),
                
                const SizedBox(height: AppSizes.md),
                
                // Build Selection
                _buildDropdownField(
                  'Build',
                  _selectedBuild,
                  _buildOptions,
                  (value) => setState(() {
                    _selectedBuild = value;
                    _updateCharacter();
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Hair & Eyes
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hair & Eyes',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        'Hair Color',
                        _selectedHairColor,
                        _hairColors,
                        (value) => setState(() {
                          _selectedHairColor = value;
                          _updateCharacter();
                        }),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: _buildDropdownField(
                        'Hair Style',
                        _selectedHairStyle,
                        _hairStyles,
                        (value) => setState(() {
                          _selectedHairStyle = value;
                          _updateCharacter();
                        }),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.md),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        'Eye Color',
                        _selectedEyeColor,
                        _eyeColors,
                        (value) => setState(() {
                          _selectedEyeColor = value;
                          _updateCharacter();
                        }),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: _buildDropdownField(
                        'Skin Tone',
                        _selectedSkinTone,
                        _skinTones,
                        (value) => setState(() {
                          _selectedSkinTone = value;
                          _updateCharacter();
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Additional Details
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Details',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Distinctive Features',
                  _featuresController,
                  'Scars, tattoos, unique marks (comma-separated)',
                  maxLines: 2,
                ),
                
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Clothing Style',
                  _clothingController,
                  'Typical clothing or armor worn',
                  maxLines: 2,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Quick Presets
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Presets',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Apply common appearance presets',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: [
                    _buildPresetChip('Warrior', _getWarriorPreset),
                    _buildPresetChip('Scholar', _getScholarPreset),
                    _buildPresetChip('Rogue', _getRoguePreset),
                    _buildPresetChip('Noble', _getNoblePreset),
                    _buildPresetChip('Mystic', _getMysticPreset),
                    _buildPresetChip('Commoner', _getCommonerPreset),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        TextField(
          controller: controller,
          onChanged: (_) => _updateCharacter(),
          maxLines: maxLines,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryText,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              borderSide: BorderSide(color: AppColors.karigorGold),
            ),
            filled: true,
            fillColor: AppColors.glassBackground.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryText,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              borderSide: BorderSide(color: AppColors.karigorGold),
            ),
            filled: true,
            fillColor: AppColors.glassBackground.withOpacity(0.3),
          ),
          dropdownColor: AppColors.cardBackground,
          items: options.map((option) => DropdownMenuItem(
            value: option,
            child: Text(
              option,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildAgeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Age',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_selectedAge ?? 25} years',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.karigorGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Slider(
          value: (_selectedAge ?? 25).toDouble(),
          min: 16,
          max: 100,
          divisions: 84,
          activeColor: AppColors.karigorGold,
          inactiveColor: AppColors.glassBorder,
          onChanged: (value) => setState(() {
            _selectedAge = value.round();
            _updateCharacter();
          }),
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.karigorGold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: AppColors.karigorGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.karigorGold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _getWarriorPreset() {
    setState(() {
      _selectedBuild = 'Muscular';
      _selectedHairStyle = 'Short';
      _selectedEyeColor = 'Brown';
      _clothingController.text = 'Armor and practical clothing';
      _featuresController.text = 'Battle scars, strong posture';
      _updateCharacter();
    });
  }

  void _getScholarPreset() {
    setState(() {
      _selectedBuild = 'Slim';
      _selectedHairStyle = 'Medium';
      _selectedEyeColor = 'Blue';
      _clothingController.text = 'Robes and scholarly attire';
      _featuresController.text = 'Ink-stained fingers, thoughtful expression';
      _updateCharacter();
    });
  }

  void _getRoguePreset() {
    setState(() {
      _selectedBuild = 'Athletic';
      _selectedHairColor = 'Black';
      _selectedHairStyle = 'Short';
      _selectedEyeColor = 'Gray';
      _clothingController.text = 'Dark leather outfit with hidden pockets';
      _featuresController.text = 'Quick movements, alert eyes';
      _updateCharacter();
    });
  }

  void _getNoblePreset() {
    setState(() {
      _selectedBuild = 'Average';
      _selectedHairStyle = 'Long';
      _selectedEyeColor = 'Green';
      _clothingController.text = 'Fine clothing and jewelry';
      _featuresController.text = 'Refined posture, well-groomed';
      _updateCharacter();
    });
  }

  void _getMysticPreset() {
    setState(() {
      _selectedHairColor = 'Gray';
      _selectedHairStyle = 'Long';
      _selectedEyeColor = 'Violet';
      _clothingController.text = 'Mystical robes with arcane symbols';
      _featuresController.text = 'Glowing eyes, ethereal presence';
      _updateCharacter();
    });
  }

  void _getCommonerPreset() {
    setState(() {
      _selectedBuild = 'Average';
      _selectedHairColor = 'Brown';
      _selectedHairStyle = 'Medium';
      _selectedEyeColor = 'Brown';
      _clothingController.text = 'Simple, practical clothing';
      _featuresController.text = 'Weathered hands, honest face';
      _updateCharacter();
    });
  }
} 