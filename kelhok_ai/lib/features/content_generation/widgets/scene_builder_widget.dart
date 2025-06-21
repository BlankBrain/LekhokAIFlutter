import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/styles/app_text_styles.dart';
import '../../../shared/styles/app_colors.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../models/scene_composition_models.dart';

class SceneBuilderWidget extends StatefulWidget {
  final SceneComposition composition;
  final Function(SceneComposition) onCompositionChanged;
  final List<SceneElement> elementLibrary;

  const SceneBuilderWidget({
    super.key,
    required this.composition,
    required this.onCompositionChanged,
    required this.elementLibrary,
  });

  @override
  State<SceneBuilderWidget> createState() => _SceneBuilderWidgetState();
}

class _SceneBuilderWidgetState extends State<SceneBuilderWidget> {
  SceneElement? selectedElement;
  bool isShowingElementLibrary = false;
  SceneElementType? selectedElementType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scene Canvas
        Expanded(
          flex: 2,
          child: _buildSceneCanvas(),
        ),
        
        // Controls
        Container(
          height: 200,
          child: Column(
            children: [
              _buildLayoutSelector(),
              const SizedBox(height: 8),
              Expanded(
                child: isShowingElementLibrary 
                  ? _buildElementLibrary()
                  : _buildSelectedElementControls(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSceneCanvas() {
    return GlassmorphicContainer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface.withOpacity(0.1),
              AppColors.surface.withOpacity(0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background indication
            Center(
              child: Text(
                widget.composition.layout.displayName,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Scene elements
            ...widget.composition.elements.map(_buildSceneElement),
            
            // Add element button
            Positioned(
              top: 16,
              right: 16,
              child: _buildAddElementButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSceneElement(SceneElement element) {
    final isSelected = selectedElement?.id == element.id;
    
    return Positioned(
      left: element.position.x * MediaQuery.of(context).size.width * 0.8,
      top: element.position.y * 300, // Assuming canvas height of ~300
      child: GestureDetector(
        onTap: () => _selectElement(element),
        onPanUpdate: (details) => _moveElement(element, details),
        child: Transform.scale(
          scale: element.position.scale,
          child: Transform.rotate(
            angle: element.position.rotation,
            child: Container(
              width: _getElementSize(element),
              height: _getElementSize(element),
              decoration: BoxDecoration(
                border: isSelected 
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: _buildElementContent(element),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildElementContent(SceneElement element) {
    switch (element.type) {
      case SceneElementType.character:
      case SceneElementType.object:
      case SceneElementType.background:
        if (element.imageUrl != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: element.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildElementPlaceholder(element),
              errorWidget: (context, url, error) => _buildElementPlaceholder(element),
            ),
          );
        }
        return _buildElementPlaceholder(element);
        
      case SceneElementType.lighting:
        return Container(
          decoration: BoxDecoration(
            color: Colors.yellow.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.yellow, width: 1),
          ),
          child: Icon(
            Icons.lightbulb,
            color: Colors.yellow,
            size: _getElementSize(element) * 0.6,
          ),
        );
        
      case SceneElementType.effect:
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Icon(
            Icons.auto_awesome,
            color: AppColors.primary,
            size: _getElementSize(element) * 0.6,
          ),
        );
    }
  }

  Widget _buildElementPlaceholder(SceneElement element) {
    return Container(
      decoration: BoxDecoration(
        color: _getElementTypeColor(element.type).withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getElementTypeColor(element.type), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getElementTypeIcon(element.type),
            color: _getElementTypeColor(element.type),
            size: _getElementSize(element) * 0.4,
          ),
          if (_getElementSize(element) > 40)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                element.name,
                style: AppTextStyles.bodySmall.copyWith(
                  color: _getElementTypeColor(element.type),
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddElementButton() {
    return FloatingActionButton.small(
      onPressed: () {
        setState(() {
          isShowingElementLibrary = !isShowingElementLibrary;
        });
      },
      backgroundColor: AppColors.primary,
      child: Icon(
        isShowingElementLibrary ? Icons.close : Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLayoutSelector() {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Layout:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: SceneLayout.values.map((layout) {
                  final isSelected = widget.composition.layout == layout;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _updateLayout(layout),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? AppColors.primary
                            : AppColors.surface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected 
                              ? AppColors.primary
                              : AppColors.border,
                          ),
                        ),
                        child: Text(
                          layout.displayName,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isSelected 
                              ? Colors.white
                              : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementLibrary() {
    return Column(
      children: [
        // Element type filter
        Container(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildElementTypeFilter(null, 'All'),
                ...SceneElementType.values.map((type) => 
                  _buildElementTypeFilter(type, type.displayName)
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Element grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _getFilteredElements().length,
            itemBuilder: (context, index) {
              final element = _getFilteredElements()[index];
              return _buildLibraryElementCard(element);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildElementTypeFilter(SceneElementType? type, String label) {
    final isSelected = selectedElementType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedElementType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected 
              ? AppColors.primary
              : AppColors.surface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryElementCard(SceneElement element) {
    return GestureDetector(
      onTap: () => _addElementToScene(element),
      child: GlassmorphicContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (element.imageUrl != null)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: element.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Icon(
                      _getElementTypeIcon(element.type),
                      color: _getElementTypeColor(element.type),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      _getElementTypeIcon(element.type),
                      color: _getElementTypeColor(element.type),
                    ),
                  ),
                ),
              )
            else
              Icon(
                _getElementTypeIcon(element.type),
                color: _getElementTypeColor(element.type),
                size: 24,
              ),
            const SizedBox(height: 4),
            Text(
              element.name,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedElementControls() {
    if (selectedElement == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app,
              color: AppColors.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Select an element to edit',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              selectedElement!.name,
              style: AppTextStyles.headingSmall,
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _removeElement(selectedElement!),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
        
        // Scale control
        Row(
          children: [
            Text('Scale:', style: AppTextStyles.bodySmall),
            Expanded(
              child: Slider(
                value: selectedElement!.position.scale,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                onChanged: (value) => _updateElementScale(value),
              ),
            ),
            Text(
              '${(selectedElement!.position.scale * 100).round()}%',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        
        // Rotation control
        Row(
          children: [
            Text('Rotation:', style: AppTextStyles.bodySmall),
            Expanded(
              child: Slider(
                value: selectedElement!.position.rotation,
                min: -3.14,
                max: 3.14,
                divisions: 20,
                onChanged: (value) => _updateElementRotation(value),
              ),
            ),
            Text(
              '${(selectedElement!.position.rotation * 180 / 3.14).round()}°',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        
        // Visibility toggle
        Row(
          children: [
            Text('Visible:', style: AppTextStyles.bodySmall),
            Switch(
              value: selectedElement!.isVisible,
              onChanged: (value) => _updateElementVisibility(value),
            ),
          ],
        ),
      ],
    );
  }

  void _selectElement(SceneElement element) {
    setState(() {
      selectedElement = element;
      isShowingElementLibrary = false;
    });
  }

  void _moveElement(SceneElement element, DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final canvasSize = renderBox.size;
    
    final newX = (element.position.x * canvasSize.width + details.delta.dx) / canvasSize.width;
    final newY = (element.position.y * 300 + details.delta.dy) / 300; // Canvas height
    
    final clampedX = newX.clamp(0.0, 1.0);
    final clampedY = newY.clamp(0.0, 1.0);
    
    final updatedElement = element.copyWith(
      position: element.position.copyWith(x: clampedX, y: clampedY),
    );
    
    final updatedComposition = widget.composition.updateElement(updatedElement);
    widget.onCompositionChanged(updatedComposition);
    
    setState(() {
      selectedElement = updatedElement;
    });
  }

  void _addElementToScene(SceneElement element) {
    final newElement = element.copyWith(
      id: '${element.id}_${DateTime.now().millisecondsSinceEpoch}',
      position: const ScenePosition(x: 0.5, y: 0.5),
    );
    
    final updatedComposition = widget.composition.addElement(newElement);
    widget.onCompositionChanged(updatedComposition);
    
    setState(() {
      selectedElement = newElement;
      isShowingElementLibrary = false;
    });
  }

  void _removeElement(SceneElement element) {
    final updatedComposition = widget.composition.removeElement(element.id);
    widget.onCompositionChanged(updatedComposition);
    
    setState(() {
      selectedElement = null;
    });
  }

  void _updateLayout(SceneLayout layout) {
    final updatedComposition = widget.composition.copyWith(layout: layout);
    widget.onCompositionChanged(updatedComposition);
  }

  void _updateElementScale(double scale) {
    if (selectedElement == null) return;
    
    final updatedElement = selectedElement!.copyWith(
      position: selectedElement!.position.copyWith(scale: scale),
    );
    
    final updatedComposition = widget.composition.updateElement(updatedElement);
    widget.onCompositionChanged(updatedComposition);
    
    setState(() {
      selectedElement = updatedElement;
    });
  }

  void _updateElementRotation(double rotation) {
    if (selectedElement == null) return;
    
    final updatedElement = selectedElement!.copyWith(
      position: selectedElement!.position.copyWith(rotation: rotation),
    );
    
    final updatedComposition = widget.composition.updateElement(updatedElement);
    widget.onCompositionChanged(updatedComposition);
    
    setState(() {
      selectedElement = updatedElement;
    });
  }

  void _updateElementVisibility(bool isVisible) {
    if (selectedElement == null) return;
    
    final updatedElement = selectedElement!.copyWith(isVisible: isVisible);
    
    final updatedComposition = widget.composition.updateElement(updatedElement);
    widget.onCompositionChanged(updatedComposition);
    
    setState(() {
      selectedElement = updatedElement;
    });
  }

  List<SceneElement> _getFilteredElements() {
    if (selectedElementType == null) {
      return widget.elementLibrary;
    }
    return widget.elementLibrary.where((e) => e.type == selectedElementType).toList();
  }

  double _getElementSize(SceneElement element) {
    switch (element.type) {
      case SceneElementType.character:
        return 80;
      case SceneElementType.object:
        return 60;
      case SceneElementType.background:
        return 100;
      case SceneElementType.lighting:
      case SceneElementType.effect:
        return 40;
    }
  }

  Color _getElementTypeColor(SceneElementType type) {
    switch (type) {
      case SceneElementType.character:
        return AppColors.primary;
      case SceneElementType.object:
        return Colors.orange;
      case SceneElementType.background:
        return Colors.green;
      case SceneElementType.lighting:
        return Colors.yellow;
      case SceneElementType.effect:
        return Colors.purple;
    }
  }

  IconData _getElementTypeIcon(SceneElementType type) {
    switch (type) {
      case SceneElementType.character:
        return Icons.person;
      case SceneElementType.object:
        return Icons.category;
      case SceneElementType.background:
        return Icons.landscape;
      case SceneElementType.lighting:
        return Icons.lightbulb;
      case SceneElementType.effect:
        return Icons.auto_awesome;
    }
  }
}