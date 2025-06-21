import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:math' as math;

/// Performance optimizer with various optimization strategies
class PerformanceOptimizer {
  static final PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  bool _optimizationsEnabled = true;
  final Map<String, dynamic> _cache = {};
  Timer? _cacheCleanupTimer;

  void initialize() {
    // Start cache cleanup timer
    _cacheCleanupTimer?.cancel();
    _cacheCleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _cleanupCache(),
    );
  }

  void dispose() {
    _cacheCleanupTimer?.cancel();
    _cache.clear();
  }

  void enableOptimizations() => _optimizationsEnabled = true;
  void disableOptimizations() => _optimizationsEnabled = false;

  T? getCached<T>(String key) => _cache[key] as T?;
  void setCached<T>(String key, T value) => _cache[key] = value;

  void _cleanupCache() {
    if (_cache.length > 100) {
      // Keep only the most recent 50 entries
      final keys = _cache.keys.toList();
      for (int i = 0; i < keys.length - 50; i++) {
        _cache.remove(keys[i]);
      }
    }
  }
}

/// Optimized ListView with visibility detection
class OptimizedListView extends StatefulWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemHeight;

  const OptimizedListView({
    super.key,
    required this.children,
    this.controller,
    this.shrinkWrap = false,
    this.padding,
    this.itemHeight,
  });

  @override
  State<OptimizedListView> createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<OptimizedListView> {
  late ScrollController _scrollController;
  final Set<int> _visibleIndices = {};

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibleItems());
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    _updateVisibleItems();
  }

  void _updateVisibleItems() {
    if (!mounted) return;

    final viewport = RenderAbstractViewport.of(context);
    if (viewport == null) return;

    final scrollOffset = _scrollController.offset;
    final viewportHeight = viewport.paintBounds.height;
    final itemHeight = widget.itemHeight ?? 60.0;

    final startIndex = math.max(0, (scrollOffset / itemHeight).floor() - 2);
    final endIndex = math.min(
      widget.children.length - 1,
      ((scrollOffset + viewportHeight) / itemHeight).ceil() + 2,
    );

    setState(() {
      _visibleIndices.clear();
      for (int i = startIndex; i <= endIndex; i++) {
        _visibleIndices.add(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        if (_visibleIndices.contains(index)) {
          return widget.children[index];
        } else {
          return SizedBox(
            height: widget.itemHeight ?? 60.0,
            child: const SizedBox.shrink(),
          );
        }
      },
    );
  }
}

/// Intelligent image caching with memory management
class OptimizedCachedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<OptimizedCachedImage> createState() => _OptimizedCachedImageState();
}

class _OptimizedCachedImageState extends State<OptimizedCachedImage> {
  ImageProvider? _imageProvider;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(OptimizedCachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  void _loadImage() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Check cache first
    final optimizer = PerformanceOptimizer();
    final cachedProvider = optimizer.getCached<ImageProvider>('image_${widget.imageUrl}');
    
    if (cachedProvider != null) {
      setState(() {
        _imageProvider = cachedProvider;
        _isLoading = false;
      });
      return;
    }

    // Load new image
    final provider = NetworkImage(widget.imageUrl);
    provider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, synchronousCall) {
          if (mounted) {
            optimizer.setCached('image_${widget.imageUrl}', provider);
            setState(() {
              _imageProvider = provider;
              _isLoading = false;
            });
          }
        },
        onError: (error, stackTrace) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? 
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        );
    }

    if (_hasError) {
      return widget.errorWidget ?? 
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
    }

    return Image(
      image: _imageProvider!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}

/// Lazy loading widget with threshold-based rendering
class LazyLoadingWidget extends StatefulWidget {
  final Widget child;
  final double threshold;
  final Widget? placeholder;

  const LazyLoadingWidget({
    super.key,
    required this.child,
    this.threshold = 200.0,
    this.placeholder,
  });

  @override
  State<LazyLoadingWidget> createState() => _LazyLoadingWidgetState();
}

class _LazyLoadingWidgetState extends State<LazyLoadingWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.hashCode),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible 
          ? widget.child 
          : widget.placeholder ?? const SizedBox.shrink(),
    );
  }
}

/// Memory-optimized widget builder
class MemoryOptimizedBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final Duration cacheDuration;

  const MemoryOptimizedBuilder({
    super.key,
    required this.builder,
    this.cacheDuration = const Duration(minutes: 5),
  });

  @override
  State<MemoryOptimizedBuilder> createState() => _MemoryOptimizedBuilderState();
}

class _MemoryOptimizedBuilderState extends State<MemoryOptimizedBuilder> {
  Widget? _cachedWidget;
  DateTime? _cacheTime;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    
    if (_cachedWidget == null || 
        _cacheTime == null || 
        now.difference(_cacheTime!).abs() > widget.cacheDuration) {
      _cachedWidget = widget.builder(context);
      _cacheTime = now;
    }

    return _cachedWidget!;
  }
}

/// Debounced function wrapper
class DebouncedFunction {
  final Duration delay;
  final VoidCallback callback;
  Timer? _timer;

  DebouncedFunction({
    required this.delay,
    required this.callback,
  });

  void call() {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Throttled function wrapper
class ThrottledFunction {
  final Duration interval;
  final VoidCallback callback;
  DateTime? _lastCall;

  ThrottledFunction({
    required this.interval,
    required this.callback,
  });

  void call() {
    final now = DateTime.now();
    if (_lastCall == null || now.difference(_lastCall!).abs() >= interval) {
      _lastCall = now;
      callback();
    }
  }
}

/// Performance-aware animation controller
class OptimizedAnimationController extends AnimationController {
  static const int _maxFPS = 60;
  static const Duration _frameDuration = Duration(microseconds: 16667); // 1/60 second

  OptimizedAnimationController({
    required super.vsync,
    super.duration,
    super.value,
  });

  @override
  TickerFuture forward({double? from}) {
    final optimizer = PerformanceOptimizer();
    if (!optimizer._optimizationsEnabled) {
      return super.forward(from: from);
    }

    // Reduce animation complexity based on performance
    final frameRate = SchedulerBinding.instance.currentFrameTimeStamp;
    if (frameRate.inMicroseconds > _frameDuration.inMicroseconds * 2) {
      // Performance is poor, reduce animation quality
      return animateTo(1.0, duration: duration! ~/ 2);
    }

    return super.forward(from: from);
  }
}

/// Visibility detector helper
class VisibilityDetector extends StatefulWidget {
  final Key key;
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: widget.child,
    );
  }

  void _checkVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final renderObject = context.findRenderObject();
      if (renderObject is RenderBox) {
        final viewport = RenderAbstractViewport.of(context);
        if (viewport != null) {
          final visibility = viewport.getOffsetToReveal(renderObject, 0.0);
          final visibleFraction = _calculateVisibleFraction(renderObject, viewport);
          
          widget.onVisibilityChanged(VisibilityInfo(
            key: widget.key!,
            size: renderObject.size,
            visibleFraction: visibleFraction,
          ));
        }
      }
    });
  }

  double _calculateVisibleFraction(RenderBox renderBox, RenderAbstractViewport viewport) {
    final paintBounds = viewport.paintBounds;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final visibleLeft = math.max(0.0, paintBounds.left - position.dx);
    final visibleTop = math.max(0.0, paintBounds.top - position.dy);
    final visibleRight = math.min(size.width, paintBounds.right - position.dx);
    final visibleBottom = math.min(size.height, paintBounds.bottom - position.dy);

    final visibleArea = math.max(0.0, visibleRight - visibleLeft) * 
                      math.max(0.0, visibleBottom - visibleTop);
    final totalArea = size.width * size.height;

    return totalArea > 0 ? visibleArea / totalArea : 0.0;
  }
}

/// Visibility info class
class VisibilityInfo {
  final Key key;
  final Size size;
  final double visibleFraction;

  const VisibilityInfo({
    required this.key,
    required this.size,
    required this.visibleFraction,
  });
}

/// Performance monitoring widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.showOverlay = false,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  double _fps = 60.0;
  int _frameCount = 0;
  DateTime _lastTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      SchedulerBinding.instance.addPostFrameCallback(_onFrame);
    }
  }

  void _onFrame(Duration timestamp) {
    if (!mounted) return;

    _frameCount++;
    final now = DateTime.now();
    final elapsed = now.difference(_lastTime);

    if (elapsed.inMilliseconds >= 1000) {
      setState(() {
        _fps = _frameCount / elapsed.inSeconds;
        _frameCount = 0;
        _lastTime = now;
      });
    }

    SchedulerBinding.instance.addPostFrameCallback(_onFrame);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showOverlay)
          Positioned(
            top: 50,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'FPS: ${_fps.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
