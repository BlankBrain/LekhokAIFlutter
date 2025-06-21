// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      userId: json['userId'] as String,
      totalGenerations: (json['totalGenerations'] as num).toInt(),
      storiesGenerated: (json['storiesGenerated'] as num).toInt(),
      imagesGenerated: (json['imagesGenerated'] as num).toInt(),
      captionsGenerated: (json['captionsGenerated'] as num).toInt(),
      charactersCreated: (json['charactersCreated'] as num).toInt(),
      templatesUsed: (json['templatesUsed'] as num).toInt(),
      averageStoryLength: (json['averageStoryLength'] as num).toDouble(),
      averageGenerationTime: (json['averageGenerationTime'] as num).toDouble(),
      lastActiveDate: DateTime.parse(json['lastActiveDate'] as String),
      streakDays: (json['streakDays'] as num).toInt(),
      genreBreakdown: Map<String, int>.from(json['genreBreakdown'] as Map),
      stylePreferences: Map<String, int>.from(json['stylePreferences'] as Map),
      dailyUsage: (json['dailyUsage'] as List<dynamic>)
          .map((e) => DailyUsage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalGenerations': instance.totalGenerations,
      'storiesGenerated': instance.storiesGenerated,
      'imagesGenerated': instance.imagesGenerated,
      'captionsGenerated': instance.captionsGenerated,
      'charactersCreated': instance.charactersCreated,
      'templatesUsed': instance.templatesUsed,
      'averageStoryLength': instance.averageStoryLength,
      'averageGenerationTime': instance.averageGenerationTime,
      'lastActiveDate': instance.lastActiveDate.toIso8601String(),
      'streakDays': instance.streakDays,
      'genreBreakdown': instance.genreBreakdown,
      'stylePreferences': instance.stylePreferences,
      'dailyUsage': instance.dailyUsage,
    };

_$DailyUsageImpl _$$DailyUsageImplFromJson(Map<String, dynamic> json) =>
    _$DailyUsageImpl(
      date: DateTime.parse(json['date'] as String),
      generations: (json['generations'] as num).toInt(),
      timeSpentMinutes: (json['timeSpentMinutes'] as num).toInt(),
      uniqueFeatures: (json['uniqueFeatures'] as num).toInt(),
    );

Map<String, dynamic> _$$DailyUsageImplToJson(_$DailyUsageImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'generations': instance.generations,
      'timeSpentMinutes': instance.timeSpentMinutes,
      'uniqueFeatures': instance.uniqueFeatures,
    };

_$ContentQualityMetricsImpl _$$ContentQualityMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentQualityMetricsImpl(
      contentId: json['contentId'] as String,
      contentType: json['contentType'] as String,
      qualityScore: (json['qualityScore'] as num).toDouble(),
      creativityIndex: (json['creativityIndex'] as num).toDouble(),
      uniquenessScore: (json['uniquenessScore'] as num).toDouble(),
      wordCount: (json['wordCount'] as num).toInt(),
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      sentimentAnalysis:
          (json['sentimentAnalysis'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      readabilityScore: (json['readabilityScore'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ContentQualityMetricsImplToJson(
        _$ContentQualityMetricsImpl instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'contentType': instance.contentType,
      'qualityScore': instance.qualityScore,
      'creativityIndex': instance.creativityIndex,
      'uniquenessScore': instance.uniquenessScore,
      'wordCount': instance.wordCount,
      'keywords': instance.keywords,
      'sentimentAnalysis': instance.sentimentAnalysis,
      'readabilityScore': instance.readabilityScore,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$PerformanceMetricsImpl _$$PerformanceMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$PerformanceMetricsImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      averageResponseTime: (json['averageResponseTime'] as num).toDouble(),
      successRate: (json['successRate'] as num).toDouble(),
      totalRequests: (json['totalRequests'] as num).toInt(),
      errorCount: (json['errorCount'] as num).toInt(),
      featurePerformance:
          (json['featurePerformance'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      cpuUsage: (json['cpuUsage'] as num).toDouble(),
      memoryUsage: (json['memoryUsage'] as num).toDouble(),
      networkLatency: (json['networkLatency'] as num).toDouble(),
    );

Map<String, dynamic> _$$PerformanceMetricsImplToJson(
        _$PerformanceMetricsImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'averageResponseTime': instance.averageResponseTime,
      'successRate': instance.successRate,
      'totalRequests': instance.totalRequests,
      'errorCount': instance.errorCount,
      'featurePerformance': instance.featurePerformance,
      'cpuUsage': instance.cpuUsage,
      'memoryUsage': instance.memoryUsage,
      'networkLatency': instance.networkLatency,
    };

_$EngagementMetricsImpl _$$EngagementMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$EngagementMetricsImpl(
      userId: json['userId'] as String,
      sessionCount: (json['sessionCount'] as num).toInt(),
      averageSessionDuration:
          (json['averageSessionDuration'] as num).toDouble(),
      pageViews: (json['pageViews'] as num).toInt(),
      featureUsage: Map<String, int>.from(json['featureUsage'] as Map),
      mostUsedFeatures: (json['mostUsedFeatures'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      retentionRate: (json['retentionRate'] as num).toDouble(),
      shareCount: (json['shareCount'] as num).toInt(),
      favoriteCount: (json['favoriteCount'] as num).toInt(),
      firstVisit: DateTime.parse(json['firstVisit'] as String),
      lastVisit: DateTime.parse(json['lastVisit'] as String),
    );

Map<String, dynamic> _$$EngagementMetricsImplToJson(
        _$EngagementMetricsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'sessionCount': instance.sessionCount,
      'averageSessionDuration': instance.averageSessionDuration,
      'pageViews': instance.pageViews,
      'featureUsage': instance.featureUsage,
      'mostUsedFeatures': instance.mostUsedFeatures,
      'retentionRate': instance.retentionRate,
      'shareCount': instance.shareCount,
      'favoriteCount': instance.favoriteCount,
      'firstVisit': instance.firstVisit.toIso8601String(),
      'lastVisit': instance.lastVisit.toIso8601String(),
    };

_$AnalyticsDashboardDataImpl _$$AnalyticsDashboardDataImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyticsDashboardDataImpl(
      userStats: UserStats.fromJson(json['userStats'] as Map<String, dynamic>),
      recentContent: (json['recentContent'] as List<dynamic>)
          .map((e) => ContentQualityMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
      performance: PerformanceMetrics.fromJson(
          json['performance'] as Map<String, dynamic>),
      engagement: EngagementMetrics.fromJson(
          json['engagement'] as Map<String, dynamic>),
      insights: (json['insights'] as List<dynamic>)
          .map((e) => TrendingInsight.fromJson(e as Map<String, dynamic>))
          .toList(),
      weeklyProgress: (json['weeklyProgress'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AnalyticsDashboardDataImplToJson(
        _$AnalyticsDashboardDataImpl instance) =>
    <String, dynamic>{
      'userStats': instance.userStats,
      'recentContent': instance.recentContent,
      'performance': instance.performance,
      'engagement': instance.engagement,
      'insights': instance.insights,
      'weeklyProgress': instance.weeklyProgress,
      'achievements': instance.achievements,
    };

_$TrendingInsightImpl _$$TrendingInsightImplFromJson(
        Map<String, dynamic> json) =>
    _$TrendingInsightImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      impact: (json['impact'] as num).toDouble(),
      recommendation: json['recommendation'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$TrendingInsightImplToJson(
        _$TrendingInsightImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'impact': instance.impact,
      'recommendation': instance.recommendation,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      progress: (json['progress'] as num).toInt(),
      target: (json['target'] as num).toInt(),
      iconPath: json['iconPath'] as String,
      badgeColor: json['badgeColor'] as String,
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'progress': instance.progress,
      'target': instance.target,
      'iconPath': instance.iconPath,
      'badgeColor': instance.badgeColor,
    };

_$ChartDataPointImpl _$$ChartDataPointImplFromJson(Map<String, dynamic> json) =>
    _$ChartDataPointImpl(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      label: json['label'] as String,
    );

Map<String, dynamic> _$$ChartDataPointImplToJson(
        _$ChartDataPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'label': instance.label,
    };

_$ReportConfigImpl _$$ReportConfigImplFromJson(Map<String, dynamic> json) =>
    _$ReportConfigImpl(
      period: $enumDecode(_$AnalyticsTimePeriodEnumMap, json['period']),
      includedMetrics: (json['includedMetrics'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      format: json['format'] as String,
      includeCharts: json['includeCharts'] as bool,
      includeInsights: json['includeInsights'] as bool,
      customStartDate: json['customStartDate'] == null
          ? null
          : DateTime.parse(json['customStartDate'] as String),
      customEndDate: json['customEndDate'] == null
          ? null
          : DateTime.parse(json['customEndDate'] as String),
    );

Map<String, dynamic> _$$ReportConfigImplToJson(_$ReportConfigImpl instance) =>
    <String, dynamic>{
      'period': _$AnalyticsTimePeriodEnumMap[instance.period]!,
      'includedMetrics': instance.includedMetrics,
      'format': instance.format,
      'includeCharts': instance.includeCharts,
      'includeInsights': instance.includeInsights,
      'customStartDate': instance.customStartDate?.toIso8601String(),
      'customEndDate': instance.customEndDate?.toIso8601String(),
    };

const _$AnalyticsTimePeriodEnumMap = {
  AnalyticsTimePeriod.day: 'day',
  AnalyticsTimePeriod.week: 'week',
  AnalyticsTimePeriod.month: 'month',
  AnalyticsTimePeriod.quarter: 'quarter',
  AnalyticsTimePeriod.year: 'year',
  AnalyticsTimePeriod.allTime: 'allTime',
};
