import 'package:dio/dio.dart';
import '../models/scene_composition_models.dart';

class SceneCompositionService {
  final Dio _dio;

  SceneCompositionService(this._dio);

  /// Get all available scene elements for the element library
  Future<List<SceneElement>> getElementLibrary() async {
    try {
      // For now, using mock data - replace with actual API call
      return _getMockElementLibrary();
    } catch (e) {
      // Fallback to mock data
      return _getMockElementLibrary();
    }
  }

  /// Get elements filtered by type
  Future<List<SceneElement>> getElementsByType(SceneElementType type) async {
    final allElements = await getElementLibrary();
    return allElements.where((element) => element.type == type).toList();
  }

  /// Save a scene composition
  Future<SceneComposition> saveComposition(SceneComposition composition) async {
    try {
      final response = await _dio.post(
        '/api/scenes',
        data: composition.toJson(),
      );
      return SceneComposition.fromJson(response.data);
    } catch (e) {
      // For development, return the composition with updated timestamp
      return composition.copyWith(updatedAt: DateTime.now());
    }
  }

  /// Load saved compositions
  Future<List<SceneComposition>> getUserCompositions() async {
    try {
      final response = await _dio.get('/api/scenes');
      return (response.data as List)
          .map((json) => SceneComposition.fromJson(json))
          .toList();
    } catch (e) {
      // Return mock saved compositions
      return _getMockSavedCompositions();
    }
  }

  /// Generate image from scene composition
  Future<String> generateSceneImage(SceneComposition composition) async {
    try {
      final prompt = composition.generateScenePrompt();
      final response = await _dio.post(
        '/api/generate-scene-image',
        data: {
          'prompt': prompt,
          'composition': composition.toJson(),
        },
      );
      return response.data['image_url'];
    } catch (e) {
      // Return mock image URL for development
      return 'https://picsum.photos/1024/1024?random=${composition.id}';
    }
  }

  /// Create scene from template
  SceneComposition createFromTemplate(String templateName) {
    final template = SceneTemplates.templates.firstWhere(
      (t) => t['name'] == templateName,
      orElse: () => SceneTemplates.templates.first,
    );
    return SceneTemplates.createFromTemplate(template);
  }

  /// Get scene layout options
  List<SceneLayout> getSceneLayouts() {
    return SceneLayout.values;
  }

  /// Suggest elements based on current scene content
  Future<List<SceneElement>> suggestElements(SceneComposition composition) async {
    try {
      // Analyze current scene and suggest complementary elements
      final suggestions = <SceneElement>[];
      final elementLibrary = await getElementLibrary();
      
      // Basic suggestion logic
      final hasCharacters = composition.getElementsByType(SceneElementType.character).isNotEmpty;
      final hasBackground = composition.getElementsByType(SceneElementType.background).isNotEmpty;
      final hasLighting = composition.getElementsByType(SceneElementType.lighting).isNotEmpty;
      
      if (!hasCharacters) {
        suggestions.addAll(
          elementLibrary.where((e) => e.type == SceneElementType.character).take(3)
        );
      }
      
      if (!hasBackground) {
        suggestions.addAll(
          elementLibrary.where((e) => e.type == SceneElementType.background).take(2)
        );
      }
      
      if (!hasLighting) {
        suggestions.addAll(
          elementLibrary.where((e) => e.type == SceneElementType.lighting).take(2)
        );
      }
      
      return suggestions;
    } catch (e) {
      return [];
    }
  }

  /// Mock element library for development
  List<SceneElement> _getMockElementLibrary() {
    return [
      // Characters
      SceneElement(
        id: 'char_hero',
        type: SceneElementType.character,
        name: 'Hero Character',
        description: 'Brave protagonist ready for adventure',
        imageUrl: 'https://picsum.photos/200/200?random=1',
        position: const ScenePosition(x: 0.5, y: 0.5),
      ),
      SceneElement(
        id: 'char_villain',
        type: SceneElementType.character,
        name: 'Dark Villain',
        description: 'Menacing antagonist with dark powers',
        imageUrl: 'https://picsum.photos/200/200?random=2',
        position: const ScenePosition(x: 0.5, y: 0.5),
      ),
      SceneElement(
        id: 'char_wizard',
        type: SceneElementType.character,
        name: 'Wise Wizard',
        description: 'Ancient spellcaster with mystical knowledge',
        imageUrl: 'https://picsum.photos/200/200?random=3',
        position: const ScenePosition(x: 0.5, y: 0.5),
      ),
      SceneElement(
        id: 'char_warrior',
        type: SceneElementType.character,
        name: 'Noble Warrior',
        description: 'Skilled fighter with honor and courage',
        imageUrl: 'https://picsum.photos/200/200?random=4',
        position: const ScenePosition(x: 0.5, y: 0.5),
      ),

      // Backgrounds
      SceneElement(
        id: 'bg_forest',
        type: SceneElementType.background,
        name: 'Enchanted Forest',
        description: 'Mystical forest with ancient trees and magical atmosphere',
        imageUrl: 'https://picsum.photos/800/600?random=10',
        position: const ScenePosition(x: 0.5, y: 0.5, z: -1.0),
      ),
      SceneElement(
        id: 'bg_castle',
        type: SceneElementType.background,
        name: 'Medieval Castle',
        description: 'Grand castle with towering spires and stone walls',
        imageUrl: 'https://picsum.photos/800/600?random=11',
        position: const ScenePosition(x: 0.5, y: 0.5, z: -1.0),
      ),
      SceneElement(
        id: 'bg_mountain',
        type: SceneElementType.background,
        name: 'Mountain Range',
        description: 'Majestic mountains with snow-capped peaks',
        imageUrl: 'https://picsum.photos/800/600?random=12',
        position: const ScenePosition(x: 0.5, y: 0.5, z: -1.0),
      ),
      SceneElement(
        id: 'bg_city',
        type: SceneElementType.background,
        name: 'Futuristic City',
        description: 'Advanced cityscape with neon lights and flying vehicles',
        imageUrl: 'https://picsum.photos/800/600?random=13',
        position: const ScenePosition(x: 0.5, y: 0.5, z: -1.0),
      ),
      SceneElement(
        id: 'bg_tavern',
        type: SceneElementType.background,
        name: 'Cozy Tavern',
        description: 'Warm tavern interior with fireplace and wooden furniture',
        imageUrl: 'https://picsum.photos/800/600?random=14',
        position: const ScenePosition(x: 0.5, y: 0.5, z: -1.0),
      ),

      // Objects
      SceneElement(
        id: 'obj_sword',
        type: SceneElementType.object,
        name: 'Legendary Sword',
        description: 'Gleaming blade with magical properties',
        imageUrl: 'https://picsum.photos/150/150?random=20',
        position: const ScenePosition(x: 0.6, y: 0.7),
      ),
      SceneElement(
        id: 'obj_treasure',
        type: SceneElementType.object,
        name: 'Treasure Chest',
        description: 'Ancient chest filled with gold and gems',
        imageUrl: 'https://picsum.photos/150/150?random=21',
        position: const ScenePosition(x: 0.4, y: 0.8),
      ),
      SceneElement(
        id: 'obj_throne',
        type: SceneElementType.object,
        name: 'Royal Throne',
        description: 'Ornate throne of power and authority',
        imageUrl: 'https://picsum.photos/150/150?random=22',
        position: const ScenePosition(x: 0.5, y: 0.6),
      ),
      SceneElement(
        id: 'obj_crystal',
        type: SceneElementType.object,
        name: 'Magic Crystal',
        description: 'Glowing crystal with arcane energy',
        imageUrl: 'https://picsum.photos/150/150?random=23',
        position: const ScenePosition(x: 0.5, y: 0.4),
      ),

      // Lighting
      SceneElement(
        id: 'light_sunset',
        type: SceneElementType.lighting,
        name: 'Golden Sunset',
        description: 'Warm golden light from the setting sun',
        position: const ScenePosition(x: 0.8, y: 0.2),
      ),
      SceneElement(
        id: 'light_moonlight',
        type: SceneElementType.lighting,
        name: 'Moonlight',
        description: 'Soft silver light from the full moon',
        position: const ScenePosition(x: 0.5, y: 0.1),
      ),
      SceneElement(
        id: 'light_fireplace',
        type: SceneElementType.lighting,
        name: 'Fireplace Glow',
        description: 'Warm orange light from a crackling fireplace',
        position: const ScenePosition(x: 0.3, y: 0.6),
      ),
      SceneElement(
        id: 'light_magic',
        type: SceneElementType.lighting,
        name: 'Magical Aura',
        description: 'Ethereal blue-white magical illumination',
        position: const ScenePosition(x: 0.5, y: 0.3),
      ),

      // Effects
      SceneElement(
        id: 'fx_sparkles',
        type: SceneElementType.effect,
        name: 'Magic Sparkles',
        description: 'Glittering magical particles in the air',
        position: const ScenePosition(x: 0.5, y: 0.4),
      ),
      SceneElement(
        id: 'fx_smoke',
        type: SceneElementType.effect,
        name: 'Mysterious Smoke',
        description: 'Swirling smoke with mystical properties',
        position: const ScenePosition(x: 0.6, y: 0.5),
      ),
      SceneElement(
        id: 'fx_lightning',
        type: SceneElementType.effect,
        name: 'Lightning Bolts',
        description: 'Crackling electrical energy in the air',
        position: const ScenePosition(x: 0.4, y: 0.3),
      ),
      SceneElement(
        id: 'fx_mist',
        type: SceneElementType.effect,
        name: 'Ethereal Mist',
        description: 'Ghostly mist that adds atmosphere',
        position: const ScenePosition(x: 0.5, y: 0.6),
      ),
    ];
  }

  /// Mock saved compositions for development
  List<SceneComposition> _getMockSavedCompositions() {
    return [
      SceneComposition(
        id: 'saved_1',
        name: 'My Epic Scene',
        description: 'A dramatic battle scene I created',
        layout: SceneLayout.wideShot,
        elements: [
          _getMockElementLibrary().firstWhere((e) => e.id == 'char_hero'),
          _getMockElementLibrary().firstWhere((e) => e.id == 'char_villain'),
          _getMockElementLibrary().firstWhere((e) => e.id == 'bg_castle'),
          _getMockElementLibrary().firstWhere((e) => e.id == 'light_sunset'),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      SceneComposition(
        id: 'saved_2',
        name: 'Cozy Tavern Scene',
        description: 'Peaceful tavern interior',
        layout: SceneLayout.fullShot,
        elements: [
          _getMockElementLibrary().firstWhere((e) => e.id == 'char_wizard'),
          _getMockElementLibrary().firstWhere((e) => e.id == 'bg_tavern'),
          _getMockElementLibrary().firstWhere((e) => e.id == 'light_fireplace'),
          _getMockElementLibrary().firstWhere((e) => e.id == 'obj_treasure'),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
} 