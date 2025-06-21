// Analytics Service for KarigorAI Premium Features
// Task 4.1.2: Analytics Service Implementation

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/analytics_models.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';

class AnalyticsService {
  final ApiClient _apiClient;
  late Box<Map> _analyticsBox;
  late Box<Map> _sessionsBox;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Connectivity _connectivity = Connectivity();
  
  // Session tracking
  DateTime? _sessionStart;
  Timer? _sessionTimer;
  int _sessionInteractions = 0;
  
  // Feature usage tracking
  final Map<String, int> _featureUsage = {};
  final Map<String, List<DateTime>> _featureTimestamps = {};

  AnalyticsService(this._apiClient);

  /// Initialize analytics service
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      _analyticsBox = await Hive.openBox<Map>('analytics_data');
      _sessionsBox = await Hive.openBox<Map>('user_sessions');
      
      await _startSession();
      _setupPeriodicSync();
    } catch (e) {
      debugPrint('Analytics initialization error: $e');
    }
  }

  /// Start a new user session
  Future<void> _startSession() async {
    _sessionStart = DateTime.now();
    _sessionInteractions = 0;
    
    // Start session timer
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateSessionDuration();
    });
    
    await _trackEvent('session_started', {
      'timestamp': _sessionStart!.toIso8601String(),
      'device_info': await _getDeviceInfo(),
      'app_info': await _getAppInfo(),
      'connectivity': await _getConnectivityInfo(),
    });
  }

  /// End current session
  Future<void> endSession() async {
    if (_sessionStart != null) {
      final duration = DateTime.now().difference(_sessionStart!);
      
      await _trackEvent('session_ended', {
        'duration_minutes': duration.inMinutes,
        'interactions': _sessionInteractions,
        'features_used': _featureUsage.keys.toList(),
      });
      
      _sessionTimer?.cancel();
      _sessionStart = null;
    }
  }

  /// Track content generation events
  Future<void> trackContentGeneration({
    required String contentType, // 'story', 'image', 'caption'
    required String prompt,
    String? characterId,
    String? templateId,
    int? wordCount,
    double? generationTime,
    bool? isSuccessful,
    String? errorMessage,
  }) async {
    _sessionInteractions++;
    _incrementFeatureUsage('content_generation_$contentType');
    
    final eventData = {
      'content_type': contentType,
      'prompt_length': prompt.length,
      'character_id': characterId,
      'template_id': templateId,
      'word_count': wordCount,
      'generation_time_seconds': generationTime,
      'is_successful': isSuccessful,
      'error_message': errorMessage,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await _trackEvent('content_generated', eventData);
    await _updateContentStats(contentType, isSuccessful ?? true);
  }

  /// Track user interactions
  Future<void> trackUserInteraction({
    required String action, // 'button_tap', 'screen_view', 'swipe', etc.
    required String screen,
    String? element,
    Map<String, dynamic>? metadata,
  }) async {
    _sessionInteractions++;
    _incrementFeatureUsage(action);
    
    await _trackEvent('user_interaction', {
      'action': action,
      'screen': screen,
      'element': element,
      'metadata': metadata,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track feature usage
  Future<void> trackFeatureUsage(String featureName, {Map<String, dynamic>? metadata}) async {
    _incrementFeatureUsage(featureName);
    
    await _trackEvent('feature_used', {
      'feature': featureName,
      'usage_count': _featureUsage[featureName],
      'metadata': metadata,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track performance metrics
  Future<void> trackPerformance({
    required String operation,
    required double durationMs,
    bool? wasSuccessful,
    String? errorType,
  }) async {
    await _trackEvent('performance_metric', {
      'operation': operation,
      'duration_ms': durationMs,
      'was_successful': wasSuccessful,
      'error_type': errorType,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Get comprehensive analytics dashboard data
  Future<AnalyticsDashboardData> getDashboardData() async {
    try {
      // Get user stats from local storage and API
      final userStats = await _getUserStats();
      final recentContent = await _getRecentContentMetrics();
      final performance = await _getPerformanceMetrics();
      final engagement = await _getEngagementMetrics();
      final insights = await _generateInsights();
      final weeklyProgress = await _getWeeklyProgress();
      final achievements = await _getAchievements();

      return AnalyticsDashboardData(
        userStats: userStats,
        recentContent: recentContent,
        performance: performance,
        engagement: engagement,
        insights: insights,
        weeklyProgress: weeklyProgress,
        achievements: achievements,
      );
    } catch (e) {
      debugPrint('Error getting dashboard data: $e');
      return _getDefaultDashboardData();
    }
  }

  /// Get user statistics
  Future<UserStats> _getUserStats() async {
    final stats = _analyticsBox.get('user_stats', defaultValue: <String, dynamic>{});
    final dailyUsage = await _getDailyUsageStats();
    
    return UserStats(
      userId: stats['user_id'] ?? 'anonymous',
      totalGenerations: stats['total_generations'] ?? 0,
      storiesGenerated: stats['stories_generated'] ?? 0,
      imagesGenerated: stats['images_generated'] ?? 0,
      captionsGenerated: stats['captions_generated'] ?? 0,
      charactersCreated: stats['characters_created'] ?? 0,
      templatesUsed: stats['templates_used'] ?? 0,
      averageStoryLength: stats['average_story_length']?.toDouble() ?? 0.0,
      averageGenerationTime: stats['average_generation_time']?.toDouble() ?? 0.0,
      lastActiveDate: DateTime.parse(stats['last_active_date'] ?? DateTime.now().toIso8601String()),
      streakDays: stats['streak_days'] ?? 0,
      genreBreakdown: Map<String, int>.from(stats['genre_breakdown'] ?? {}),
      stylePreferences: Map<String, int>.from(stats['style_preferences'] ?? {}),
      dailyUsage: dailyUsage,
    );
  }

  /// Get recent content quality metrics
  Future<List<ContentQualityMetrics>> _getRecentContentMetrics() async {
    final recentContent = _analyticsBox.get('recent_content', defaultValue: <Map>[]);
    
    return recentContent.cast<Map>().map((content) {
      return ContentQualityMetrics(
        contentId: content['content_id'] ?? '',
        contentType: content['content_type'] ?? '',
        qualityScore: content['quality_score']?.toDouble() ?? 0.0,
        creativityIndex: content['creativity_index']?.toDouble() ?? 0.0,
        uniquenessScore: content['uniqueness_score']?.toDouble() ?? 0.0,
        wordCount: content['word_count'] ?? 0,
        keywords: List<String>.from(content['keywords'] ?? []),
        sentimentAnalysis: Map<String, double>.from(content['sentiment_analysis'] ?? {}),
        readabilityScore: content['readability_score']?.toDouble() ?? 0.0,
        createdAt: DateTime.parse(content['created_at'] ?? DateTime.now().toIso8601String()),
      );
    }).toList();
  }

  /// Get performance metrics
  Future<PerformanceMetrics> _getPerformanceMetrics() async {
    final performanceData = _analyticsBox.get('performance', defaultValue: <String, dynamic>{});
    
    return PerformanceMetrics(
      timestamp: DateTime.now(),
      averageResponseTime: performanceData['average_response_time']?.toDouble() ?? 0.0,
      successRate: performanceData['success_rate']?.toDouble() ?? 1.0,
      totalRequests: performanceData['total_requests'] ?? 0,
      errorCount: performanceData['error_count'] ?? 0,
      featurePerformance: Map<String, double>.from(performanceData['feature_performance'] ?? {}),
      cpuUsage: performanceData['cpu_usage']?.toDouble() ?? 0.0,
      memoryUsage: performanceData['memory_usage']?.toDouble() ?? 0.0,
      networkLatency: performanceData['network_latency']?.toDouble() ?? 0.0,
    );
  }

  /// Get engagement metrics
  Future<EngagementMetrics> _getEngagementMetrics() async {
    final sessions = _sessionsBox.values.toList();
    final sessionCount = sessions.length;
    final totalDuration = sessions.fold<int>(0, (sum, session) {
      return sum + (session['duration_minutes'] ?? 0);
    });
    
    return EngagementMetrics(
      userId: 'current_user',
      sessionCount: sessionCount,
      averageSessionDuration: sessionCount > 0 ? totalDuration / sessionCount : 0.0,
      pageViews: _analyticsBox.get('page_views', defaultValue: 0),
      featureUsage: Map<String, int>.from(_featureUsage),
      mostUsedFeatures: _getMostUsedFeatures(),
      retentionRate: _calculateRetentionRate(),
      shareCount: _analyticsBox.get('share_count', defaultValue: 0),
      favoriteCount: _analyticsBox.get('favorite_count', defaultValue: 0),
      firstVisit: DateTime.parse(_analyticsBox.get('first_visit', defaultValue: DateTime.now().toIso8601String())),
      lastVisit: DateTime.now(),
    );
  }

  /// Generate AI insights
  Future<List<TrendingInsight>> _generateInsights() async {
    final insights = <TrendingInsight>[];
    
    // Generate insights based on usage patterns
    final stats = await _getUserStats();
    
    // Story generation insight
    if (stats.storiesGenerated > 10) {
      insights.add(TrendingInsight(
        id: 'story_productivity',
        title: 'Productive Storyteller',
        description: 'You\'ve generated ${stats.storiesGenerated} stories! Your creativity is flourishing.',
        category: 'productivity',
        impact: 0.8,
        recommendation: 'Try exploring new genres to expand your storytelling range.',
        generatedAt: DateTime.now(),
      ));
    }
    
    // Character usage insight
    if (stats.charactersCreated > 5) {
      insights.add(TrendingInsight(
        id: 'character_master',
        title: 'Character Master',
        description: 'With ${stats.charactersCreated} characters created, you\'re building a rich cast.',
        category: 'creativity',
        impact: 0.7,
        recommendation: 'Consider creating character relationships for more complex stories.',
        generatedAt: DateTime.now(),
      ));
    }
    
    return insights;
  }

  /// Get weekly progress
  Future<Map<String, double>> _getWeeklyProgress() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final progress = <String, double>{};
    
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayKey = _getDayKey(day);
      final dayStats = _analyticsBox.get('daily_$dayKey', defaultValue: <String, dynamic>{});
      progress[dayKey] = dayStats['total_generations']?.toDouble() ?? 0.0;
    }
    
    return progress;
  }

  /// Get user achievements
  Future<List<Achievement>> _getAchievements() async {
    final achievements = <Achievement>[];
    final stats = await _getUserStats();
    
    // First Story Achievement
    achievements.add(Achievement(
      id: 'first_story',
      title: 'First Story',
      description: 'Generated your first story',
      category: 'milestone',
      isUnlocked: stats.storiesGenerated > 0,
      unlockedAt: stats.storiesGenerated > 0 ? DateTime.now() : null,
      progress: stats.storiesGenerated > 0 ? 1 : 0,
      target: 1,
      iconPath: 'assets/icons/first_story.png',
      badgeColor: '#4CAF50',
    ));
    
    // Prolific Writer Achievement
    achievements.add(Achievement(
      id: 'prolific_writer',
      title: 'Prolific Writer',
      description: 'Generated 50 stories',
      category: 'productivity',
      isUnlocked: stats.storiesGenerated >= 50,
      unlockedAt: stats.storiesGenerated >= 50 ? DateTime.now() : null,
      progress: stats.storiesGenerated,
      target: 50,
      iconPath: 'assets/icons/prolific_writer.png',
      badgeColor: '#FF9800',
    ));
    
    return achievements;
  }

  /// Helper methods
  String _getDayKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<String> _getMostUsedFeatures() {
    final sortedFeatures = _featureUsage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedFeatures.take(5).map((e) => e.key).toList();
  }

  double _calculateRetentionRate() {
    final sessions = _sessionsBox.values.toList();
    if (sessions.length < 2) return 1.0;
    
    final lastWeekSessions = sessions.where((session) {
      final sessionDate = DateTime.parse(session['timestamp']);
      return DateTime.now().difference(sessionDate).inDays <= 7;
    }).length;
    
    return lastWeekSessions / sessions.length;
  }

  void _incrementFeatureUsage(String feature) {
    _featureUsage[feature] = (_featureUsage[feature] ?? 0) + 1;
    _featureTimestamps[feature] = (_featureTimestamps[feature] ?? [])..add(DateTime.now());
  }

  Future<void> _trackEvent(String eventName, Map<String, dynamic> data) async {
    final event = {
      'event': eventName,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    // Store locally
    final events = _analyticsBox.get('events', defaultValue: <Map>[]);
    events.add(event);
    await _analyticsBox.put('events', events);
    
    // Sync to server if possible
    _syncEventToServer(event);
  }

  Future<void> _syncEventToServer(Map<String, dynamic> event) async {
    try {
      // This would integrate with the existing API when analytics endpoint is available
      // For now, we'll queue events for future sync
      final pendingEvents = _analyticsBox.get('pending_sync', defaultValue: <Map>[]);
      pendingEvents.add(event);
      await _analyticsBox.put('pending_sync', pendingEvents);
    } catch (e) {
      debugPrint('Failed to sync event to server: $e');
    }
  }

  Future<void> _updateContentStats(String contentType, bool isSuccessful) async {
    final stats = _analyticsBox.get('user_stats', defaultValue: <String, dynamic>{});
    
    if (isSuccessful) {
      stats['total_generations'] = (stats['total_generations'] ?? 0) + 1;
      switch (contentType) {
        case 'story':
          stats['stories_generated'] = (stats['stories_generated'] ?? 0) + 1;
          break;
        case 'image':
          stats['images_generated'] = (stats['images_generated'] ?? 0) + 1;
          break;
        case 'caption':
          stats['captions_generated'] = (stats['captions_generated'] ?? 0) + 1;
          break;
      }
    }
    
    stats['last_active_date'] = DateTime.now().toIso8601String();
    await _analyticsBox.put('user_stats', stats);
  }

  void _updateSessionDuration() {
    if (_sessionStart != null) {
      final currentSession = {
        'start_time': _sessionStart!.toIso8601String(),
        'duration_minutes': DateTime.now().difference(_sessionStart!).inMinutes,
        'interactions': _sessionInteractions,
      };
      _sessionsBox.put('current_session', currentSession);
    }
  }

  void _setupPeriodicSync() {
    Timer.periodic(const Duration(hours: 1), (timer) {
      _syncPendingEvents();
    });
  }

  Future<void> _syncPendingEvents() async {
    try {
      final pendingEvents = _analyticsBox.get('pending_sync', defaultValue: <Map>[]);
      if (pendingEvents.isNotEmpty) {
        // Here we would sync to the actual analytics endpoint
        // For now, we'll just clear them after a certain time
        if (pendingEvents.length > 100) {
          await _analyticsBox.put('pending_sync', pendingEvents.sublist(50));
        }
      }
    } catch (e) {
      debugPrint('Failed to sync pending events: $e');
    }
  }

  Future<List<DailyUsage>> _getDailyUsageStats() async {
    final usage = <DailyUsage>[];
    final now = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayKey = _getDayKey(date);
      final dayStats = _analyticsBox.get('daily_$dayKey', defaultValue: <String, dynamic>{});
      
      usage.add(DailyUsage(
        date: date,
        generations: dayStats['generations'] ?? 0,
        timeSpentMinutes: dayStats['time_spent_minutes'] ?? 0,
        uniqueFeatures: dayStats['unique_features'] ?? 0,
      ));
    }
    
    return usage;
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return {
        'platform': 'android',
        'model': androidInfo.model,
        'version': androidInfo.version.release,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return {
        'platform': 'ios',
        'model': iosInfo.model,
        'version': iosInfo.systemVersion,
      };
    }
    return {'platform': 'unknown'};
  }

  Future<Map<String, dynamic>> _getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return {
      'app_name': packageInfo.appName,
      'package_name': packageInfo.packageName,
      'version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
    };
  }

  Future<Map<String, dynamic>> _getConnectivityInfo() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return {
      'connection_type': connectivityResult.toString(),
      'is_online': connectivityResult != ConnectivityResult.none,
    };
  }

  AnalyticsDashboardData _getDefaultDashboardData() {
    return AnalyticsDashboardData(
      userStats: UserStats(
        userId: 'anonymous',
        totalGenerations: 0,
        storiesGenerated: 0,
        imagesGenerated: 0,
        captionsGenerated: 0,
        charactersCreated: 0,
        templatesUsed: 0,
        averageStoryLength: 0.0,
        averageGenerationTime: 0.0,
        lastActiveDate: DateTime.now(),
        streakDays: 0,
        genreBreakdown: {},
        stylePreferences: {},
        dailyUsage: [],
      ),
      recentContent: [],
      performance: PerformanceMetrics(
        timestamp: DateTime.now(),
        averageResponseTime: 0.0,
        successRate: 1.0,
        totalRequests: 0,
        errorCount: 0,
        featurePerformance: {},
        cpuUsage: 0.0,
        memoryUsage: 0.0,
        networkLatency: 0.0,
      ),
      engagement: EngagementMetrics(
        userId: 'anonymous',
        sessionCount: 0,
        averageSessionDuration: 0.0,
        pageViews: 0,
        featureUsage: {},
        mostUsedFeatures: [],
        retentionRate: 1.0,
        shareCount: 0,
        favoriteCount: 0,
        firstVisit: DateTime.now(),
        lastVisit: DateTime.now(),
      ),
      insights: [],
      weeklyProgress: {},
      achievements: [],
    );
  }

  void dispose() {
    _sessionTimer?.cancel();
    endSession();
  }
} 