import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_button.dart';
import '../../../shared/widgets/k_text_field.dart';

class StoryGenerationScreen extends ConsumerStatefulWidget {
  const StoryGenerationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StoryGenerationScreen> createState() => _StoryGenerationScreenState();
}

class _StoryGenerationScreenState extends ConsumerState<StoryGenerationScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _selectedCharacter = 'Himu';
  bool _isGenerating = false;
  String? _generatedStory;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generateStory() async {
    if (_promptController.text.trim().isEmpty) return;
    
    setState(() {
      _isGenerating = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      _isGenerating = false;
      _generatedStory = _getCharacterSpecificStory(_selectedCharacter, _promptController.text);
    });
  }

  String _getCharacterSpecificStory(String character, String prompt) {
    switch (character) {
      case 'Himu':
        return '''হিমু একদিন ভাবলো, "$prompt"। 

সে ঢাকার রাস্তায় হাঁটতে হাঁটতে দেখলো একটা অদ্ভুত মানুষ। মানুষটা তার দিকে তাকিয়ে হাসছে। হিমু ভাবলো, "এই লোকটার সাথে কি আমার কোনো পরিচয় আছে?" 

হিমু এগিয়ে গেলো। মানুষটা বললো, "তুমি কি জানো তোমার ভবিষ্যৎ কী?" হিমু বললো, "ভবিষ্যৎ নিয়ে ভাবতে গেলে বর্তমানটা হাতছাড়া হয়ে যায়।"

এই কথা বলে হিমু চলে গেলো। তার মনে হলো, জীবনটা অনেক সহজ যদি মানুষ জটিল না করে। আর এই সরল চিন্তা নিয়েই হিমু তার পথ চলা অব্যাহত রাখলো।

শেষে হিমু বুঝলো, সত্যিকারের গল্প হলো সেটাই যা মানুষের হৃদয় ছুঁয়ে যায়।''';

      case 'Harry Potter':
        return '''Harry Potter received a mysterious letter about "$prompt" during his seventh year at Hogwarts.

The letter appeared on his dormitory table one foggy morning, sealed with an unusual symbol that seemed to shimmer between silver and gold. As Harry opened it, the parchment felt warm to his touch.

"Dear Mr. Potter," it read, "The adventure you seek regarding $prompt awaits you in the Room of Requirement. But beware - not all magic comes without a price."

Harry exchanged worried glances with Ron and Hermione. They had faced many challenges before, but something about this felt different. The magic in the air seemed thicker, more ancient.

As they made their way through the castle corridors, portraits whispered among themselves. The Room of Requirement appeared before them, its door bearing the same shimmering symbol from the letter.

Inside, they discovered that $prompt was not just a simple request, but the key to understanding a long-lost magical secret that would change their understanding of friendship, courage, and the true power of love.''';

      case 'Wonder Woman':
        return '''Diana Prince stood atop Mount Olympus, contemplating the mission ahead: "$prompt".

As an Amazon warrior and protector of humanity, she understood that this challenge would test not only her physical strength but also her wisdom and compassion. The golden Lasso of Truth glowed softly at her side, sensing the importance of what lay ahead.

"$prompt," she whispered to the winds, "will require more than just my powers. It will require understanding the hearts of those I seek to protect."

With a graceful leap, Diana descended from the mountain, her armor gleaming in the sunlight. The people below looked up in wonder as their protector soared through the sky, ready to face whatever challenges awaited.

Through her journey, Diana discovered that true strength comes not from the power of her bracers or the sharpness of her sword, but from the love and hope she carries for all of humanity. The mission revealed that $prompt was not just about saving others, but about inspiring them to find the hero within themselves.

And so, Wonder Woman's legend grew not through conquest, but through the hearts she touched and the hope she kindled in a world that desperately needed both.''';

      case 'Sherlock Holmes':
        return '''The peculiar case of "$prompt" reached 221B Baker Street on a particularly foggy London morning.

"Holmes!" Dr. Watson exclaimed as he burst through the door, "You must see this extraordinary letter that has just arrived."

Sherlock Holmes, pipe in hand, examined the correspondence with his characteristic intensity. "Fascinating, Watson. Note the watermark, the precise penmanship, and the faint scent of lavender. Our correspondent is clearly a woman of considerable education and refinement."

The case involving $prompt proved to be one of the most intriguing mysteries Holmes had ever encountered. As he applied his powers of deduction, each clue revealed another layer of complexity.

"The game is afoot, Watson!" Holmes declared, his eyes gleaming with intellectual excitement. "This case of $prompt will require us to venture into the very heart of London's most hidden secrets."

Through careful observation and logical reasoning, Holmes unraveled the mystery piece by piece. The solution, when it finally emerged, was both startling and elegant in its simplicity.

"You see, Watson," Holmes explained as they sat by the fireplace, "the answer to $prompt was hidden in plain sight all along. It merely required the proper application of deductive reasoning and an understanding of human nature."

And so, another case was closed in the brilliant mind of consulting detective Sherlock Holmes.''';

      default:
        return '''Once upon a time, $_selectedCharacter received an intriguing challenge: "$prompt".

This mysterious quest would lead $_selectedCharacter on an extraordinary adventure filled with unexpected discoveries and valuable lessons.

As the journey unfolded, $_selectedCharacter learned that the greatest adventures often begin with a single step into the unknown, and that courage is not the absence of fear, but the determination to continue despite it.

The tale of $_selectedCharacter and the quest of $prompt became a story that inspired others to follow their dreams and embrace the magic within themselves.''';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Generate Story',
          style: AppTextStyles.headingMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Settings
            },
            icon: Icon(
              Icons.settings_outlined,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCharacterSelector(),
            SizedBox(height: AppSizes.lg),
            _buildStoryPromptInput(),
            SizedBox(height: AppSizes.lg),
            _buildGenerateButton(),
            SizedBox(height: AppSizes.lg),
            Expanded(child: _buildGeneratedStory()),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Character',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.sm),
        KCard(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCharacter,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.karigorGold,
              ),
              items: ['Himu', 'Harry Potter', 'Wonder Woman', 'Sherlock Holmes']
                  .map((character) => DropdownMenuItem(
                        value: character,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: AppColors.karigorGold,
                              size: 20,
                            ),
                            SizedBox(width: AppSizes.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  character,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Professional storyteller',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCharacter = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryPromptInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Story Prompt',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.sm),
        KTextField(
          controller: _promptController,
          hintText: AppStrings.enterStoryPrompt,
          maxLines: 4,
          minLines: 4,
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Center(
      child: KButton(
        text: AppStrings.generateStory,
        onPressed: _isGenerating ? null : _generateStory,
        isLoading: _isGenerating,
        icon: const Icon(Icons.auto_stories, color: Colors.white),
        size: KButtonSize.large,
      ),
    );
  }

  Widget _buildGeneratedStory() {
    if (_generatedStory == null && !_isGenerating) {
      return KCard(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories_outlined,
                size: 64,
                color: AppColors.quaternaryText,
              ),
              SizedBox(height: AppSizes.md),
              Text(
                'Your generated story will appear here',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.quaternaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_isGenerating) {
      return KCard(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.karigorGold),
              ),
              SizedBox(height: AppSizes.md),
              Text(
                'Generating your story...',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generated Story',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Copy to clipboard
                  },
                  icon: Icon(
                    Icons.copy_outlined,
                    color: AppColors.quaternaryText,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Regenerate
                  },
                  icon: Icon(
                    Icons.refresh_outlined,
                    color: AppColors.quaternaryText,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Share
                  },
                  icon: Icon(
                    Icons.share_outlined,
                    color: AppColors.quaternaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppSizes.sm),
        Expanded(
          child: KCard(
            child: SingleChildScrollView(
              child: Text(
                _generatedStory!,
                style: AppTextStyles.bodyMedium.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 