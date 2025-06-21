import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  // Monitoring state
  bool _isMonitoring = false;
  Timer? _monitoringTimer;
  
  // Performance metrics
  final List<FrameTimingData> _frameTimings = [];
  final List<MemoryUsageData> _memoryUsage = [];
  final List<PerformanceEvent> _performanceEvents = [];
  
  // Listeners
  final List<Function(PerformanceMetrics)> _metricsListeners = [];
  final List<Function(PerformanceEvent)> _eventListeners = [];
  
  // Settings
  static const Duration monitoringInterval = Duration(seconds: 1);
  static const int maxDataPoints = 100;
  static const double fpsThreshold = 55.0; // Below this is considered poor
  static const int memoryThresholdMB = 200; // Above this is concerning

  // Performance tracking
  final Map<String, Stopwatch> _activeStopwatches = {};
  final Map<String, List<Duration>> _operationTimes = {};

  // Getters
  bool get isMonitoring => _isMonitoring;
  List<FrameTimingData> get frameTimings => List.unmodifiable(_frameTimings);
  List<MemoryUsageData> get memoryUsage => List.unmodifiable(_memoryUsage);
  List<PerformanceEvent> get performanceEvents => List.unmodifiable(_performanceEvents);

  // Initialize performance monitoring
  void initialize() {
    if (kDebugMode) {
      print('PerformanceMonitor initialized');
      
      // Set up frame timing monitoring
      SchedulerBinding.instance.addTimingsCallback(_onFrameTiming);
      
      // Start monitoring in debug mode
      startMonitoring();
    }
  }

  // Start performance monitoring
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(monitoringInterval, (_) => _collectMetrics());
    
    _addEvent(PerformanceEvent(
      type: PerformanceEventType.monitoringStarted,
      timestamp: DateTime.now(),
      message: 'Performance monitoring started',
    ));
    
    print('Performance monitoring started');
  }

  // Stop performance monitoring
  void stopMonitoring() {
    if (!_isMonitoring) return;
    
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    
    _addEvent(PerformanceEvent(
      type: PerformanceEventType.monitoringStopped,
      timestamp: DateTime.now(),
      message: 'Performance monitoring stopped',
    ));
    
    print('Performance monitoring stopped');
  }

  // Add metrics listener
  void addMetricsListener(Function(PerformanceMetrics) listener) {
    _metricsListeners.add(listener);
  }

  // Remove metrics listener
  void removeMetricsListener(Function(PerformanceMetrics) listener) {
    _metricsListeners.remove(listener);
  }

  // Add event listener
  void addEventListener(Function(PerformanceEvent) listener) {
    _eventListeners.add(listener);
  }

  // Remove event listener
  void removeEventListener(Function(PerformanceEvent) listener) {
    _eventListeners.remove(listener);
  }

  // Frame timing callback
  void _onFrameTiming(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameTime = timing.totalSpan.inMicroseconds / 1000.0; // Convert to milliseconds
      final fps = 1000.0 / frameTime; // Calculate FPS
      
      final frameData = FrameTimingData(
        timestamp: DateTime.now(),
        frameTimeMs: frameTime,
        fps: fps,
        buildDuration: timing.buildDuration.inMicroseconds / 1000.0,
        rasterDuration: timing.rasterDuration.inMicroseconds / 1000.0,
      );
      
      _addFrameTiming(frameData);
      
      // Check for performance issues
      if (fps < fpsThreshold) {
        _addEvent(PerformanceEvent(
          type: PerformanceEventType.lowFps,
          timestamp: DateTime.now(),
          message: 'Low FPS detected: ${fps.toStringAsFixed(1)}',
          data: {'fps': fps, 'frameTime': frameTime},
        ));
      }
    }
  }

  // Collect performance metrics
  void _collectMetrics() {
    // Collect memory usage
    final memoryData = _collectMemoryUsage();
    _addMemoryUsage(memoryData);
    
    // Calculate current metrics
    final metrics = _calculateCurrentMetrics();
    
    // Notify listeners
    for (final listener in _metricsListeners) {
      listener(metrics);
    }
    
    // Check for memory issues
    if (memoryData.usedMB > memoryThresholdMB) {
      _addEvent(PerformanceEvent(
        type: PerformanceEventType.highMemoryUsage,
        timestamp: DateTime.now(),
        message: 'High memory usage: ${memoryData.usedMB.toStringAsFixed(1)} MB',
        data: {'memoryMB': memoryData.usedMB},
      ));
    }
  }

  // Collect memory usage data
  MemoryUsageData _collectMemoryUsage() {
    try {
      final info = ProcessInfo.currentRss;
      final usedMB = info / (1024 * 1024); // Convert bytes to MB
      
      return MemoryUsageData(
        timestamp: DateTime.now(),
        usedMB: usedMB,
        maxMB: _getMaxMemory(),
      );
    } catch (e) {
      print('Error collecting memory usage: $e');
      return MemoryUsageData(
        timestamp: DateTime.now(),
        usedMB: 0,
        maxMB: 0,
      );
    }
  }

  // Get maximum memory available (approximation)
  double _getMaxMemory() {
    // This is a rough estimation for mobile devices
    if (Platform.isIOS) {
      return 1024.0; // 1GB typical for iOS apps
    } else if (Platform.isAndroid) {
      return 512.0; // 512MB typical for Android apps
    }
    return 2048.0; // 2GB for other platforms
  }

  // Calculate current performance metrics
  PerformanceMetrics _calculateCurrentMetrics() {
    final recentFrames = _frameTimings.length > 30 
        ? _frameTimings.sublist(_frameTimings.length - 30)
        : _frameTimings;
    
    final recentMemory = _memoryUsage.length > 10
        ? _memoryUsage.sublist(_memoryUsage.length - 10)
        : _memoryUsage;
    
    double avgFps = 0;
    double avgFrameTime = 0;
    double currentMemory = 0;
    double peakMemory = 0;
    
    if (recentFrames.isNotEmpty) {
      avgFps = recentFrames.map((f) => f.fps).reduce((a, b) => a + b) / recentFrames.length;
      avgFrameTime = recentFrames.map((f) => f.frameTimeMs).reduce((a, b) => a + b) / recentFrames.length;
    }
    
    if (recentMemory.isNotEmpty) {
      currentMemory = recentMemory.last.usedMB;
      peakMemory = recentMemory.map((m) => m.usedMB).reduce((a, b) => a > b ? a : b);
    }
    
    return PerformanceMetrics(
      timestamp: DateTime.now(),
      averageFps: avgFps,
      averageFrameTime: avgFrameTime,
      currentMemoryMB: currentMemory,
      peakMemoryMB: peakMemory,
      operationTimes: Map.from(_operationTimes),
    );
  }

  // Start timing an operation
  void startTiming(String operationName) {
    _activeStopwatches[operationName] = Stopwatch()..start();
  }

  // End timing an operation
  Duration? endTiming(String operationName) {
    final stopwatch = _activeStopwatches.remove(operationName);
    if (stopwatch == null) return null;
    
    stopwatch.stop();
    final duration = stopwatch.elapsed;
    
    // Store operation time
    _operationTimes.putIfAbsent(operationName, () => []).add(duration);
    
    // Keep only recent times
    final times = _operationTimes[operationName]!;
    if (times.length > 50) {
      times.removeRange(0, times.length - 50);
    }
    
    // Log slow operations
    if (duration.inMilliseconds > 100) {
      _addEvent(PerformanceEvent(
        type: PerformanceEventType.slowOperation,
        timestamp: DateTime.now(),
        message: 'Slow operation: $operationName (${duration.inMilliseconds}ms)',
        data: {'operation': operationName, 'duration': duration.inMilliseconds},
      ));
    }
    
    return duration;
  }

  // Measure operation duration
  Future<T> measureOperation<T>(String operationName, Future<T> Function() operation) async {
    startTiming(operationName);
    try {
      final result = await operation();
      return result;
    } finally {
      endTiming(operationName);
    }
  }

  // Measure synchronous operation
  T measureSync<T>(String operationName, T Function() operation) {
    startTiming(operationName);
    try {
      return operation();
    } finally {
      endTiming(operationName);
    }
  }

  // Add frame timing data
  void _addFrameTiming(FrameTimingData data) {
    _frameTimings.add(data);
    if (_frameTimings.length > maxDataPoints) {
      _frameTimings.removeAt(0);
    }
  }

  // Add memory usage data
  void _addMemoryUsage(MemoryUsageData data) {
    _memoryUsage.add(data);
    if (_memoryUsage.length > maxDataPoints) {
      _memoryUsage.removeAt(0);
    }
  }

  // Add performance event
  void _addEvent(PerformanceEvent event) {
    _performanceEvents.add(event);
    if (_performanceEvents.length > maxDataPoints) {
      _performanceEvents.removeAt(0);
    }
    
    // Notify listeners
    for (final listener in _eventListeners) {
      listener(event);
    }
    
    if (kDebugMode) {
      print('Performance Event: ${event.message}');
    }
  }

  // Get performance summary
  PerformanceSummary getPerformanceSummary() {
    final metrics = _calculateCurrentMetrics();
    final issues = _performanceEvents
        .where((e) => e.type == PerformanceEventType.lowFps || 
                     e.type == PerformanceEventType.highMemoryUsage ||
                     e.type == PerformanceEventType.slowOperation)
        .length;
    
    return PerformanceSummary(
      averageFps: metrics.averageFps,
      currentMemoryMB: metrics.currentMemoryMB,
      totalIssues: issues,
      isHealthy: metrics.averageFps > fpsThreshold && 
                 metrics.currentMemoryMB < memoryThresholdMB,
    );
  }

  // Clear all data
  void clearData() {
    _frameTimings.clear();
    _memoryUsage.clear();
    _performanceEvents.clear();
    _operationTimes.clear();
    _activeStopwatches.clear();
    
    print('Performance data cleared');
  }

  // Export performance data
  Map<String, dynamic> exportData() {
    return {
      'frameTimings': _frameTimings.map((f) => f.toJson()).toList(),
      'memoryUsage': _memoryUsage.map((m) => m.toJson()).toList(),
      'events': _performanceEvents.map((e) => e.toJson()).toList(),
      'operationTimes': _operationTimes.map((key, value) => MapEntry(
        key,
        value.map((d) => d.inMilliseconds).toList(),
      )),
      'summary': getPerformanceSummary().toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  // Dispose
  void dispose() {
    stopMonitoring();
    _metricsListeners.clear();
    _eventListeners.clear();
    _activeStopwatches.clear();
  }
}

// Data Models
class FrameTimingData {
  final DateTime timestamp;
  final double frameTimeMs;
  final double fps;
  final double buildDuration;
  final double rasterDuration;

  FrameTimingData({
    required this.timestamp,
    required this.frameTimeMs,
    required this.fps,
    required this.buildDuration,
    required this.rasterDuration,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'frameTimeMs': frameTimeMs,
    'fps': fps,
    'buildDuration': buildDuration,
    'rasterDuration': rasterDuration,
  };
}

class MemoryUsageData {
  final DateTime timestamp;
  final double usedMB;
  final double maxMB;

  MemoryUsageData({
    required this.timestamp,
    required this.usedMB,
    required this.maxMB,
  });

  double get usagePercentage => maxMB > 0 ? (usedMB / maxMB) * 100 : 0;

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'usedMB': usedMB,
    'maxMB': maxMB,
    'usagePercentage': usagePercentage,
  };
}

class PerformanceEvent {
  final PerformanceEventType type;
  final DateTime timestamp;
  final String message;
  final Map<String, dynamic>? data;

  PerformanceEvent({
    required this.type,
    required this.timestamp,
    required this.message,
    this.data,
  });

  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'timestamp': timestamp.toIso8601String(),
    'message': message,
    'data': data,
  };
}

class PerformanceMetrics {
  final DateTime timestamp;
  final double averageFps;
  final double averageFrameTime;
  final double currentMemoryMB;
  final double peakMemoryMB;
  final Map<String, List<Duration>> operationTimes;

  PerformanceMetrics({
    required this.timestamp,
    required this.averageFps,
    required this.averageFrameTime,
    required this.currentMemoryMB,
    required this.peakMemoryMB,
    required this.operationTimes,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'averageFps': averageFps,
    'averageFrameTime': averageFrameTime,
    'currentMemoryMB': currentMemoryMB,
    'peakMemoryMB': peakMemoryMB,
    'operationTimes': operationTimes.map((key, value) => MapEntry(
      key,
      value.map((d) => d.inMilliseconds).toList(),
    )),
  };
}

class PerformanceSummary {
  final double averageFps;
  final double currentMemoryMB;
  final int totalIssues;
  final bool isHealthy;

  PerformanceSummary({
    required this.averageFps,
    required this.currentMemoryMB,
    required this.totalIssues,
    required this.isHealthy,
  });

  String get healthStatus {
    if (isHealthy) return 'Good';
    if (totalIssues < 5) return 'Fair';
    return 'Poor';
  }

  Map<String, dynamic> toJson() => {
    'averageFps': averageFps,
    'currentMemoryMB': currentMemoryMB,
    'totalIssues': totalIssues,
    'isHealthy': isHealthy,
    'healthStatus': healthStatus,
  };
}

// Enums
enum PerformanceEventType {
  monitoringStarted,
  monitoringStopped,
  lowFps,
  highMemoryUsage,
  slowOperation,
  memoryLeak,
  frameSkip,
}

extension PerformanceEventTypeExtension on PerformanceEventType {
  String get displayName {
    switch (this) {
      case PerformanceEventType.monitoringStarted:
        return 'Monitoring Started';
      case PerformanceEventType.monitoringStopped:
        return 'Monitoring Stopped';
      case PerformanceEventType.lowFps:
        return 'Low FPS';
      case PerformanceEventType.highMemoryUsage:
        return 'High Memory Usage';
      case PerformanceEventType.slowOperation:
        return 'Slow Operation';
      case PerformanceEventType.memoryLeak:
        return 'Memory Leak';
      case PerformanceEventType.frameSkip:
        return 'Frame Skip';
    }
  }

  bool get isIssue {
    switch (this) {
      case PerformanceEventType.lowFps:
      case PerformanceEventType.highMemoryUsage:
      case PerformanceEventType.slowOperation:
      case PerformanceEventType.memoryLeak:
      case PerformanceEventType.frameSkip:
        return true;
      default:
        return false;
    }
  }
}
