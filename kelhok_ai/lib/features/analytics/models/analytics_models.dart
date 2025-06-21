// Analytics Models for KarigorAI Premium Features
// Task 4.1.1: User Analytics Data Models

import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_models.freezed.dart';
part 'analytics_models.g.dart';

/// User Content Generation Statistics
@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    required String userId,
    required int totalGenerations,
    required int storiesGenerated,
    required int imagesGenerated,
    required int captionsGenerated,
    required int charactersCreated,
    required int templatesUsed,
    required double averageStoryLength,
    required double averageGenerationTime,
    required DateTime lastActiveDate,
    required int streakDays,
    required Map<String, int> genreBreakdown,
    required Map<String, int> stylePreferences,
    required List<DailyUsage> dailyUsage,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}

/// Daily Usage Statistics
@freezed
class DailyUsage with _$DailyUsage {
  const factory DailyUsage({
    required DateTime date,
    required int generations,
    required int timeSpentMinutes,
    required int uniqueFeatures,
  }) = _DailyUsage;

  factory DailyUsage.fromJson(Map<String, dynamic> json) =>
      _$DailyUsageFromJson(json);
}

/// Content Quality Analytics
@freezed
class ContentQualityMetrics with _$ContentQualityMetrics {
  const factory ContentQualityMetrics({
    required String contentId,
    required String contentType, // 'story', 'image', 'caption'
    required double qualityScore,
    required double creativityIndex,
    required double uniquenessScore,
    required int wordCount,
    required List<String> keywords,
    required Map<String, double> sentimentAnalysis,
    required double readabilityScore,
    required DateTime createdAt,
  }) = _ContentQualityMetrics;

  factory ContentQualityMetrics.fromJson(Map<String, dynamic> json) =>
      _$ContentQualityMetricsFromJson(json);
}

/// Performance Analytics
@freezed
class PerformanceMetrics with _$PerformanceMetrics {
  const factory PerformanceMetrics({
    required DateTime timestamp,
    required double averageResponseTime,
    required double successRate,
    required int totalRequests,
    required int errorCount,
    required Map<String, double> featurePerformance,
    required double cpuUsage,
    required double memoryUsage,
    required double networkLatency,
  }) = _PerformanceMetrics;

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) =>
      _$PerformanceMetricsFromJson(json);
}

/// User Engagement Analytics
@freezed
class EngagementMetrics with _$EngagementMetrics {
  const factory EngagementMetrics({
    required String userId,
    required int sessionCount,
    required double averageSessionDuration,
    required int pageViews,
    required Map<String, int> featureUsage,
    required List<String> mostUsedFeatures,
    required double retentionRate,
    required int shareCount,
    required int favoriteCount,
    required DateTime firstVisit,
    required DateTime lastVisit,
  }) = _EngagementMetrics;

  factory EngagementMetrics.fromJson(Map<String, dynamic> json) =>
      _$EngagementMetricsFromJson(json);
}

/// Analytics Dashboard Data
@freezed
class AnalyticsDashboardData with _$AnalyticsDashboardData {
  const factory AnalyticsDashboardData({
    required UserStats userStats,
    required List<ContentQualityMetrics> recentContent,
    required PerformanceMetrics performance,
    required EngagementMetrics engagement,
    required List<TrendingInsight> insights,
    required Map<String, double> weeklyProgress,
    required List<Achievement> achievements,
  }) = _AnalyticsDashboardData;

  factory AnalyticsDashboardData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDashboardDataFromJson(json);
}

/// Trending Insights
@freezed
class TrendingInsight with _$TrendingInsight {
  const factory TrendingInsight({
    required String id,
    required String title,
    required String description,
    required String category,
    required double impact,
    required String recommendation,
    required DateTime generatedAt,
  }) = _TrendingInsight;

  factory TrendingInsight.fromJson(Map<String, dynamic> json) =>
      _$TrendingInsightFromJson(json);
}

/// User Achievements
@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String title,
    required String description,
    required String category,
    required bool isUnlocked,
    required DateTime? unlockedAt,
    required int progress,
    required int target,
    required String iconPath,
    required String badgeColor,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

/// Analytics Time Period
enum AnalyticsTimePeriod {
  day,
  week,
  month,
  quarter,
  year,
  allTime,
}

/// Chart Data Point
@freezed
class ChartDataPoint with _$ChartDataPoint {
  const factory ChartDataPoint({
    required DateTime date,
    required double value,
    required String label,
  }) = _ChartDataPoint;

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) =>
      _$ChartDataPointFromJson(json);
}

/// Export Report Configuration
@freezed
class ReportConfig with _$ReportConfig {
  const factory ReportConfig({
    required AnalyticsTimePeriod period,
    required List<String> includedMetrics,
    required String format, // 'pdf', 'csv', 'json'
    required bool includeCharts,
    required bool includeInsights,
    required DateTime? customStartDate,
    required DateTime? customEndDate,
  }) = _ReportConfig;

  factory ReportConfig.fromJson(Map<String, dynamic> json) =>
      _$ReportConfigFromJson(json);
} 