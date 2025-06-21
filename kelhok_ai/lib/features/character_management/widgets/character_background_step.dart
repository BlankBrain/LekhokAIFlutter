import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../models/character_models.dart';

class CharacterBackgroundStep extends StatefulWidget {
  final Character character;
  final Function(Character) onUpdate;

  const CharacterBackgroundStep({
    super.key,
    required this.character,
    required this.onUpdate,
  });

  @override
  State<CharacterBackgroundStep> createState() => _CharacterBackgroundStepState();
}

class _CharacterBackgroundStepState extends State<CharacterBackgroundStep> {
  late final TextEditingController _occupationController;
  late final TextEditingController _originController;
  late final TextEditingController _educationController;
  late final TextEditingController _familyController;
  late final TextEditingController _relationshipsController;
  late final TextEditingController _experiencesController;
  late final TextEditingController _goalController;
  late final TextEditingController _backstoryController;

  final List<String> _occupationOptions = [
    'Warrior', 'Mage', 'Rogue', 'Cleric', 'Ranger', 'Bard', 'Paladin', 'Sorcerer',
    'Merchant', 'Noble', 'Scholar', 'Craftsman', 'Farmer', 'Sailor', 'Guard', 'Thief',
    'Healer', 'Teacher', 'Soldier', 'Assassin', 'Diplomat', 'Explorer', 'Inventor', 'Artist'
  ];

  final List<String> _originOptions = [
    'Royal Palace', 'Small Village', 'Large City', 'Mountain Fortress', 'Forest Settlement',
    'Desert Oasis', 'Coastal Town', 'Underground City', 'Floating Island', 'Monastery',
    'Traveling Caravan', 'Pirate Ship', 'Magical Academy', 'Military Camp', 'Thieves\' Guild',
    'Temple', 'Library', 'Laboratory', 'Farm', 'Castle', 'Ruins', 'Another Dimension'
  ];

  final List<String> _educationOptions = [
    'Self-taught', 'Formal Academy', 'Apprenticeship', 'Military Training', 'Religious Education',
    'Street Learning', 'Private Tutoring', 'Guild Training', 'University', 'Magical Institution',
    'Tribal Wisdom', 'Court Education', 'Monastery Learning', 'Mentorship', 'Combat School'
  ];

  @override
  void initState() {
    super.initState();
    final background = widget.character.background;
    
    _occupationController = TextEditingController(text: background.occupation ?? '');
    _originController = TextEditingController(text: background.origin ?? '');
    _educationController = TextEditingController(text: background.education ?? '');
    _familyController = TextEditingController(text: background.family ?? '');
    _relationshipsController = TextEditingController(text: background.relationships.join(', '));
    _experiencesController = TextEditingController(text: background.pastExperiences.join(', '));
    _goalController = TextEditingController(text: background.currentGoal ?? '');
    _backstoryController = TextEditingController(text: background.backstory ?? '');
  }

  @override
  void dispose() {
    _occupationController.dispose();
    _originController.dispose();
    _educationController.dispose();
    _familyController.dispose();
    _relationshipsController.dispose();
    _experiencesController.dispose();
    _goalController.dispose();
    _backstoryController.dispose();
    super.dispose();
  }

  void _updateCharacter() {
    final relationships = _relationshipsController.text
        .split(',')
        .map((rel) => rel.trim())
        .where((rel) => rel.isNotEmpty)
        .toList();

    final experiences = _experiencesController.text
        .split(',')
        .map((exp) => exp.trim())
        .where((exp) => exp.isNotEmpty)
        .toList();

    final updatedBackground = widget.character.background.copyWith(
      occupation: _occupationController.text.isEmpty ? null : _occupationController.text,
      origin: _originController.text.isEmpty ? null : _originController.text,
      education: _educationController.text.isEmpty ? null : _educationController.text,
      family: _familyController.text.isEmpty ? null : _familyController.text,
      relationships: relationships,
      pastExperiences: experiences,
      currentGoal: _goalController.text.isEmpty ? null : _goalController.text,
      backstory: _backstoryController.text.isEmpty ? null : _backstoryController.text,
    );

    final updatedCharacter = widget.character.copyWith(
      background: updatedBackground,
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
            'Background & History',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Define your character\'s past and what shaped them',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // Current Life
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Life',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                _buildDropdownField(
                  'Occupation',
                  _occupationController.text,
                  _occupationOptions,
                  (value) {
                    _occupationController.text = value ?? '';
                    _updateCharacter();
                  },
                ),
                
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Current Goal',
                  _goalController,
                  'What is your character trying to achieve?',
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Origins
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Origins',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                _buildDropdownField(
                  'Place of Origin',
                  _originController.text,
                  _originOptions,
                  (value) {
                    _originController.text = value ?? '';
                    _updateCharacter();
                  },
                ),
                
                const SizedBox(height: AppSizes.md),
                
                _buildDropdownField(
                  'Education',
                  _educationController.text,
                  _educationOptions,
                  (value) {
                    _educationController.text = value ?? '';
                    _updateCharacter();
                  },
                ),
                
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Family Background',
                  _familyController,
                  'Describe your character\'s family situation',
                  maxLines: 2,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Relationships & Experiences
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Relationships & Experiences',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Key Relationships',
                  _relationshipsController,
                  'Important people in your character\'s life (comma-separated)',
                  maxLines: 2,
                ),
                
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Past Experiences',
                  _experiencesController,
                  'Significant events that shaped your character (comma-separated)',
                  maxLines: 3,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Backstory
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backstory',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Tell your character\'s complete story',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Character Backstory',
                  _backstoryController,
                  'Write a detailed backstory that brings your character to life...',
                  maxLines: 6,
                ),
                
                const SizedBox(height: AppSizes.md),
                
                // Character count
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.karigorGold,
                      size: 16,
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      '${_backstoryController.text.length} characters',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Background Presets
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Background Presets',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Apply common background templates',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: [
                    _buildPresetChip('Noble Born', _getNoblePreset),
                    _buildPresetChip('Orphan', _getOrphanPreset),
                    _buildPresetChip('Soldier', _getSoldierPreset),
                    _buildPresetChip('Scholar', _getScholarPreset),
                    _buildPresetChip('Outcast', _getOutcastPreset),
                    _buildPresetChip('Merchant', _getMerchantPreset),
                    _buildPresetChip('Adventurer', _getAdventurerPreset),
                    _buildPresetChip('Mystic', _getMysticPreset),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Character Summary
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Character Summary',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Review your character\'s complete profile',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                _buildSummaryItem('Name', widget.character.name),
                _buildSummaryItem('Description', widget.character.description),
                _buildSummaryItem('Occupation', _occupationController.text),
                _buildSummaryItem('Origin', _originController.text),
                _buildSummaryItem('Goal', _goalController.text),
                
                if (widget.character.personality.archetype != null)
                  _buildSummaryItem('Archetype', widget.character.personality.archetype!.displayName),
                
                if (widget.character.personality.traits.isNotEmpty)
                  _buildSummaryItem('Traits', widget.character.personality.traits.take(3).join(', ')),
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

  Widget _buildDropdownField(String label, String value, List<String> options, Function(String?) onChanged) {
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
          value: value.isEmpty ? null : value,
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryText,
          ),
          decoration: InputDecoration(
            hintText: 'Select $label',
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

  Widget _buildSummaryItem(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getNoblePreset() {
    setState(() {
      _occupationController.text = 'Noble';
      _originController.text = 'Royal Palace';
      _educationController.text = 'Court Education';
      _familyController.text = 'Wealthy noble family with political influence';
      _relationshipsController.text = 'Royal court, other nobles, servants';
      _experiencesController.text = 'Raised in luxury, political intrigue, formal training';
      _goalController.text = 'Maintain family honor and expand influence';
      _backstoryController.text = 'Born into nobility, raised with privilege and responsibility. Trained in politics, etiquette, and leadership from a young age.';
      _updateCharacter();
    });
  }

  void _getOrphanPreset() {
    setState(() {
      _occupationController.text = 'Rogue';
      _originController.text = 'Small Village';
      _educationController.text = 'Street Learning';
      _familyController.text = 'Orphaned at young age, no known family';
      _relationshipsController.text = 'Street friends, mentor figure, fellow orphans';
      _experiencesController.text = 'Survived on streets, learned to steal, found surrogate family';
      _goalController.text = 'Find belonging and create a family of choice';
      _backstoryController.text = 'Lost parents early in life, learned to survive on the streets. Developed strong bonds with fellow outcasts and a fierce independence.';
      _updateCharacter();
    });
  }

  void _getSoldierPreset() {
    setState(() {
      _occupationController.text = 'Soldier';
      _originController.text = 'Military Camp';
      _educationController.text = 'Military Training';
      _familyController.text = 'Military family with tradition of service';
      _relationshipsController.text = 'Fellow soldiers, commanding officers, military family';
      _experiencesController.text = 'Combat training, battlefield experience, camaraderie';
      _goalController.text = 'Serve with honor and protect the innocent';
      _backstoryController.text = 'Born into a military family, enlisted young and rose through the ranks. Experienced in combat and leadership, values duty and loyalty.';
      _updateCharacter();
    });
  }

  void _getScholarPreset() {
    setState(() {
      _occupationController.text = 'Scholar';
      _originController.text = 'Library';
      _educationController.text = 'University';
      _familyController.text = 'Family of academics and researchers';
      _relationshipsController.text = 'Fellow scholars, mentors, students';
      _experiencesController.text = 'Years of study, research discoveries, academic debates';
      _goalController.text = 'Advance knowledge and understanding';
      _backstoryController.text = 'Dedicated to learning from an early age, spent years in libraries and universities. Seeks to unlock the mysteries of the world through study.';
      _updateCharacter();
    });
  }

  void _getOutcastPreset() {
    setState(() {
      _occupationController.text = 'Wanderer';
      _originController.text = 'Ruins';
      _educationController.text = 'Self-taught';
      _familyController.text = 'Rejected by family and community';
      _relationshipsController.text = 'Other outcasts, animals, spirits';
      _experiencesController.text = 'Exile, survival in wilderness, supernatural encounters';
      _goalController.text = 'Find acceptance or prove worth to society';
      _backstoryController.text = 'Cast out from society for reasons beyond their control. Learned to survive alone and developed unique perspectives on life.';
      _updateCharacter();
    });
  }

  void _getMerchantPreset() {
    setState(() {
      _occupationController.text = 'Merchant';
      _originController.text = 'Coastal Town';
      _educationController.text = 'Apprenticeship';
      _familyController.text = 'Family of traders and merchants';
      _relationshipsController.text = 'Trade contacts, customers, business partners';
      _experiencesController.text = 'Trade negotiations, travel, market economics';
      _goalController.text = 'Build successful trading empire';
      _backstoryController.text = 'Grew up in a trading family, learned the value of negotiation and commerce. Traveled widely and understands different cultures.';
      _updateCharacter();
    });
  }

  void _getAdventurerPreset() {
    setState(() {
      _occupationController.text = 'Explorer';
      _originController.text = 'Traveling Caravan';
      _educationController.text = 'Self-taught';
      _familyController.text = 'Nomadic family of travelers';
      _relationshipsController.text = 'Fellow adventurers, guides, locals met on travels';
      _experiencesController.text = 'Exploration, treasure hunting, dangerous encounters';
      _goalController.text = 'Discover new lands and ancient secrets';
      _backstoryController.text = 'Born to wander, never stayed in one place long. Driven by curiosity and the thrill of discovery to explore the unknown.';
      _updateCharacter();
    });
  }

  void _getMysticPreset() {
    setState(() {
      _occupationController.text = 'Mystic';
      _originController.text = 'Monastery';
      _educationController.text = 'Religious Education';
      _familyController.text = 'Given to temple as child, spiritual family';
      _relationshipsController.text = 'Spiritual mentors, fellow mystics, spirits';
      _experiencesController.text = 'Meditation, visions, spiritual awakening';
      _goalController.text = 'Achieve enlightenment and spiritual balance';
      _backstoryController.text = 'Dedicated to spiritual pursuits from a young age. Seeks understanding of the divine and the nature of existence itself.';
      _updateCharacter();
    });
  }
}