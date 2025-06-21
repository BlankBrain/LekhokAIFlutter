import 'package:json_annotation/json_annotation.dart';

enum SceneElementType {
  character,
  object,
  background,
  lighting,
  effect;

  String get displayName {
    switch (this) {
      case SceneElementType.character:
        return 'Character';
      case SceneElementType.object:
        return 'Object';
      case SceneElementType.background:
        return 'Background';
      case SceneElementType.lighting:
        return 'Lighting';
      case SceneElementType.effect:
        return 'Effect';
    }
  }
}

enum SceneLayout {
  closeUp,
  mediumShot,
  fullShot,
  wideShot,
  aerialView,
  lowAngle,
  highAngle,
  eyeLevel;

  String get displayName {
    switch (this) {
      case SceneLayout.closeUp:
        return 'Close-up';
      case SceneLayout.mediumShot:
        return 'Medium Shot';
      case SceneLayout.fullShot:
        return 'Full Shot';
      case SceneLayout.wideShot:
        return 'Wide Shot';
      case SceneLayout.aerialView:
        return 'Aerial View';
      case SceneLayout.lowAngle:
        return 'Low Angle';
      case SceneLayout.highAngle:
        return 'High Angle';
      case SceneLayout.eyeLevel:
        return 'Eye Level';
    }
  }

  String get description {
    switch (this) {
      case SceneLayout.closeUp:
        return 'Focus on details, intimate perspective';
      case SceneLayout.mediumShot:
        return 'Balanced view, good for dialogue';
      case SceneLayout.fullShot:
        return 'Full subject visible, context included';
      case SceneLayout.wideShot:
        return 'Expansive view, environment emphasis';
      case SceneLayout.aerialView:
        return 'Bird\'s eye perspective from above';
      case SceneLayout.lowAngle:
        return 'Looking up, creates power/drama';
      case SceneLayout.highAngle:
        return 'Looking down, creates vulnerability';
      case SceneLayout.eyeLevel:
        return 'Natural, neutral perspective';
    }
  }
}

class ScenePosition {
  final double x;
  final double y;
  final double z;
  final double scale;
  final double rotation;

  const ScenePosition({
    required this.x,
    required this.y,
    this.z = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'z': z,
    'scale': scale,
    'rotation': rotation,
  };

  factory ScenePosition.fromJson(Map<String, dynamic> json) {
    return ScenePosition(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num?)?.toDouble() ?? 0.0,
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ScenePosition copyWith({
    double? x,
    double? y,
    double? z,
    double? scale,
    double? rotation,
  }) {
    return ScenePosition(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }
}

class SceneElement {
  final String id;
  final SceneElementType type;
  final String name;
  final String description;
  final String? imageUrl;
  final ScenePosition position;
  final Map<String, dynamic> properties;
  final bool isLocked;
  final bool isVisible;

  const SceneElement({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.position,
    this.properties = const {},
    this.isLocked = false,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'name': name,
    'description': description,
    'image_url': imageUrl,
    'position': position.toJson(),
    'properties': properties,
    'is_locked': isLocked,
    'is_visible': isVisible,
  };

  factory SceneElement.fromJson(Map<String, dynamic> json) {
    return SceneElement(
      id: json['id'],
      type: SceneElementType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      position: ScenePosition.fromJson(json['position']),
      properties: Map<String, dynamic>.from(json['properties'] ?? {}),
      isLocked: json['is_locked'] ?? false,
      isVisible: json['is_visible'] ?? true,
    );
  }

  SceneElement copyWith({
    String? id,
    SceneElementType? type,
    String? name,
    String? description,
    String? imageUrl,
    ScenePosition? position,
    Map<String, dynamic>? properties,
    bool? isLocked,
    bool? isVisible,
  }) {
    return SceneElement(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      position: position ?? this.position,
      properties: properties ?? this.properties,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class SceneComposition {
  final String id;
  final String name;
  final String description;
  final SceneLayout layout;
  final List<SceneElement> elements;
  final Map<String, dynamic> sceneSettings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SceneComposition({
    required this.id,
    required this.name,
    required this.description,
    required this.layout,
    required this.elements,
    this.sceneSettings = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'layout': layout.name,
    'elements': elements.map((e) => e.toJson()).toList(),
    'scene_settings': sceneSettings,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory SceneComposition.fromJson(Map<String, dynamic> json) {
    return SceneComposition(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      layout: SceneLayout.values.firstWhere((l) => l.name == json['layout']),
      elements: (json['elements'] as List)
          .map((e) => SceneElement.fromJson(e))
          .toList(),
      sceneSettings: Map<String, dynamic>.from(json['scene_settings'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  SceneComposition copyWith({
    String? id,
    String? name,
    String? description,
    SceneLayout? layout,
    List<SceneElement>? elements,
    Map<String, dynamic>? sceneSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SceneComposition(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      layout: layout ?? this.layout,
      elements: elements ?? this.elements,
      sceneSettings: sceneSettings ?? this.sceneSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Add an element to the scene
  SceneComposition addElement(SceneElement element) {
    final updatedElements = List<SceneElement>.from(elements);
    updatedElements.add(element);
    return copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );
  }

  /// Remove an element from the scene
  SceneComposition removeElement(String elementId) {
    final updatedElements = elements.where((e) => e.id != elementId).toList();
    return copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );
  }

  /// Update an element in the scene
  SceneComposition updateElement(SceneElement updatedElement) {
    final updatedElements = elements.map((e) => 
      e.id == updatedElement.id ? updatedElement : e
    ).toList();
    return copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );
  }

  /// Get elements by type
  List<SceneElement> getElementsByType(SceneElementType type) {
    return elements.where((e) => e.type == type).toList();
  }

  /// Get visible elements
  List<SceneElement> get visibleElements {
    return elements.where((e) => e.isVisible).toList();
  }

  /// Generate prompt for the entire scene
  String generateScenePrompt() {
    final buffer = StringBuffer();
    
    // Add layout description
    buffer.write('${layout.description}, ');
    
    // Add elements by type
    final characters = getElementsByType(SceneElementType.character);
    final objects = getElementsByType(SceneElementType.object);
    final background = getElementsByType(SceneElementType.background);
    final lighting = getElementsByType(SceneElementType.lighting);
    final effects = getElementsByType(SceneElementType.effect);

    if (characters.isNotEmpty) {
      buffer.write('featuring ${characters.map((c) => c.name).join(', ')}, ');
    }

    if (objects.isNotEmpty) {
      buffer.write('with ${objects.map((o) => o.name).join(', ')}, ');
    }

    if (background.isNotEmpty) {
      buffer.write('set in ${background.map((b) => b.description).join(' and ')}, ');
    }

    if (lighting.isNotEmpty) {
      buffer.write('illuminated by ${lighting.map((l) => l.description).join(' and ')}, ');
    }

    if (effects.isNotEmpty) {
      buffer.write('enhanced with ${effects.map((e) => e.description).join(' and ')}, ');
    }

    // Add scene settings
    if (sceneSettings.isNotEmpty) {
      final settingsText = sceneSettings.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
      buffer.write('$settingsText, ');
    }

    return buffer.toString().trimRight().replaceAll(RegExp(r',\s*$'), '');
  }
}

/// Predefined scene templates
class SceneTemplates {
  static const List<Map<String, dynamic>> templates = [
    {
      'name': 'Character Portrait',
      'description': 'Simple character focus with background',
      'layout': SceneLayout.mediumShot,
      'elements': [
        {
          'type': SceneElementType.character,
          'name': 'Main Character',
          'position': {'x': 0.5, 'y': 0.5, 'scale': 1.2},
        },
        {
          'type': SceneElementType.background,
          'name': 'Portrait Background',
          'position': {'x': 0.5, 'y': 0.5, 'z': -1.0},
        },
        {
          'type': SceneElementType.lighting,
          'name': 'Portrait Lighting',
          'description': 'soft studio lighting',
          'position': {'x': 0.3, 'y': 0.2},
        },
      ],
    },
    {
      'name': 'Epic Battle Scene',
      'description': 'Wide action scene with multiple characters',
      'layout': SceneLayout.wideShot,
      'elements': [
        {
          'type': SceneElementType.character,
          'name': 'Hero',
          'position': {'x': 0.3, 'y': 0.6, 'scale': 0.8},
        },
        {
          'type': SceneElementType.character,
          'name': 'Villain',
          'position': {'x': 0.7, 'y': 0.6, 'scale': 0.8},
        },
        {
          'type': SceneElementType.background,
          'name': 'Battlefield',
          'description': 'dramatic battlefield with ruins',
          'position': {'x': 0.5, 'y': 0.5, 'z': -1.0},
        },
        {
          'type': SceneElementType.effect,
          'name': 'Battle Effects',
          'description': 'sparks, smoke, magical energy',
          'position': {'x': 0.5, 'y': 0.4},
        },
        {
          'type': SceneElementType.lighting,
          'name': 'Dramatic Lighting',
          'description': 'dramatic lighting with strong shadows',
          'position': {'x': 0.2, 'y': 0.1},
        },
      ],
    },
    {
      'name': 'Cozy Interior',
      'description': 'Warm indoor scene with character',
      'layout': SceneLayout.fullShot,
      'elements': [
        {
          'type': SceneElementType.character,
          'name': 'Character',
          'position': {'x': 0.4, 'y': 0.7, 'scale': 0.9},
        },
        {
          'type': SceneElementType.background,
          'name': 'Cozy Room',
          'description': 'warm, cozy interior with fireplace',
          'position': {'x': 0.5, 'y': 0.5, 'z': -1.0},
        },
        {
          'type': SceneElementType.object,
          'name': 'Furniture',
          'description': 'comfortable furniture and decorations',
          'position': {'x': 0.6, 'y': 0.8},
        },
        {
          'type': SceneElementType.lighting,
          'name': 'Ambient Lighting',
          'description': 'warm, soft lighting from fireplace',
          'position': {'x': 0.7, 'y': 0.3},
        },
      ],
    },
    {
      'name': 'Mystical Forest',
      'description': 'Magical forest scene with ethereal elements',
      'layout': SceneLayout.wideShot,
      'elements': [
        {
          'type': SceneElementType.character,
          'name': 'Mystical Being',
          'position': {'x': 0.3, 'y': 0.8, 'scale': 0.7},
        },
        {
          'type': SceneElementType.background,
          'name': 'Enchanted Forest',
          'description': 'mystical forest with ancient trees',
          'position': {'x': 0.5, 'y': 0.5, 'z': -1.0},
        },
        {
          'type': SceneElementType.effect,
          'name': 'Magic Effects',
          'description': 'floating lights, magical particles, mist',
          'position': {'x': 0.5, 'y': 0.4},
        },
        {
          'type': SceneElementType.lighting,
          'name': 'Ethereal Lighting',
          'description': 'dappled sunlight through trees, magical glow',
          'position': {'x': 0.6, 'y': 0.2},
        },
      ],
    },
  ];

  static SceneComposition createFromTemplate(Map<String, dynamic> template) {
    final elements = (template['elements'] as List).map((elementData) {
      final position = ScenePosition.fromJson(elementData['position']);
      return SceneElement(
        id: DateTime.now().millisecondsSinceEpoch.toString() + elementData['name'].hashCode.toString(),
        type: elementData['type'] as SceneElementType,
        name: elementData['name'],
        description: elementData['description'] ?? elementData['name'],
        position: position,
      );
    }).toList();

    return SceneComposition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: template['name'],
      description: template['description'],
      layout: template['layout'] as SceneLayout,
      elements: elements,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<String> get templateNames => templates.map((t) => t['name'] as String).toList();
}