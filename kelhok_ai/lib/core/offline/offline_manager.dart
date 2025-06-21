import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineManager {
  static final OfflineManager _instance = OfflineManager._internal();
  factory OfflineManager() => _instance;
  OfflineManager._internal();

  // Storage paths
  late String _documentsPath;
  late String _cachePath;
  bool _isInitialized = false;

  // Connectivity
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = false;
  
  // Pending operations
  final List<OfflineOperation> _pendingOperations = [];
  final List<Function()> _connectivityListeners = [];

  // Cache settings
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheExpiry = Duration(days: 7);

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isOnline => _isOnline;
  List<OfflineOperation> get pendingOperations => List.unmodifiable(_pendingOperations);

  // Initialize offline manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Get storage paths
      final documentsDir = await getApplicationDocumentsDirectory();
      final cacheDir = await getTemporaryDirectory();
      
      _documentsPath = documentsDir.path;
      _cachePath = cacheDir.path;

      // Create offline directories
      await _createOfflineDirectories();

      // Check initial connectivity
      _isOnline = await _checkConnectivity();

      // Listen to connectivity changes
      _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);

      // Load pending operations
      await _loadPendingOperations();

      _isInitialized = true;

      // If online, process pending operations
      if (_isOnline) {
        _processPendingOperations();
      }

      print('OfflineManager initialized successfully');
    } catch (e) {
      print('Failed to initialize OfflineManager: $e');
    }
  }

  // Check connectivity
  Future<bool> _checkConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  // Handle connectivity changes
  void _onConnectivityChanged(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = result != ConnectivityResult.none;

    if (!wasOnline && _isOnline) {
      // Just came online
      print('Connection restored - processing pending operations');
      _processPendingOperations();
    } else if (wasOnline && !_isOnline) {
      // Just went offline
      print('Connection lost - enabling offline mode');
    }

    // Notify listeners
    for (final listener in _connectivityListeners) {
      listener();
    }
  }

  // Add connectivity listener
  void addConnectivityListener(Function() listener) {
    _connectivityListeners.add(listener);
  }

  // Remove connectivity listener
  void removeConnectivityListener(Function() listener) {
    _connectivityListeners.remove(listener);
  }

  // Create offline directories
  Future<void> _createOfflineDirectories() async {
    final directories = [
      '$_documentsPath/offline',
      '$_documentsPath/offline/stories',
      '$_documentsPath/offline/characters',
      '$_documentsPath/offline/images',
      '$_documentsPath/offline/templates',
      '$_cachePath/offline_cache',
    ];

    for (final dir in directories) {
      final directory = Directory(dir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    }
  }

  // Save data offline
  Future<void> saveOfflineData({
    required String key,
    required Map<String, dynamic> data,
    OfflineDataType type = OfflineDataType.general,
  }) async {
    if (!_isInitialized) {
      throw Exception('OfflineManager not initialized');
    }

    try {
      final filePath = _getOfflineFilePath(key, type);
      final file = File(filePath);

      final offlineData = OfflineData(
        key: key,
        data: data,
        timestamp: DateTime.now(),
        type: type,
      );

      await file.writeAsString(jsonEncode(offlineData.toJson()));
      print('Saved offline data: $key');
    } catch (e) {
      print('Error saving offline data: $e');
      throw Exception('Failed to save offline data');
    }
  }

  // Load offline data
  Future<OfflineData?> loadOfflineData({
    required String key,
    OfflineDataType type = OfflineDataType.general,
  }) async {
    if (!_isInitialized) {
      throw Exception('OfflineManager not initialized');
    }

    try {
      final filePath = _getOfflineFilePath(key, type);
      final file = File(filePath);

      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      final json = jsonDecode(content);
      final offlineData = OfflineData.fromJson(json);

      // Check if data has expired
      if (_isDataExpired(offlineData)) {
        await deleteOfflineData(key: key, type: type);
        return null;
      }

      return offlineData;
    } catch (e) {
      print('Error loading offline data: $e');
      return null;
    }
  }

  // Delete offline data
  Future<void> deleteOfflineData({
    required String key,
    OfflineDataType type = OfflineDataType.general,
  }) async {
    try {
      final filePath = _getOfflineFilePath(key, type);
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        print('Deleted offline data: $key');
      }
    } catch (e) {
      print('Error deleting offline data: $e');
    }
  }

  // Cache data temporarily
  Future<void> cacheData({
    required String key,
    required Map<String, dynamic> data,
    Duration? expiry,
  }) async {
    if (!_isInitialized) return;

    try {
      final filePath = '$_cachePath/offline_cache/${key.hashCode}.json';
      final file = File(filePath);

      final cacheData = CacheData(
        key: key,
        data: data,
        timestamp: DateTime.now(),
        expiry: expiry ?? cacheExpiry,
      );

      await file.writeAsString(jsonEncode(cacheData.toJson()));
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  // Load cached data
  Future<Map<String, dynamic>?> loadCachedData(String key) async {
    if (!_isInitialized) return null;

    try {
      final filePath = '$_cachePath/offline_cache/${key.hashCode}.json';
      final file = File(filePath);

      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      final json = jsonDecode(content);
      final cacheData = CacheData.fromJson(json);

      // Check if cache has expired
      if (DateTime.now().isAfter(cacheData.timestamp.add(cacheData.expiry))) {
        await file.delete();
        return null;
      }

      return cacheData.data;
    } catch (e) {
      print('Error loading cached data: $e');
      return null;
    }
  }

  // Add pending operation
  Future<void> addPendingOperation(OfflineOperation operation) async {
    _pendingOperations.add(operation);
    await _savePendingOperations();
    print('Added pending operation: ${operation.type}');
  }

  // Process pending operations
  Future<void> _processPendingOperations() async {
    if (!_isOnline || _pendingOperations.isEmpty) return;

    print('Processing ${_pendingOperations.length} pending operations');

    final operationsToProcess = List<OfflineOperation>.from(_pendingOperations);
    _pendingOperations.clear();

    for (final operation in operationsToProcess) {
      try {
        await _executeOperation(operation);
        print('Successfully executed operation: ${operation.id}');
      } catch (e) {
        print('Failed to execute operation ${operation.id}: $e');
        // Re-add failed operation
        _pendingOperations.add(operation);
      }
    }

    await _savePendingOperations();
  }

  // Execute a single operation
  Future<void> _executeOperation(OfflineOperation operation) async {
    // This would typically make API calls based on operation type
    switch (operation.type) {
      case OperationType.createStory:
        await _executeCreateStory(operation);
        break;
      case OperationType.updateStory:
        await _executeUpdateStory(operation);
        break;
      case OperationType.deleteStory:
        await _executeDeleteStory(operation);
        break;
      case OperationType.createCharacter:
        await _executeCreateCharacter(operation);
        break;
      case OperationType.updateCharacter:
        await _executeUpdateCharacter(operation);
        break;
      case OperationType.deleteCharacter:
        await _executeDeleteCharacter(operation);
        break;
    }
  }

  // Execute create story operation
  Future<void> _executeCreateStory(OfflineOperation operation) async {
    // Make API call to create story
    // This is a placeholder - replace with actual API service
    await Future.delayed(const Duration(seconds: 1));
    print('Executed create story operation');
  }

  // Execute update story operation
  Future<void> _executeUpdateStory(OfflineOperation operation) async {
    // Make API call to update story
    await Future.delayed(const Duration(seconds: 1));
    print('Executed update story operation');
  }

  // Execute delete story operation
  Future<void> _executeDeleteStory(OfflineOperation operation) async {
    // Make API call to delete story
    await Future.delayed(const Duration(seconds: 1));
    print('Executed delete story operation');
  }

  // Execute create character operation
  Future<void> _executeCreateCharacter(OfflineOperation operation) async {
    // Make API call to create character
    await Future.delayed(const Duration(seconds: 1));
    print('Executed create character operation');
  }

  // Execute update character operation
  Future<void> _executeUpdateCharacter(OfflineOperation operation) async {
    // Make API call to update character
    await Future.delayed(const Duration(seconds: 1));
    print('Executed update character operation');
  }

  // Execute delete character operation
  Future<void> _executeDeleteCharacter(OfflineOperation operation) async {
    // Make API call to delete character
    await Future.delayed(const Duration(seconds: 1));
    print('Executed delete character operation');
  }

  // Save pending operations to disk
  Future<void> _savePendingOperations() async {
    try {
      final filePath = '$_documentsPath/offline/pending_operations.json';
      final file = File(filePath);

      final operationsJson = _pendingOperations.map((op) => op.toJson()).toList();
      await file.writeAsString(jsonEncode(operationsJson));
    } catch (e) {
      print('Error saving pending operations: $e');
    }
  }

  // Load pending operations from disk
  Future<void> _loadPendingOperations() async {
    try {
      final filePath = '$_documentsPath/offline/pending_operations.json';
      final file = File(filePath);

      if (!await file.exists()) return;

      final content = await file.readAsString();
      final operationsJson = jsonDecode(content) as List;

      _pendingOperations.clear();
      for (final opJson in operationsJson) {
        _pendingOperations.add(OfflineOperation.fromJson(opJson));
      }

      print('Loaded ${_pendingOperations.length} pending operations');
    } catch (e) {
      print('Error loading pending operations: $e');
    }
  }

  // Get offline file path
  String _getOfflineFilePath(String key, OfflineDataType type) {
    final typeFolder = type.toString().split('.').last;
    return '$_documentsPath/offline/$typeFolder/${key.hashCode}.json';
  }

  // Check if data has expired
  bool _isDataExpired(OfflineData data) {
    final age = DateTime.now().difference(data.timestamp);
    return age > const Duration(days: 30); // 30 days expiry
  }

  // Clean up expired data
  Future<void> cleanupExpiredData() async {
    if (!_isInitialized) return;

    try {
      final offlineDir = Directory('$_documentsPath/offline');
      if (!await offlineDir.exists()) return;

      await for (final entity in offlineDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.json')) {
          try {
            final content = await entity.readAsString();
            final json = jsonDecode(content);
            
            if (json['timestamp'] != null) {
              final timestamp = DateTime.parse(json['timestamp']);
              final age = DateTime.now().difference(timestamp);
              
              if (age > const Duration(days: 30)) {
                await entity.delete();
                print('Deleted expired file: ${entity.path}');
              }
            }
          } catch (e) {
            // If file is corrupted, delete it
            await entity.delete();
          }
        }
      }
    } catch (e) {
      print('Error during cleanup: $e');
    }
  }

  // Get offline storage info
  Future<OfflineStorageInfo> getStorageInfo() async {
    if (!_isInitialized) {
      return OfflineStorageInfo(
        totalSize: 0,
        fileCount: 0,
        lastSync: null,
        pendingOperations: 0,
      );
    }

    try {
      int totalSize = 0;
      int fileCount = 0;
      DateTime? lastSync;

      final offlineDir = Directory('$_documentsPath/offline');
      if (await offlineDir.exists()) {
        await for (final entity in offlineDir.list(recursive: true)) {
          if (entity is File) {
            final stat = await entity.stat();
            totalSize += stat.size;
            fileCount++;

            if (lastSync == null || stat.modified.isAfter(lastSync)) {
              lastSync = stat.modified;
            }
          }
        }
      }

      return OfflineStorageInfo(
        totalSize: totalSize,
        fileCount: fileCount,
        lastSync: lastSync,
        pendingOperations: _pendingOperations.length,
      );
    } catch (e) {
      print('Error getting storage info: $e');
      return OfflineStorageInfo(
        totalSize: 0,
        fileCount: 0,
        lastSync: null,
        pendingOperations: _pendingOperations.length,
      );
    }
  }

  // Clear all offline data
  Future<void> clearAllOfflineData() async {
    try {
      final offlineDir = Directory('$_documentsPath/offline');
      if (await offlineDir.exists()) {
        await offlineDir.delete(recursive: true);
        await _createOfflineDirectories();
      }

      final cacheDir = Directory('$_cachePath/offline_cache');
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create();
      }

      _pendingOperations.clear();
      print('Cleared all offline data');
    } catch (e) {
      print('Error clearing offline data: $e');
    }
  }
}

// Data Models
class OfflineData {
  final String key;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final OfflineDataType type;

  OfflineData({
    required this.key,
    required this.data,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'type': type.toString(),
  };

  factory OfflineData.fromJson(Map<String, dynamic> json) {
    return OfflineData(
      key: json['key'],
      data: Map<String, dynamic>.from(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
      type: OfflineDataType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => OfflineDataType.general,
      ),
    );
  }
}

class CacheData {
  final String key;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final Duration expiry;

  CacheData({
    required this.key,
    required this.data,
    required this.timestamp,
    required this.expiry,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'expiry': expiry.inMilliseconds,
  };

  factory CacheData.fromJson(Map<String, dynamic> json) {
    return CacheData(
      key: json['key'],
      data: Map<String, dynamic>.from(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
      expiry: Duration(milliseconds: json['expiry']),
    );
  }
}

class OfflineOperation {
  final String id;
  final OperationType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;

  OfflineOperation({
    required this.id,
    required this.type,
    required this.data,
    required this.timestamp,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'retryCount': retryCount,
  };

  factory OfflineOperation.fromJson(Map<String, dynamic> json) {
    return OfflineOperation(
      id: json['id'],
      type: OperationType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      data: Map<String, dynamic>.from(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
      retryCount: json['retryCount'] ?? 0,
    );
  }

  OfflineOperation copyWith({
    String? id,
    OperationType? type,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    int? retryCount,
  }) {
    return OfflineOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

class OfflineStorageInfo {
  final int totalSize;
  final int fileCount;
  final DateTime? lastSync;
  final int pendingOperations;

  OfflineStorageInfo({
    required this.totalSize,
    required this.fileCount,
    required this.lastSync,
    required this.pendingOperations,
  });

  String get formattedSize {
    if (totalSize < 1024) return '$totalSize B';
    if (totalSize < 1024 * 1024) return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// Enums
enum OfflineDataType {
  general,
  stories,
  characters,
  images,
  templates,
}

enum OperationType {
  createStory,
  updateStory,
  deleteStory,
  createCharacter,
  updateCharacter,
  deleteCharacter,
}
