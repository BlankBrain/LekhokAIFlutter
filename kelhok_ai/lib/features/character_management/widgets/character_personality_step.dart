import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../models/character_models.dart';

class CharacterPersonalityStep extends StatefulWidget {
  final Character character;
  final Function(Character) onUpdate;

  const CharacterPersonalityStep({
    super.key,
    required this.character,
    required this.onUpdate,
  });

  @override
  State<CharacterPersonalityStep> createState() => _CharacterPersonalityStepState();
}

class _CharacterPersonalityStepState extends State<CharacterPersonalityStep> {
  late final TextEditingController _speechController;
  late final TextEditingController _mannerismsController;
  
  PersonalityArchetype? _selectedArchetype;
  List<String> _selectedTraits = [];
  List<String> _selectedStrengths = [];
  List<String> _selectedWeaknesses = [];
  List<String> _selectedFears = [];
  List<String> _selectedMotivations = [];

  final List<String> _traitOptions = [
    'Brave', 'Cowardly', 'Kind', 'Cruel', 'Honest', 'Deceptive', 'Loyal', 'Treacherous',
    'Patient', 'Impatient', 'Calm', 'Anxious', 'Confident', 'Insecure', 'Optimistic', 'Pessimistic',
    'Curious', 'Indifferent', 'Generous', 'Selfish', 'Humble', 'Arrogant', 'Wise', 'Foolish',
    'Compassionate', 'Ruthless', 'Disciplined', 'Impulsive', 'Charismatic', 'Awkward'
  ];

  final List<String> _strengthOptions = [
    'Leadership', 'Intelligence', 'Strength', 'Agility', 'Charisma', 'Wisdom', 'Courage', 'Empathy',
    'Creativity', 'Determination', 'Loyalty', 'Honesty', 'Patience', 'Adaptability', 'Intuition',
    'Strategic thinking', 'Combat skills', 'Magic abilities', 'Persuasion', 'Stealth', 'Healing',
    'Knowledge', 'Survival skills', 'Diplomacy', 'Teaching ability'
  ];

  final List<String> _weaknessOptions = [
    'Pride', 'Greed', 'Anger', 'Fear', 'Jealousy', 'Laziness', 'Stubbornness', 'Naivety',
    'Impulsiveness', 'Pessimism', 'Insecurity', 'Addiction', 'Vengefulness', 'Cowardice',
    'Arrogance', 'Selfishness', 'Impatience', 'Recklessness', 'Gullibility', 'Cynicism',
    'Perfectionism', 'Isolation', 'Trust issues', 'Hot temper', 'Overconfidence'
  ];

  final List<String> _fearOptions = [
    'Death', 'Failure', 'Abandonment', 'Betrayal', 'Heights', 'Darkness', 'Spiders', 'Water',
    'Fire', 'Magic', 'Being alone', 'Crowds', 'Commitment', 'Change', 'Loss of control',
    'Being forgotten', 'Pain', 'Rejection', 'Responsibility', 'The unknown', 'Confined spaces',
    'Public speaking', 'Intimacy', 'Authority', 'Being judged'
  ];

  final List<String> _motivationOptions = [
    'Love', 'Power', 'Knowledge', 'Justice', 'Revenge', 'Freedom', 'Family', 'Honor',
    'Wealth', 'Fame', 'Peace', 'Adventure', 'Redemption', 'Survival', 'Discovery',
    'Protection of others', 'Self-improvement', 'Duty', 'Legacy', 'Truth', 'Beauty',
    'Helping others', 'Proving oneself', 'Finding purpose', 'Creating something lasting'
  ];

  @override
  void initState() {
    super.initState();
    final personality = widget.character.personality;
    
    _speechController = TextEditingController(text: personality.speechPattern ?? '');
    _mannerismsController = TextEditingController(text: personality.mannerisms ?? '');
    
    _selectedArchetype = personality.archetype;
    _selectedTraits = List.from(personality.traits);
    _selectedStrengths = List.from(personality.strengths);
    _selectedWeaknesses = List.from(personality.weaknesses);
    _selectedFears = List.from(personality.fears);
    _selectedMotivations = List.from(personality.motivations);
  }

  @override
  void dispose() {
    _speechController.dispose();
    _mannerismsController.dispose();
    super.dispose();
  }

  void _updateCharacter() {
    final updatedPersonality = widget.character.personality.copyWith(
      archetype: _selectedArchetype,
      traits: _selectedTraits,
      strengths: _selectedStrengths,
      weaknesses: _selectedWeaknesses,
      fears: _selectedFears,
      motivations: _selectedMotivations,
      speechPattern: _speechController.text.isEmpty ? null : _speechController.text,
      mannerisms: _mannerismsController.text.isEmpty ? null : _mannerismsController.text,
    );

    final updatedCharacter = widget.character.copyWith(
      personality: updatedPersonality,
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
            'Personality & Traits',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Define your character\'s personality and psychological traits',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // Personality Archetype
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personality Archetype',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Choose a core archetype that defines your character\'s role',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: PersonalityArchetype.values.map((archetype) {
                    final isSelected = _selectedArchetype == archetype;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedArchetype = archetype;
                        _updateCharacter();
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.sm),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.karigorGold.withOpacity(0.2)
                              : AppColors.glassBackground.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          border: Border.all(
                            color: isSelected 
                                ? AppColors.karigorGold
                                : AppColors.glassBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              archetype.displayName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isSelected 
                                    ? AppColors.karigorGold
                                    : AppColors.primaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            SizedBox(
                              width: 120,
                              child: Text(
                                archetype.description,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Character Traits
          _buildMultiSelectSection(
            'Character Traits',
            'Core personality traits that define your character',
            _selectedTraits,
            _traitOptions,
            (traits) => setState(() {
              _selectedTraits = traits;
              _updateCharacter();
            }),
          ),

          const SizedBox(height: AppSizes.md),

          // Strengths
          _buildMultiSelectSection(
            'Strengths',
            'What your character excels at',
            _selectedStrengths,
            _strengthOptions,
            (strengths) => setState(() {
              _selectedStrengths = strengths;
              _updateCharacter();
            }),
          ),

          const SizedBox(height: AppSizes.md),

          // Weaknesses
          _buildMultiSelectSection(
            'Weaknesses',
            'Character flaws and limitations',
            _selectedWeaknesses,
            _weaknessOptions,
            (weaknesses) => setState(() {
              _selectedWeaknesses = weaknesses;
              _updateCharacter();
            }),
          ),

          const SizedBox(height: AppSizes.md),

          // Fears
          _buildMultiSelectSection(
            'Fears',
            'What your character is afraid of',
            _selectedFears,
            _fearOptions,
            (fears) => setState(() {
              _selectedFears = fears;
              _updateCharacter();
            }),
          ),

          const SizedBox(height: AppSizes.md),

          // Motivations
          _buildMultiSelectSection(
            'Motivations',
            'What drives your character',
            _selectedMotivations,
            _motivationOptions,
            (motivations) => setState(() {
              _selectedMotivations = motivations;
              _updateCharacter();
            }),
          ),

          const SizedBox(height: AppSizes.md),

          // Speech & Mannerisms
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Speech & Mannerisms',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Speech Pattern',
                  _speechController,
                  'How does your character speak? (formal, casual, accent, etc.)',
                ),
                
                const SizedBox(height: AppSizes.md),
                
                _buildTextField(
                  'Mannerisms',
                  _mannerismsController,
                  'Distinctive habits or gestures',
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Quick Personality Presets
          GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Personality Presets',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Apply common personality combinations',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                
                Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: [
                    _buildPresetChip('Heroic', _getHeroicPreset),
                    _buildPresetChip('Villainous', _getVillainousPreset),
                    _buildPresetChip('Wise Mentor', _getWiseMentorPreset),
                    _buildPresetChip('Tragic Hero', _getTragicHeroPreset),
                    _buildPresetChip('Comic Relief', _getComicReliefPreset),
                    _buildPresetChip('Mysterious', _getMysteriousPreset),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectSection(
    String title,
    String description,
    List<String> selectedItems,
    List<String> options,
    Function(List<String>) onChanged,
  ) {
    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          
          if (selectedItems.isNotEmpty) ...[
            Text(
              'Selected (${selectedItems.length}):',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.xs,
              runSpacing: AppSizes.xs,
              children: selectedItems.map((item) => Chip(
                label: Text(
                  item,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                backgroundColor: AppColors.karigorGold.withOpacity(0.2),
                deleteIcon: Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.karigorGold,
                ),
                onDeleted: () {
                  final newItems = List<String>.from(selectedItems);
                  newItems.remove(item);
                  onChanged(newItems);
                },
              )).toList(),
            ),
            const SizedBox(height: AppSizes.md),
          ],
          
          Text(
            'Available options:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.xs,
            runSpacing: AppSizes.xs,
            children: options
                .where((option) => !selectedItems.contains(option))
                .map((option) => GestureDetector(
                  onTap: () {
                    final newItems = List<String>.from(selectedItems);
                    newItems.add(option);
                    onChanged(newItems);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.glassBackground.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(
                        color: AppColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      option,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
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

  void _getHeroicPreset() {
    setState(() {
      _selectedArchetype = PersonalityArchetype.hero;
      _selectedTraits = ['Brave', 'Honest', 'Loyal', 'Compassionate'];
      _selectedStrengths = ['Courage', 'Leadership', 'Determination'];
      _selectedWeaknesses = ['Stubbornness', 'Recklessness'];
      _selectedFears = ['Failure', 'Loss of loved ones'];
      _selectedMotivations = ['Justice', 'Protection of others'];
      _speechController.text = 'Noble and inspiring';
      _mannerismsController.text = 'Stands tall, makes direct eye contact';
      _updateCharacter();
    });
  }

  void _getVillainousPreset() {
    setState(() {
      _selectedArchetype = PersonalityArchetype.shadow;
      _selectedTraits = ['Cunning', 'Ruthless', 'Ambitious'];
      _selectedStrengths = ['Intelligence', 'Strategic thinking', 'Persuasion'];
      _selectedWeaknesses = ['Pride', 'Arrogance', 'Paranoia'];
      _selectedFears = ['Being forgotten', 'Loss of control'];
      _selectedMotivations = ['Power', 'Revenge'];
      _speechController.text = 'Smooth and manipulative';
      _mannerismsController.text = 'Calculating stare, steepled fingers';
      _updateCharacter();
    });
  }

  void _getWiseMentorPreset() {
    setState(() {
      _selectedArchetype = PersonalityArchetype.mentor;
      _selectedTraits = ['Wise', 'Patient', 'Kind'];
      _selectedStrengths = ['Knowledge', 'Teaching ability', 'Empathy'];
      _selectedWeaknesses = ['Overprotective', 'Secretive'];
      _selectedFears = ['Students failing', 'Knowledge being lost'];
      _selectedMotivations = ['Helping others', 'Passing on wisdom'];
      _speechController.text = 'Thoughtful and measured';
      _mannerismsController.text = 'Strokes beard, speaks in metaphors';
      _updateCharacter();
    });
  }

  void _getTragicHeroPreset() {
    setState(() {
      _selectedArchetype = PersonalityArchetype.hero;
      _selectedTraits = ['Noble', 'Determined', 'Melancholic'];
      _selectedStrengths = ['Courage', 'Resilience', 'Honor'];
      _selectedWeaknesses = ['Pride', 'Self-doubt', 'Haunted by past'];
      _selectedFears = ['Repeating past mistakes', 'Hurting others'];
      _selectedMotivations = ['Redemption', 'Making amends'];
      _speechController.text = 'Formal but weary';
      _mannerismsController.text = 'Distant gaze, touches old wounds';
      _updateCharacter();
    });
  }

  void _getComicReliefPreset() {
    setState(() {
      _selectedArchetype = PersonalityArchetype.jester;
      _selectedTraits = ['Humorous', 'Optimistic', 'Loyal'];
      _selectedStrengths = ['Humor', 'Morale boosting', 'Adaptability'];
      _selectedWeaknesses = ['Insecurity', 'Avoids serious topics'];
      _selectedFears = ['Being alone', 'Not being funny'];
      _selectedMotivations = ['Making others happy', 'Belonging'];
      _speechController.text = 'Witty and energetic';
      _mannerismsController.text = 'Animated gestures, always smiling';
      _updateCharacter();
    });
  }

  void _getMysteriousPreset() {
    setState(() {
      _selectedArchetype = PersonalityArchetype.shapeshifter;
      _selectedTraits = ['Enigmatic', 'Observant', 'Secretive'];
      _selectedStrengths = ['Intuition', 'Stealth', 'Adaptability'];
      _selectedWeaknesses = ['Trust issues', 'Isolation'];
      _selectedFears = ['Being truly known', 'Vulnerability'];
      _selectedMotivations = ['Hidden agenda', 'Self-preservation'];
      _speechController.text = 'Cryptic and measured';
      _mannerismsController.text = 'Speaks in riddles, avoids direct answers';
      _updateCharacter();
    });
  }
} 