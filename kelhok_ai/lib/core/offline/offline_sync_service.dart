import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'offline_manager.dart';

class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  final OfflineManager _offlineManager = OfflineManager();
  Timer? _syncTimer;
  bool _isSyncing = false;
  
  // Sync settings
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 30);

  // Listeners
  final List<Function(SyncStatus)> _syncStatusListeners = [];
  final List<Function(SyncProgress)> _syncProgressListeners = [];

  SyncStatus _currentStatus = SyncStatus.idle;
  SyncProgress _currentProgress = SyncProgress(completed: 0, total: 0);

  // Getters
  SyncStatus get currentStatus => _currentStatus;
  SyncProgress get currentProgress => _currentProgress;
  bool get isSyncing => _isSyncing;

  // Initialize sync service
  Future<void> initialize() async {
    if (!_offlineManager.isInitialized) {
      await _offlineManager.initialize();
    }

    // Listen to connectivity changes
    _offlineManager.addConnectivityListener(_onConnectivityChanged);

    // Start periodic sync if online
    if (_offlineManager.isOnline) {
      _startPeriodicSync();
    }

    print('OfflineSyncService initialized');
  }

  // Add sync status listener
  void addSyncStatusListener(Function(SyncStatus) listener) {
    _syncStatusListeners.add(listener);
  }

  // Remove sync status listener
  void removeSyncStatusListener(Function(SyncStatus) listener) {
    _syncStatusListeners.remove(listener);
  }

  // Add sync progress listener
  void addSyncProgressListener(Function(SyncProgress) listener) {
    _syncProgressListeners.add(listener);
  }

  // Remove sync progress listener
  void removeSyncProgressListener(Function(SyncProgress) listener) {
    _syncProgressListeners.remove(listener);
  }

  // Handle connectivity changes
  void _onConnectivityChanged() {
    if (_offlineManager.isOnline) {
      _startPeriodicSync();
      // Trigger immediate sync when coming online
      syncNow();
    } else {
      _stopPeriodicSync();
    }
  }

  // Start periodic sync
  void _startPeriodicSync() {
    _stopPeriodicSync(); // Stop existing timer
    _syncTimer = Timer.periodic(syncInterval, (_) => syncNow());
  }

  // Stop periodic sync
  void _stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  // Trigger immediate sync
  Future<void> syncNow({bool force = false}) async {
    if (_isSyncing && !force) {
      print('Sync already in progress');
      return;
    }

    if (!_offlineManager.isOnline) {
      print('Cannot sync: device is offline');
      _updateSyncStatus(SyncStatus.offline);
      return;
    }

    _isSyncing = true;
    _updateSyncStatus(SyncStatus.syncing);

    try {
      await _performFullSync();
      _updateSyncStatus(SyncStatus.completed);
      print('Sync completed successfully');
    } catch (e) {
      print('Sync failed: $e');
      _updateSyncStatus(SyncStatus.error);
    } finally {
      _isSyncing = false;
    }
  }

  // Perform full synchronization
  Future<void> _performFullSync() async {
    final operations = _offlineManager.pendingOperations;
    final totalOperations = operations.length;

    _updateSyncProgress(SyncProgress(completed: 0, total: totalOperations));

    // Process pending operations
    for (int i = 0; i < operations.length; i++) {
      final operation = operations[i];
      
      try {
        await _processSyncOperation(operation);
        _updateSyncProgress(SyncProgress(completed: i + 1, total: totalOperations));
        print('Processed operation ${operation.id}');
      } catch (e) {
        print('Failed to process operation ${operation.id}: $e');
        // Keep failed operations for retry
      }
    }

    // Sync additional data types
    await _syncStories();
    await _syncCharacters();
    await _syncTemplates();
  }

  // Process individual sync operation
  Future<void> _processSyncOperation(OfflineOperation operation) async {
    switch (operation.type) {
      case OperationType.createStory:
        await _syncCreateStory(operation);
        break;
      case OperationType.updateStory:
        await _syncUpdateStory(operation);
        break;
      case OperationType.deleteStory:
        await _syncDeleteStory(operation);
        break;
      case OperationType.createCharacter:
        await _syncCreateCharacter(operation);
        break;
      case OperationType.updateCharacter:
        await _syncUpdateCharacter(operation);
        break;
      case OperationType.deleteCharacter:
        await _syncDeleteCharacter(operation);
        break;
    }
  }

  // Sync create story operation
  Future<void> _syncCreateStory(OfflineOperation operation) async {
    // This would make an actual API call to create the story
    // For now, we'll simulate the operation
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Save the result back to offline storage with server ID
    final storyData = operation.data;
    storyData['id'] = 'server_${DateTime.now().millisecondsSinceEpoch}';
    storyData['synced'] = true;
    
    await _offlineManager.saveOfflineData(
      key: storyData['localId'] ?? operation.id,
      data: storyData,
      type: OfflineDataType.stories,
    );
  }

  // Sync update story operation
  Future<void> _syncUpdateStory(OfflineOperation operation) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final storyData = operation.data;
    storyData['synced'] = true;
    storyData['lastModified'] = DateTime.now().toIso8601String();
    
    await _offlineManager.saveOfflineData(
      key: storyData['id'] ?? operation.id,
      data: storyData,
      type: OfflineDataType.stories,
    );
  }

  // Sync delete story operation
  Future<void> _syncDeleteStory(OfflineOperation operation) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Remove from offline storage
    await _offlineManager.deleteOfflineData(
      key: operation.data['id'] ?? operation.id,
      type: OfflineDataType.stories,
    );
  }

  // Sync create character operation
  Future<void> _syncCreateCharacter(OfflineOperation operation) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final characterData = operation.data;
    characterData['id'] = 'server_${DateTime.now().millisecondsSinceEpoch}';
    characterData['synced'] = true;
    
    await _offlineManager.saveOfflineData(
      key: characterData['localId'] ?? operation.id,
      data: characterData,
      type: OfflineDataType.characters,
    );
  }

  // Sync update character operation
  Future<void> _syncUpdateCharacter(OfflineOperation operation) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final characterData = operation.data;
    characterData['synced'] = true;
    characterData['lastModified'] = DateTime.now().toIso8601String();
    
    await _offlineManager.saveOfflineData(
      key: characterData['id'] ?? operation.id,
      data: characterData,
      type: OfflineDataType.characters,
    );
  }

  // Sync delete character operation
  Future<void> _syncDeleteCharacter(OfflineOperation operation) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    await _offlineManager.deleteOfflineData(
      key: operation.data['id'] ?? operation.id,
      type: OfflineDataType.characters,
    );
  }

  // Sync stories from server
  Future<void> _syncStories() async {
    try {
      // This would fetch stories from the server
      // For now, we'll simulate with mock data
      final serverStories = await _fetchStoriesFromServer();
      
      for (final story in serverStories) {
        await _offlineManager.saveOfflineData(
          key: story['id'],
          data: story,
          type: OfflineDataType.stories,
        );
      }
      
      print('Synced ${serverStories.length} stories from server');
    } catch (e) {
      print('Failed to sync stories: $e');
    }
  }

  // Sync characters from server
  Future<void> _syncCharacters() async {
    try {
      final serverCharacters = await _fetchCharactersFromServer();
      
      for (final character in serverCharacters) {
        await _offlineManager.saveOfflineData(
          key: character['id'],
          data: character,
          type: OfflineDataType.characters,
        );
      }
      
      print('Synced ${serverCharacters.length} characters from server');
    } catch (e) {
      print('Failed to sync characters: $e');
    }
  }

  // Sync templates from server
  Future<void> _syncTemplates() async {
    try {
      final serverTemplates = await _fetchTemplatesFromServer();
      
      for (final template in serverTemplates) {
        await _offlineManager.saveOfflineData(
          key: template['id'],
          data: template,
          type: OfflineDataType.templates,
        );
      }
      
      print('Synced ${serverTemplates.length} templates from server');
    } catch (e) {
      print('Failed to sync templates: $e');
    }
  }

  // Mock server data fetch methods
  Future<List<Map<String, dynamic>>> _fetchStoriesFromServer() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'id': 'server_story_1',
        'title': 'The Adventure Begins',
        'content': 'Once upon a time...',
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'synced': true,
      },
      {
        'id': 'server_story_2',
        'title': 'Magic Kingdom',
        'content': 'In a land far away...',
        'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'synced': true,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchCharactersFromServer() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'id': 'server_char_1',
        'name': 'Hero McHeroface',
        'description': 'A brave hero',
        'archetype': 'hero',
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'synced': true,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchTemplatesFromServer() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'id': 'server_template_1',
        'name': 'Adventure Template',
        'category': 'adventure',
        'structure': {'chapters': 3, 'scenes': 12},
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'synced': true,
      },
    ];
  }

  // Save data for later sync
  Future<void> saveForSync({
    required String localId,
    required Map<String, dynamic> data,
    required OperationType operationType,
    OfflineDataType dataType = OfflineDataType.general,
  }) async {
    // Save offline data
    await _offlineManager.saveOfflineData(
      key: localId,
      data: data,
      type: dataType,
    );

    // Add to pending operations if online sync is needed
    if (!_offlineManager.isOnline || data['synced'] != true) {
      final operation = OfflineOperation(
        id: 'op_${DateTime.now().millisecondsSinceEpoch}_${localId}',
        type: operationType,
        data: data,
        timestamp: DateTime.now(),
      );

      await _offlineManager.addPendingOperation(operation);
    }
  }

  // Load data with offline fallback
  Future<Map<String, dynamic>?> loadData({
    required String key,
    OfflineDataType dataType = OfflineDataType.general,
    bool forceOnline = false,
  }) async {
    // Try online first if connected and not forcing offline
    if (_offlineManager.isOnline && !forceOnline) {
      try {
        final onlineData = await _fetchOnlineData(key, dataType);
        if (onlineData != null) {
          // Cache the online data
          await _offlineManager.saveOfflineData(
            key: key,
            data: onlineData,
            type: dataType,
          );
          return onlineData;
        }
      } catch (e) {
        print('Failed to fetch online data: $e');
      }
    }

    // Fallback to offline data
    final offlineData = await _offlineManager.loadOfflineData(
      key: key,
      type: dataType,
    );

    return offlineData?.data;
  }

  // Mock online data fetch
  Future<Map<String, dynamic>?> _fetchOnlineData(
    String key,
    OfflineDataType dataType,
  ) async {
    // This would make an actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    return null; // No online data available
  }

  // Get sync statistics
  SyncStatistics getSyncStatistics() {
    return SyncStatistics(
      pendingOperations: _offlineManager.pendingOperations.length,
      lastSyncTime: _getLastSyncTime(),
      isOnline: _offlineManager.isOnline,
      syncStatus: _currentStatus,
    );
  }

  DateTime? _getLastSyncTime() {
    // This would be stored and retrieved from offline storage
    return DateTime.now().subtract(const Duration(hours: 1)); // Mock data
  }

  // Update sync status
  void _updateSyncStatus(SyncStatus status) {
    _currentStatus = status;
    for (final listener in _syncStatusListeners) {
      listener(status);
    }
  }

  // Update sync progress
  void _updateSyncProgress(SyncProgress progress) {
    _currentProgress = progress;
    for (final listener in _syncProgressListeners) {
      listener(progress);
    }
  }

  // Clean up
  void dispose() {
    _stopPeriodicSync();
    _syncStatusListeners.clear();
    _syncProgressListeners.clear();
  }
}

// Data Models
class SyncProgress {
  final int completed;
  final int total;
  final String? currentOperation;

  SyncProgress({
    required this.completed,
    required this.total,
    this.currentOperation,
  });

  double get percentage {
    if (total == 0) return 0.0;
    return completed / total;
  }

  bool get isComplete => completed >= total;
}

class SyncStatistics {
  final int pendingOperations;
  final DateTime? lastSyncTime;
  final bool isOnline;
  final SyncStatus syncStatus;

  SyncStatistics({
    required this.pendingOperations,
    required this.lastSyncTime,
    required this.isOnline,
    required this.syncStatus,
  });

  String get lastSyncTimeFormatted {
    if (lastSyncTime == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}

// Enums
enum SyncStatus {
  idle,
  syncing,
  completed,
  error,
  offline,
}

extension SyncStatusExtension on SyncStatus {
  String get displayName {
    switch (this) {
      case SyncStatus.idle:
        return 'Idle';
      case SyncStatus.syncing:
        return 'Syncing';
      case SyncStatus.completed:
        return 'Completed';
      case SyncStatus.error:
        return 'Error';
      case SyncStatus.offline:
        return 'Offline';
    }
  }

  bool get isActive {
    return this == SyncStatus.syncing;
  }

  bool get hasError {
    return this == SyncStatus.error;
  }
}
