// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  String get userId => throw _privateConstructorUsedError;
  int get totalGenerations => throw _privateConstructorUsedError;
  int get storiesGenerated => throw _privateConstructorUsedError;
  int get imagesGenerated => throw _privateConstructorUsedError;
  int get captionsGenerated => throw _privateConstructorUsedError;
  int get charactersCreated => throw _privateConstructorUsedError;
  int get templatesUsed => throw _privateConstructorUsedError;
  double get averageStoryLength => throw _privateConstructorUsedError;
  double get averageGenerationTime => throw _privateConstructorUsedError;
  DateTime get lastActiveDate => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  Map<String, int> get genreBreakdown => throw _privateConstructorUsedError;
  Map<String, int> get stylePreferences => throw _privateConstructorUsedError;
  List<DailyUsage> get dailyUsage => throw _privateConstructorUsedError;

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call(
      {String userId,
      int totalGenerations,
      int storiesGenerated,
      int imagesGenerated,
      int captionsGenerated,
      int charactersCreated,
      int templatesUsed,
      double averageStoryLength,
      double averageGenerationTime,
      DateTime lastActiveDate,
      int streakDays,
      Map<String, int> genreBreakdown,
      Map<String, int> stylePreferences,
      List<DailyUsage> dailyUsage});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalGenerations = null,
    Object? storiesGenerated = null,
    Object? imagesGenerated = null,
    Object? captionsGenerated = null,
    Object? charactersCreated = null,
    Object? templatesUsed = null,
    Object? averageStoryLength = null,
    Object? averageGenerationTime = null,
    Object? lastActiveDate = null,
    Object? streakDays = null,
    Object? genreBreakdown = null,
    Object? stylePreferences = null,
    Object? dailyUsage = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalGenerations: null == totalGenerations
          ? _value.totalGenerations
          : totalGenerations // ignore: cast_nullable_to_non_nullable
              as int,
      storiesGenerated: null == storiesGenerated
          ? _value.storiesGenerated
          : storiesGenerated // ignore: cast_nullable_to_non_nullable
              as int,
      imagesGenerated: null == imagesGenerated
          ? _value.imagesGenerated
          : imagesGenerated // ignore: cast_nullable_to_non_nullable
              as int,
      captionsGenerated: null == captionsGenerated
          ? _value.captionsGenerated
          : captionsGenerated // ignore: cast_nullable_to_non_nullable
              as int,
      charactersCreated: null == charactersCreated
          ? _value.charactersCreated
          : charactersCreated // ignore: cast_nullable_to_non_nullable
              as int,
      templatesUsed: null == templatesUsed
          ? _value.templatesUsed
          : templatesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      averageStoryLength: null == averageStoryLength
          ? _value.averageStoryLength
          : averageStoryLength // ignore: cast_nullable_to_non_nullable
              as double,
      averageGenerationTime: null == averageGenerationTime
          ? _value.averageGenerationTime
          : averageGenerationTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastActiveDate: null == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      genreBreakdown: null == genreBreakdown
          ? _value.genreBreakdown
          : genreBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      stylePreferences: null == stylePreferences
          ? _value.stylePreferences
          : stylePreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      dailyUsage: null == dailyUsage
          ? _value.dailyUsage
          : dailyUsage // ignore: cast_nullable_to_non_nullable
              as List<DailyUsage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
          _$UserStatsImpl value, $Res Function(_$UserStatsImpl) then) =
      __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int totalGenerations,
      int storiesGenerated,
      int imagesGenerated,
      int captionsGenerated,
      int charactersCreated,
      int templatesUsed,
      double averageStoryLength,
      double averageGenerationTime,
      DateTime lastActiveDate,
      int streakDays,
      Map<String, int> genreBreakdown,
      Map<String, int> stylePreferences,
      List<DailyUsage> dailyUsage});
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
      _$UserStatsImpl _value, $Res Function(_$UserStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalGenerations = null,
    Object? storiesGenerated = null,
    Object? imagesGenerated = null,
    Object? captionsGenerated = null,
    Object? charactersCreated = null,
    Object? templatesUsed = null,
    Object? averageStoryLength = null,
    Object? averageGenerationTime = null,
    Object? lastActiveDate = null,
    Object? streakDays = null,
    Object? genreBreakdown = null,
    Object? stylePreferences = null,
    Object? dailyUsage = null,
  }) {
    return _then(_$UserStatsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalGenerations: null == totalGenerations
          ? _value.totalGenerations
          : totalGenerations // ignore: cast_nullable_to_non_nullable
              as int,
      storiesGenerated: null == storiesGenerated
          ? _value.storiesGenerated
          : storiesGenerated // ignore: cast_nullable_to_non_nullable
              as int,
      imagesGenerated: null == imagesGenerated
          ? _value.imagesGenerated
          : imagesGenerated // ignore: cast_nullable_to_non_nullable
              as int,
      captionsGenerated: null == captionsGenerated
          ? _value.captionsGenerated
          : captionsGenerated // ignore: cast_nullable_to_non_nullable
              as int,
      charactersCreated: null == charactersCreated
          ? _value.charactersCreated
          : charactersCreated // ignore: cast_nullable_to_non_nullable
              as int,
      templatesUsed: null == templatesUsed
          ? _value.templatesUsed
          : templatesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      averageStoryLength: null == averageStoryLength
          ? _value.averageStoryLength
          : averageStoryLength // ignore: cast_nullable_to_non_nullable
              as double,
      averageGenerationTime: null == averageGenerationTime
          ? _value.averageGenerationTime
          : averageGenerationTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastActiveDate: null == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      genreBreakdown: null == genreBreakdown
          ? _value._genreBreakdown
          : genreBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      stylePreferences: null == stylePreferences
          ? _value._stylePreferences
          : stylePreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      dailyUsage: null == dailyUsage
          ? _value._dailyUsage
          : dailyUsage // ignore: cast_nullable_to_non_nullable
              as List<DailyUsage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl(
      {required this.userId,
      required this.totalGenerations,
      required this.storiesGenerated,
      required this.imagesGenerated,
      required this.captionsGenerated,
      required this.charactersCreated,
      required this.templatesUsed,
      required this.averageStoryLength,
      required this.averageGenerationTime,
      required this.lastActiveDate,
      required this.streakDays,
      required final Map<String, int> genreBreakdown,
      required final Map<String, int> stylePreferences,
      required final List<DailyUsage> dailyUsage})
      : _genreBreakdown = genreBreakdown,
        _stylePreferences = stylePreferences,
        _dailyUsage = dailyUsage;

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  final String userId;
  @override
  final int totalGenerations;
  @override
  final int storiesGenerated;
  @override
  final int imagesGenerated;
  @override
  final int captionsGenerated;
  @override
  final int charactersCreated;
  @override
  final int templatesUsed;
  @override
  final double averageStoryLength;
  @override
  final double averageGenerationTime;
  @override
  final DateTime lastActiveDate;
  @override
  final int streakDays;
  final Map<String, int> _genreBreakdown;
  @override
  Map<String, int> get genreBreakdown {
    if (_genreBreakdown is EqualUnmodifiableMapView) return _genreBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_genreBreakdown);
  }

  final Map<String, int> _stylePreferences;
  @override
  Map<String, int> get stylePreferences {
    if (_stylePreferences is EqualUnmodifiableMapView) return _stylePreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stylePreferences);
  }

  final List<DailyUsage> _dailyUsage;
  @override
  List<DailyUsage> get dailyUsage {
    if (_dailyUsage is EqualUnmodifiableListView) return _dailyUsage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyUsage);
  }

  @override
  String toString() {
    return 'UserStats(userId: $userId, totalGenerations: $totalGenerations, storiesGenerated: $storiesGenerated, imagesGenerated: $imagesGenerated, captionsGenerated: $captionsGenerated, charactersCreated: $charactersCreated, templatesUsed: $templatesUsed, averageStoryLength: $averageStoryLength, averageGenerationTime: $averageGenerationTime, lastActiveDate: $lastActiveDate, streakDays: $streakDays, genreBreakdown: $genreBreakdown, stylePreferences: $stylePreferences, dailyUsage: $dailyUsage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalGenerations, totalGenerations) ||
                other.totalGenerations == totalGenerations) &&
            (identical(other.storiesGenerated, storiesGenerated) ||
                other.storiesGenerated == storiesGenerated) &&
            (identical(other.imagesGenerated, imagesGenerated) ||
                other.imagesGenerated == imagesGenerated) &&
            (identical(other.captionsGenerated, captionsGenerated) ||
                other.captionsGenerated == captionsGenerated) &&
            (identical(other.charactersCreated, charactersCreated) ||
                other.charactersCreated == charactersCreated) &&
            (identical(other.templatesUsed, templatesUsed) ||
                other.templatesUsed == templatesUsed) &&
            (identical(other.averageStoryLength, averageStoryLength) ||
                other.averageStoryLength == averageStoryLength) &&
            (identical(other.averageGenerationTime, averageGenerationTime) ||
                other.averageGenerationTime == averageGenerationTime) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            const DeepCollectionEquality()
                .equals(other._genreBreakdown, _genreBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._stylePreferences, _stylePreferences) &&
            const DeepCollectionEquality()
                .equals(other._dailyUsage, _dailyUsage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      totalGenerations,
      storiesGenerated,
      imagesGenerated,
      captionsGenerated,
      charactersCreated,
      templatesUsed,
      averageStoryLength,
      averageGenerationTime,
      lastActiveDate,
      streakDays,
      const DeepCollectionEquality().hash(_genreBreakdown),
      const DeepCollectionEquality().hash(_stylePreferences),
      const DeepCollectionEquality().hash(_dailyUsage));

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(
      this,
    );
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats(
      {required final String userId,
      required final int totalGenerations,
      required final int storiesGenerated,
      required final int imagesGenerated,
      required final int captionsGenerated,
      required final int charactersCreated,
      required final int templatesUsed,
      required final double averageStoryLength,
      required final double averageGenerationTime,
      required final DateTime lastActiveDate,
      required final int streakDays,
      required final Map<String, int> genreBreakdown,
      required final Map<String, int> stylePreferences,
      required final List<DailyUsage> dailyUsage}) = _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  String get userId;
  @override
  int get totalGenerations;
  @override
  int get storiesGenerated;
  @override
  int get imagesGenerated;
  @override
  int get captionsGenerated;
  @override
  int get charactersCreated;
  @override
  int get templatesUsed;
  @override
  double get averageStoryLength;
  @override
  double get averageGenerationTime;
  @override
  DateTime get lastActiveDate;
  @override
  int get streakDays;
  @override
  Map<String, int> get genreBreakdown;
  @override
  Map<String, int> get stylePreferences;
  @override
  List<DailyUsage> get dailyUsage;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyUsage _$DailyUsageFromJson(Map<String, dynamic> json) {
  return _DailyUsage.fromJson(json);
}

/// @nodoc
mixin _$DailyUsage {
  DateTime get date => throw _privateConstructorUsedError;
  int get generations => throw _privateConstructorUsedError;
  int get timeSpentMinutes => throw _privateConstructorUsedError;
  int get uniqueFeatures => throw _privateConstructorUsedError;

  /// Serializes this DailyUsage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyUsageCopyWith<DailyUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyUsageCopyWith<$Res> {
  factory $DailyUsageCopyWith(
          DailyUsage value, $Res Function(DailyUsage) then) =
      _$DailyUsageCopyWithImpl<$Res, DailyUsage>;
  @useResult
  $Res call(
      {DateTime date,
      int generations,
      int timeSpentMinutes,
      int uniqueFeatures});
}

/// @nodoc
class _$DailyUsageCopyWithImpl<$Res, $Val extends DailyUsage>
    implements $DailyUsageCopyWith<$Res> {
  _$DailyUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? generations = null,
    Object? timeSpentMinutes = null,
    Object? uniqueFeatures = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      generations: null == generations
          ? _value.generations
          : generations // ignore: cast_nullable_to_non_nullable
              as int,
      timeSpentMinutes: null == timeSpentMinutes
          ? _value.timeSpentMinutes
          : timeSpentMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueFeatures: null == uniqueFeatures
          ? _value.uniqueFeatures
          : uniqueFeatures // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyUsageImplCopyWith<$Res>
    implements $DailyUsageCopyWith<$Res> {
  factory _$$DailyUsageImplCopyWith(
          _$DailyUsageImpl value, $Res Function(_$DailyUsageImpl) then) =
      __$$DailyUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      int generations,
      int timeSpentMinutes,
      int uniqueFeatures});
}

/// @nodoc
class __$$DailyUsageImplCopyWithImpl<$Res>
    extends _$DailyUsageCopyWithImpl<$Res, _$DailyUsageImpl>
    implements _$$DailyUsageImplCopyWith<$Res> {
  __$$DailyUsageImplCopyWithImpl(
      _$DailyUsageImpl _value, $Res Function(_$DailyUsageImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? generations = null,
    Object? timeSpentMinutes = null,
    Object? uniqueFeatures = null,
  }) {
    return _then(_$DailyUsageImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      generations: null == generations
          ? _value.generations
          : generations // ignore: cast_nullable_to_non_nullable
              as int,
      timeSpentMinutes: null == timeSpentMinutes
          ? _value.timeSpentMinutes
          : timeSpentMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueFeatures: null == uniqueFeatures
          ? _value.uniqueFeatures
          : uniqueFeatures // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyUsageImpl implements _DailyUsage {
  const _$DailyUsageImpl(
      {required this.date,
      required this.generations,
      required this.timeSpentMinutes,
      required this.uniqueFeatures});

  factory _$DailyUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyUsageImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int generations;
  @override
  final int timeSpentMinutes;
  @override
  final int uniqueFeatures;

  @override
  String toString() {
    return 'DailyUsage(date: $date, generations: $generations, timeSpentMinutes: $timeSpentMinutes, uniqueFeatures: $uniqueFeatures)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyUsageImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.generations, generations) ||
                other.generations == generations) &&
            (identical(other.timeSpentMinutes, timeSpentMinutes) ||
                other.timeSpentMinutes == timeSpentMinutes) &&
            (identical(other.uniqueFeatures, uniqueFeatures) ||
                other.uniqueFeatures == uniqueFeatures));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, generations, timeSpentMinutes, uniqueFeatures);

  /// Create a copy of DailyUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyUsageImplCopyWith<_$DailyUsageImpl> get copyWith =>
      __$$DailyUsageImplCopyWithImpl<_$DailyUsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyUsageImplToJson(
      this,
    );
  }
}

abstract class _DailyUsage implements DailyUsage {
  const factory _DailyUsage(
      {required final DateTime date,
      required final int generations,
      required final int timeSpentMinutes,
      required final int uniqueFeatures}) = _$DailyUsageImpl;

  factory _DailyUsage.fromJson(Map<String, dynamic> json) =
      _$DailyUsageImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get generations;
  @override
  int get timeSpentMinutes;
  @override
  int get uniqueFeatures;

  /// Create a copy of DailyUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyUsageImplCopyWith<_$DailyUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContentQualityMetrics _$ContentQualityMetricsFromJson(
    Map<String, dynamic> json) {
  return _ContentQualityMetrics.fromJson(json);
}

/// @nodoc
mixin _$ContentQualityMetrics {
  String get contentId => throw _privateConstructorUsedError;
  String get contentType =>
      throw _privateConstructorUsedError; // 'story', 'image', 'caption'
  double get qualityScore => throw _privateConstructorUsedError;
  double get creativityIndex => throw _privateConstructorUsedError;
  double get uniquenessScore => throw _privateConstructorUsedError;
  int get wordCount => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;
  Map<String, double> get sentimentAnalysis =>
      throw _privateConstructorUsedError;
  double get readabilityScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ContentQualityMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentQualityMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentQualityMetricsCopyWith<ContentQualityMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentQualityMetricsCopyWith<$Res> {
  factory $ContentQualityMetricsCopyWith(ContentQualityMetrics value,
          $Res Function(ContentQualityMetrics) then) =
      _$ContentQualityMetricsCopyWithImpl<$Res, ContentQualityMetrics>;
  @useResult
  $Res call(
      {String contentId,
      String contentType,
      double qualityScore,
      double creativityIndex,
      double uniquenessScore,
      int wordCount,
      List<String> keywords,
      Map<String, double> sentimentAnalysis,
      double readabilityScore,
      DateTime createdAt});
}

/// @nodoc
class _$ContentQualityMetricsCopyWithImpl<$Res,
        $Val extends ContentQualityMetrics>
    implements $ContentQualityMetricsCopyWith<$Res> {
  _$ContentQualityMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentQualityMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? contentType = null,
    Object? qualityScore = null,
    Object? creativityIndex = null,
    Object? uniquenessScore = null,
    Object? wordCount = null,
    Object? keywords = null,
    Object? sentimentAnalysis = null,
    Object? readabilityScore = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      qualityScore: null == qualityScore
          ? _value.qualityScore
          : qualityScore // ignore: cast_nullable_to_non_nullable
              as double,
      creativityIndex: null == creativityIndex
          ? _value.creativityIndex
          : creativityIndex // ignore: cast_nullable_to_non_nullable
              as double,
      uniquenessScore: null == uniquenessScore
          ? _value.uniquenessScore
          : uniquenessScore // ignore: cast_nullable_to_non_nullable
              as double,
      wordCount: null == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sentimentAnalysis: null == sentimentAnalysis
          ? _value.sentimentAnalysis
          : sentimentAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      readabilityScore: null == readabilityScore
          ? _value.readabilityScore
          : readabilityScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentQualityMetricsImplCopyWith<$Res>
    implements $ContentQualityMetricsCopyWith<$Res> {
  factory _$$ContentQualityMetricsImplCopyWith(
          _$ContentQualityMetricsImpl value,
          $Res Function(_$ContentQualityMetricsImpl) then) =
      __$$ContentQualityMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contentId,
      String contentType,
      double qualityScore,
      double creativityIndex,
      double uniquenessScore,
      int wordCount,
      List<String> keywords,
      Map<String, double> sentimentAnalysis,
      double readabilityScore,
      DateTime createdAt});
}

/// @nodoc
class __$$ContentQualityMetricsImplCopyWithImpl<$Res>
    extends _$ContentQualityMetricsCopyWithImpl<$Res,
        _$ContentQualityMetricsImpl>
    implements _$$ContentQualityMetricsImplCopyWith<$Res> {
  __$$ContentQualityMetricsImplCopyWithImpl(_$ContentQualityMetricsImpl _value,
      $Res Function(_$ContentQualityMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentQualityMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? contentType = null,
    Object? qualityScore = null,
    Object? creativityIndex = null,
    Object? uniquenessScore = null,
    Object? wordCount = null,
    Object? keywords = null,
    Object? sentimentAnalysis = null,
    Object? readabilityScore = null,
    Object? createdAt = null,
  }) {
    return _then(_$ContentQualityMetricsImpl(
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      qualityScore: null == qualityScore
          ? _value.qualityScore
          : qualityScore // ignore: cast_nullable_to_non_nullable
              as double,
      creativityIndex: null == creativityIndex
          ? _value.creativityIndex
          : creativityIndex // ignore: cast_nullable_to_non_nullable
              as double,
      uniquenessScore: null == uniquenessScore
          ? _value.uniquenessScore
          : uniquenessScore // ignore: cast_nullable_to_non_nullable
              as double,
      wordCount: null == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sentimentAnalysis: null == sentimentAnalysis
          ? _value._sentimentAnalysis
          : sentimentAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      readabilityScore: null == readabilityScore
          ? _value.readabilityScore
          : readabilityScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentQualityMetricsImpl implements _ContentQualityMetrics {
  const _$ContentQualityMetricsImpl(
      {required this.contentId,
      required this.contentType,
      required this.qualityScore,
      required this.creativityIndex,
      required this.uniquenessScore,
      required this.wordCount,
      required final List<String> keywords,
      required final Map<String, double> sentimentAnalysis,
      required this.readabilityScore,
      required this.createdAt})
      : _keywords = keywords,
        _sentimentAnalysis = sentimentAnalysis;

  factory _$ContentQualityMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentQualityMetricsImplFromJson(json);

  @override
  final String contentId;
  @override
  final String contentType;
// 'story', 'image', 'caption'
  @override
  final double qualityScore;
  @override
  final double creativityIndex;
  @override
  final double uniquenessScore;
  @override
  final int wordCount;
  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  final Map<String, double> _sentimentAnalysis;
  @override
  Map<String, double> get sentimentAnalysis {
    if (_sentimentAnalysis is EqualUnmodifiableMapView)
      return _sentimentAnalysis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sentimentAnalysis);
  }

  @override
  final double readabilityScore;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentQualityMetrics(contentId: $contentId, contentType: $contentType, qualityScore: $qualityScore, creativityIndex: $creativityIndex, uniquenessScore: $uniquenessScore, wordCount: $wordCount, keywords: $keywords, sentimentAnalysis: $sentimentAnalysis, readabilityScore: $readabilityScore, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentQualityMetricsImpl &&
            (identical(other.contentId, contentId) ||
                other.contentId == contentId) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            (identical(other.creativityIndex, creativityIndex) ||
                other.creativityIndex == creativityIndex) &&
            (identical(other.uniquenessScore, uniquenessScore) ||
                other.uniquenessScore == uniquenessScore) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality()
                .equals(other._sentimentAnalysis, _sentimentAnalysis) &&
            (identical(other.readabilityScore, readabilityScore) ||
                other.readabilityScore == readabilityScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contentId,
      contentType,
      qualityScore,
      creativityIndex,
      uniquenessScore,
      wordCount,
      const DeepCollectionEquality().hash(_keywords),
      const DeepCollectionEquality().hash(_sentimentAnalysis),
      readabilityScore,
      createdAt);

  /// Create a copy of ContentQualityMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentQualityMetricsImplCopyWith<_$ContentQualityMetricsImpl>
      get copyWith => __$$ContentQualityMetricsImplCopyWithImpl<
          _$ContentQualityMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentQualityMetricsImplToJson(
      this,
    );
  }
}

abstract class _ContentQualityMetrics implements ContentQualityMetrics {
  const factory _ContentQualityMetrics(
      {required final String contentId,
      required final String contentType,
      required final double qualityScore,
      required final double creativityIndex,
      required final double uniquenessScore,
      required final int wordCount,
      required final List<String> keywords,
      required final Map<String, double> sentimentAnalysis,
      required final double readabilityScore,
      required final DateTime createdAt}) = _$ContentQualityMetricsImpl;

  factory _ContentQualityMetrics.fromJson(Map<String, dynamic> json) =
      _$ContentQualityMetricsImpl.fromJson;

  @override
  String get contentId;
  @override
  String get contentType; // 'story', 'image', 'caption'
  @override
  double get qualityScore;
  @override
  double get creativityIndex;
  @override
  double get uniquenessScore;
  @override
  int get wordCount;
  @override
  List<String> get keywords;
  @override
  Map<String, double> get sentimentAnalysis;
  @override
  double get readabilityScore;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentQualityMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentQualityMetricsImplCopyWith<_$ContentQualityMetricsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PerformanceMetrics _$PerformanceMetricsFromJson(Map<String, dynamic> json) {
  return _PerformanceMetrics.fromJson(json);
}

/// @nodoc
mixin _$PerformanceMetrics {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get averageResponseTime => throw _privateConstructorUsedError;
  double get successRate => throw _privateConstructorUsedError;
  int get totalRequests => throw _privateConstructorUsedError;
  int get errorCount => throw _privateConstructorUsedError;
  Map<String, double> get featurePerformance =>
      throw _privateConstructorUsedError;
  double get cpuUsage => throw _privateConstructorUsedError;
  double get memoryUsage => throw _privateConstructorUsedError;
  double get networkLatency => throw _privateConstructorUsedError;

  /// Serializes this PerformanceMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerformanceMetricsCopyWith<PerformanceMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceMetricsCopyWith<$Res> {
  factory $PerformanceMetricsCopyWith(
          PerformanceMetrics value, $Res Function(PerformanceMetrics) then) =
      _$PerformanceMetricsCopyWithImpl<$Res, PerformanceMetrics>;
  @useResult
  $Res call(
      {DateTime timestamp,
      double averageResponseTime,
      double successRate,
      int totalRequests,
      int errorCount,
      Map<String, double> featurePerformance,
      double cpuUsage,
      double memoryUsage,
      double networkLatency});
}

/// @nodoc
class _$PerformanceMetricsCopyWithImpl<$Res, $Val extends PerformanceMetrics>
    implements $PerformanceMetricsCopyWith<$Res> {
  _$PerformanceMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? averageResponseTime = null,
    Object? successRate = null,
    Object? totalRequests = null,
    Object? errorCount = null,
    Object? featurePerformance = null,
    Object? cpuUsage = null,
    Object? memoryUsage = null,
    Object? networkLatency = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      averageResponseTime: null == averageResponseTime
          ? _value.averageResponseTime
          : averageResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      errorCount: null == errorCount
          ? _value.errorCount
          : errorCount // ignore: cast_nullable_to_non_nullable
              as int,
      featurePerformance: null == featurePerformance
          ? _value.featurePerformance
          : featurePerformance // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      cpuUsage: null == cpuUsage
          ? _value.cpuUsage
          : cpuUsage // ignore: cast_nullable_to_non_nullable
              as double,
      memoryUsage: null == memoryUsage
          ? _value.memoryUsage
          : memoryUsage // ignore: cast_nullable_to_non_nullable
              as double,
      networkLatency: null == networkLatency
          ? _value.networkLatency
          : networkLatency // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerformanceMetricsImplCopyWith<$Res>
    implements $PerformanceMetricsCopyWith<$Res> {
  factory _$$PerformanceMetricsImplCopyWith(_$PerformanceMetricsImpl value,
          $Res Function(_$PerformanceMetricsImpl) then) =
      __$$PerformanceMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      double averageResponseTime,
      double successRate,
      int totalRequests,
      int errorCount,
      Map<String, double> featurePerformance,
      double cpuUsage,
      double memoryUsage,
      double networkLatency});
}

/// @nodoc
class __$$PerformanceMetricsImplCopyWithImpl<$Res>
    extends _$PerformanceMetricsCopyWithImpl<$Res, _$PerformanceMetricsImpl>
    implements _$$PerformanceMetricsImplCopyWith<$Res> {
  __$$PerformanceMetricsImplCopyWithImpl(_$PerformanceMetricsImpl _value,
      $Res Function(_$PerformanceMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? averageResponseTime = null,
    Object? successRate = null,
    Object? totalRequests = null,
    Object? errorCount = null,
    Object? featurePerformance = null,
    Object? cpuUsage = null,
    Object? memoryUsage = null,
    Object? networkLatency = null,
  }) {
    return _then(_$PerformanceMetricsImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      averageResponseTime: null == averageResponseTime
          ? _value.averageResponseTime
          : averageResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      errorCount: null == errorCount
          ? _value.errorCount
          : errorCount // ignore: cast_nullable_to_non_nullable
              as int,
      featurePerformance: null == featurePerformance
          ? _value._featurePerformance
          : featurePerformance // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      cpuUsage: null == cpuUsage
          ? _value.cpuUsage
          : cpuUsage // ignore: cast_nullable_to_non_nullable
              as double,
      memoryUsage: null == memoryUsage
          ? _value.memoryUsage
          : memoryUsage // ignore: cast_nullable_to_non_nullable
              as double,
      networkLatency: null == networkLatency
          ? _value.networkLatency
          : networkLatency // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceMetricsImpl implements _PerformanceMetrics {
  const _$PerformanceMetricsImpl(
      {required this.timestamp,
      required this.averageResponseTime,
      required this.successRate,
      required this.totalRequests,
      required this.errorCount,
      required final Map<String, double> featurePerformance,
      required this.cpuUsage,
      required this.memoryUsage,
      required this.networkLatency})
      : _featurePerformance = featurePerformance;

  factory _$PerformanceMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceMetricsImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final double averageResponseTime;
  @override
  final double successRate;
  @override
  final int totalRequests;
  @override
  final int errorCount;
  final Map<String, double> _featurePerformance;
  @override
  Map<String, double> get featurePerformance {
    if (_featurePerformance is EqualUnmodifiableMapView)
      return _featurePerformance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_featurePerformance);
  }

  @override
  final double cpuUsage;
  @override
  final double memoryUsage;
  @override
  final double networkLatency;

  @override
  String toString() {
    return 'PerformanceMetrics(timestamp: $timestamp, averageResponseTime: $averageResponseTime, successRate: $successRate, totalRequests: $totalRequests, errorCount: $errorCount, featurePerformance: $featurePerformance, cpuUsage: $cpuUsage, memoryUsage: $memoryUsage, networkLatency: $networkLatency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceMetricsImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.averageResponseTime, averageResponseTime) ||
                other.averageResponseTime == averageResponseTime) &&
            (identical(other.successRate, successRate) ||
                other.successRate == successRate) &&
            (identical(other.totalRequests, totalRequests) ||
                other.totalRequests == totalRequests) &&
            (identical(other.errorCount, errorCount) ||
                other.errorCount == errorCount) &&
            const DeepCollectionEquality()
                .equals(other._featurePerformance, _featurePerformance) &&
            (identical(other.cpuUsage, cpuUsage) ||
                other.cpuUsage == cpuUsage) &&
            (identical(other.memoryUsage, memoryUsage) ||
                other.memoryUsage == memoryUsage) &&
            (identical(other.networkLatency, networkLatency) ||
                other.networkLatency == networkLatency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      timestamp,
      averageResponseTime,
      successRate,
      totalRequests,
      errorCount,
      const DeepCollectionEquality().hash(_featurePerformance),
      cpuUsage,
      memoryUsage,
      networkLatency);

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      __$$PerformanceMetricsImplCopyWithImpl<_$PerformanceMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformanceMetricsImplToJson(
      this,
    );
  }
}

abstract class _PerformanceMetrics implements PerformanceMetrics {
  const factory _PerformanceMetrics(
      {required final DateTime timestamp,
      required final double averageResponseTime,
      required final double successRate,
      required final int totalRequests,
      required final int errorCount,
      required final Map<String, double> featurePerformance,
      required final double cpuUsage,
      required final double memoryUsage,
      required final double networkLatency}) = _$PerformanceMetricsImpl;

  factory _PerformanceMetrics.fromJson(Map<String, dynamic> json) =
      _$PerformanceMetricsImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  double get averageResponseTime;
  @override
  double get successRate;
  @override
  int get totalRequests;
  @override
  int get errorCount;
  @override
  Map<String, double> get featurePerformance;
  @override
  double get cpuUsage;
  @override
  double get memoryUsage;
  @override
  double get networkLatency;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EngagementMetrics _$EngagementMetricsFromJson(Map<String, dynamic> json) {
  return _EngagementMetrics.fromJson(json);
}

/// @nodoc
mixin _$EngagementMetrics {
  String get userId => throw _privateConstructorUsedError;
  int get sessionCount => throw _privateConstructorUsedError;
  double get averageSessionDuration => throw _privateConstructorUsedError;
  int get pageViews => throw _privateConstructorUsedError;
  Map<String, int> get featureUsage => throw _privateConstructorUsedError;
  List<String> get mostUsedFeatures => throw _privateConstructorUsedError;
  double get retentionRate => throw _privateConstructorUsedError;
  int get shareCount => throw _privateConstructorUsedError;
  int get favoriteCount => throw _privateConstructorUsedError;
  DateTime get firstVisit => throw _privateConstructorUsedError;
  DateTime get lastVisit => throw _privateConstructorUsedError;

  /// Serializes this EngagementMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EngagementMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EngagementMetricsCopyWith<EngagementMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EngagementMetricsCopyWith<$Res> {
  factory $EngagementMetricsCopyWith(
          EngagementMetrics value, $Res Function(EngagementMetrics) then) =
      _$EngagementMetricsCopyWithImpl<$Res, EngagementMetrics>;
  @useResult
  $Res call(
      {String userId,
      int sessionCount,
      double averageSessionDuration,
      int pageViews,
      Map<String, int> featureUsage,
      List<String> mostUsedFeatures,
      double retentionRate,
      int shareCount,
      int favoriteCount,
      DateTime firstVisit,
      DateTime lastVisit});
}

/// @nodoc
class _$EngagementMetricsCopyWithImpl<$Res, $Val extends EngagementMetrics>
    implements $EngagementMetricsCopyWith<$Res> {
  _$EngagementMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EngagementMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? sessionCount = null,
    Object? averageSessionDuration = null,
    Object? pageViews = null,
    Object? featureUsage = null,
    Object? mostUsedFeatures = null,
    Object? retentionRate = null,
    Object? shareCount = null,
    Object? favoriteCount = null,
    Object? firstVisit = null,
    Object? lastVisit = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionCount: null == sessionCount
          ? _value.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageSessionDuration: null == averageSessionDuration
          ? _value.averageSessionDuration
          : averageSessionDuration // ignore: cast_nullable_to_non_nullable
              as double,
      pageViews: null == pageViews
          ? _value.pageViews
          : pageViews // ignore: cast_nullable_to_non_nullable
              as int,
      featureUsage: null == featureUsage
          ? _value.featureUsage
          : featureUsage // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      mostUsedFeatures: null == mostUsedFeatures
          ? _value.mostUsedFeatures
          : mostUsedFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      retentionRate: null == retentionRate
          ? _value.retentionRate
          : retentionRate // ignore: cast_nullable_to_non_nullable
              as double,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteCount: null == favoriteCount
          ? _value.favoriteCount
          : favoriteCount // ignore: cast_nullable_to_non_nullable
              as int,
      firstVisit: null == firstVisit
          ? _value.firstVisit
          : firstVisit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastVisit: null == lastVisit
          ? _value.lastVisit
          : lastVisit // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EngagementMetricsImplCopyWith<$Res>
    implements $EngagementMetricsCopyWith<$Res> {
  factory _$$EngagementMetricsImplCopyWith(_$EngagementMetricsImpl value,
          $Res Function(_$EngagementMetricsImpl) then) =
      __$$EngagementMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int sessionCount,
      double averageSessionDuration,
      int pageViews,
      Map<String, int> featureUsage,
      List<String> mostUsedFeatures,
      double retentionRate,
      int shareCount,
      int favoriteCount,
      DateTime firstVisit,
      DateTime lastVisit});
}

/// @nodoc
class __$$EngagementMetricsImplCopyWithImpl<$Res>
    extends _$EngagementMetricsCopyWithImpl<$Res, _$EngagementMetricsImpl>
    implements _$$EngagementMetricsImplCopyWith<$Res> {
  __$$EngagementMetricsImplCopyWithImpl(_$EngagementMetricsImpl _value,
      $Res Function(_$EngagementMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of EngagementMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? sessionCount = null,
    Object? averageSessionDuration = null,
    Object? pageViews = null,
    Object? featureUsage = null,
    Object? mostUsedFeatures = null,
    Object? retentionRate = null,
    Object? shareCount = null,
    Object? favoriteCount = null,
    Object? firstVisit = null,
    Object? lastVisit = null,
  }) {
    return _then(_$EngagementMetricsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionCount: null == sessionCount
          ? _value.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageSessionDuration: null == averageSessionDuration
          ? _value.averageSessionDuration
          : averageSessionDuration // ignore: cast_nullable_to_non_nullable
              as double,
      pageViews: null == pageViews
          ? _value.pageViews
          : pageViews // ignore: cast_nullable_to_non_nullable
              as int,
      featureUsage: null == featureUsage
          ? _value._featureUsage
          : featureUsage // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      mostUsedFeatures: null == mostUsedFeatures
          ? _value._mostUsedFeatures
          : mostUsedFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      retentionRate: null == retentionRate
          ? _value.retentionRate
          : retentionRate // ignore: cast_nullable_to_non_nullable
              as double,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteCount: null == favoriteCount
          ? _value.favoriteCount
          : favoriteCount // ignore: cast_nullable_to_non_nullable
              as int,
      firstVisit: null == firstVisit
          ? _value.firstVisit
          : firstVisit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastVisit: null == lastVisit
          ? _value.lastVisit
          : lastVisit // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EngagementMetricsImpl implements _EngagementMetrics {
  const _$EngagementMetricsImpl(
      {required this.userId,
      required this.sessionCount,
      required this.averageSessionDuration,
      required this.pageViews,
      required final Map<String, int> featureUsage,
      required final List<String> mostUsedFeatures,
      required this.retentionRate,
      required this.shareCount,
      required this.favoriteCount,
      required this.firstVisit,
      required this.lastVisit})
      : _featureUsage = featureUsage,
        _mostUsedFeatures = mostUsedFeatures;

  factory _$EngagementMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EngagementMetricsImplFromJson(json);

  @override
  final String userId;
  @override
  final int sessionCount;
  @override
  final double averageSessionDuration;
  @override
  final int pageViews;
  final Map<String, int> _featureUsage;
  @override
  Map<String, int> get featureUsage {
    if (_featureUsage is EqualUnmodifiableMapView) return _featureUsage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_featureUsage);
  }

  final List<String> _mostUsedFeatures;
  @override
  List<String> get mostUsedFeatures {
    if (_mostUsedFeatures is EqualUnmodifiableListView)
      return _mostUsedFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mostUsedFeatures);
  }

  @override
  final double retentionRate;
  @override
  final int shareCount;
  @override
  final int favoriteCount;
  @override
  final DateTime firstVisit;
  @override
  final DateTime lastVisit;

  @override
  String toString() {
    return 'EngagementMetrics(userId: $userId, sessionCount: $sessionCount, averageSessionDuration: $averageSessionDuration, pageViews: $pageViews, featureUsage: $featureUsage, mostUsedFeatures: $mostUsedFeatures, retentionRate: $retentionRate, shareCount: $shareCount, favoriteCount: $favoriteCount, firstVisit: $firstVisit, lastVisit: $lastVisit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EngagementMetricsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount) &&
            (identical(other.averageSessionDuration, averageSessionDuration) ||
                other.averageSessionDuration == averageSessionDuration) &&
            (identical(other.pageViews, pageViews) ||
                other.pageViews == pageViews) &&
            const DeepCollectionEquality()
                .equals(other._featureUsage, _featureUsage) &&
            const DeepCollectionEquality()
                .equals(other._mostUsedFeatures, _mostUsedFeatures) &&
            (identical(other.retentionRate, retentionRate) ||
                other.retentionRate == retentionRate) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount) &&
            (identical(other.favoriteCount, favoriteCount) ||
                other.favoriteCount == favoriteCount) &&
            (identical(other.firstVisit, firstVisit) ||
                other.firstVisit == firstVisit) &&
            (identical(other.lastVisit, lastVisit) ||
                other.lastVisit == lastVisit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      sessionCount,
      averageSessionDuration,
      pageViews,
      const DeepCollectionEquality().hash(_featureUsage),
      const DeepCollectionEquality().hash(_mostUsedFeatures),
      retentionRate,
      shareCount,
      favoriteCount,
      firstVisit,
      lastVisit);

  /// Create a copy of EngagementMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EngagementMetricsImplCopyWith<_$EngagementMetricsImpl> get copyWith =>
      __$$EngagementMetricsImplCopyWithImpl<_$EngagementMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EngagementMetricsImplToJson(
      this,
    );
  }
}

abstract class _EngagementMetrics implements EngagementMetrics {
  const factory _EngagementMetrics(
      {required final String userId,
      required final int sessionCount,
      required final double averageSessionDuration,
      required final int pageViews,
      required final Map<String, int> featureUsage,
      required final List<String> mostUsedFeatures,
      required final double retentionRate,
      required final int shareCount,
      required final int favoriteCount,
      required final DateTime firstVisit,
      required final DateTime lastVisit}) = _$EngagementMetricsImpl;

  factory _EngagementMetrics.fromJson(Map<String, dynamic> json) =
      _$EngagementMetricsImpl.fromJson;

  @override
  String get userId;
  @override
  int get sessionCount;
  @override
  double get averageSessionDuration;
  @override
  int get pageViews;
  @override
  Map<String, int> get featureUsage;
  @override
  List<String> get mostUsedFeatures;
  @override
  double get retentionRate;
  @override
  int get shareCount;
  @override
  int get favoriteCount;
  @override
  DateTime get firstVisit;
  @override
  DateTime get lastVisit;

  /// Create a copy of EngagementMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EngagementMetricsImplCopyWith<_$EngagementMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsDashboardData _$AnalyticsDashboardDataFromJson(
    Map<String, dynamic> json) {
  return _AnalyticsDashboardData.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsDashboardData {
  UserStats get userStats => throw _privateConstructorUsedError;
  List<ContentQualityMetrics> get recentContent =>
      throw _privateConstructorUsedError;
  PerformanceMetrics get performance => throw _privateConstructorUsedError;
  EngagementMetrics get engagement => throw _privateConstructorUsedError;
  List<TrendingInsight> get insights => throw _privateConstructorUsedError;
  Map<String, double> get weeklyProgress => throw _privateConstructorUsedError;
  List<Achievement> get achievements => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsDashboardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDashboardDataCopyWith<AnalyticsDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDashboardDataCopyWith<$Res> {
  factory $AnalyticsDashboardDataCopyWith(AnalyticsDashboardData value,
          $Res Function(AnalyticsDashboardData) then) =
      _$AnalyticsDashboardDataCopyWithImpl<$Res, AnalyticsDashboardData>;
  @useResult
  $Res call(
      {UserStats userStats,
      List<ContentQualityMetrics> recentContent,
      PerformanceMetrics performance,
      EngagementMetrics engagement,
      List<TrendingInsight> insights,
      Map<String, double> weeklyProgress,
      List<Achievement> achievements});

  $UserStatsCopyWith<$Res> get userStats;
  $PerformanceMetricsCopyWith<$Res> get performance;
  $EngagementMetricsCopyWith<$Res> get engagement;
}

/// @nodoc
class _$AnalyticsDashboardDataCopyWithImpl<$Res,
        $Val extends AnalyticsDashboardData>
    implements $AnalyticsDashboardDataCopyWith<$Res> {
  _$AnalyticsDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userStats = null,
    Object? recentContent = null,
    Object? performance = null,
    Object? engagement = null,
    Object? insights = null,
    Object? weeklyProgress = null,
    Object? achievements = null,
  }) {
    return _then(_value.copyWith(
      userStats: null == userStats
          ? _value.userStats
          : userStats // ignore: cast_nullable_to_non_nullable
              as UserStats,
      recentContent: null == recentContent
          ? _value.recentContent
          : recentContent // ignore: cast_nullable_to_non_nullable
              as List<ContentQualityMetrics>,
      performance: null == performance
          ? _value.performance
          : performance // ignore: cast_nullable_to_non_nullable
              as PerformanceMetrics,
      engagement: null == engagement
          ? _value.engagement
          : engagement // ignore: cast_nullable_to_non_nullable
              as EngagementMetrics,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<TrendingInsight>,
      weeklyProgress: null == weeklyProgress
          ? _value.weeklyProgress
          : weeklyProgress // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      achievements: null == achievements
          ? _value.achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<Achievement>,
    ) as $Val);
  }

  /// Create a copy of AnalyticsDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserStatsCopyWith<$Res> get userStats {
    return $UserStatsCopyWith<$Res>(_value.userStats, (value) {
      return _then(_value.copyWith(userStats: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerformanceMetricsCopyWith<$Res> get performance {
    return $PerformanceMetricsCopyWith<$Res>(_value.performance, (value) {
      return _then(_value.copyWith(performance: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EngagementMetricsCopyWith<$Res> get engagement {
    return $EngagementMetricsCopyWith<$Res>(_value.engagement, (value) {
      return _then(_value.copyWith(engagement: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsDashboardDataImplCopyWith<$Res>
    implements $AnalyticsDashboardDataCopyWith<$Res> {
  factory _$$AnalyticsDashboardDataImplCopyWith(
          _$AnalyticsDashboardDataImpl value,
          $Res Function(_$AnalyticsDashboardDataImpl) then) =
      __$$AnalyticsDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserStats userStats,
      List<ContentQualityMetrics> recentContent,
      PerformanceMetrics performance,
      EngagementMetrics engagement,
      List<TrendingInsight> insights,
      Map<String, double> weeklyProgress,
      List<Achievement> achievements});

  @override
  $UserStatsCopyWith<$Res> get userStats;
  @override
  $PerformanceMetricsCopyWith<$Res> get performance;
  @override
  $EngagementMetricsCopyWith<$Res> get engagement;
}

/// @nodoc
class __$$AnalyticsDashboardDataImplCopyWithImpl<$Res>
    extends _$AnalyticsDashboardDataCopyWithImpl<$Res,
        _$AnalyticsDashboardDataImpl>
    implements _$$AnalyticsDashboardDataImplCopyWith<$Res> {
  __$$AnalyticsDashboardDataImplCopyWithImpl(
      _$AnalyticsDashboardDataImpl _value,
      $Res Function(_$AnalyticsDashboardDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userStats = null,
    Object? recentContent = null,
    Object? performance = null,
    Object? engagement = null,
    Object? insights = null,
    Object? weeklyProgress = null,
    Object? achievements = null,
  }) {
    return _then(_$AnalyticsDashboardDataImpl(
      userStats: null == userStats
          ? _value.userStats
          : userStats // ignore: cast_nullable_to_non_nullable
              as UserStats,
      recentContent: null == recentContent
          ? _value._recentContent
          : recentContent // ignore: cast_nullable_to_non_nullable
              as List<ContentQualityMetrics>,
      performance: null == performance
          ? _value.performance
          : performance // ignore: cast_nullable_to_non_nullable
              as PerformanceMetrics,
      engagement: null == engagement
          ? _value.engagement
          : engagement // ignore: cast_nullable_to_non_nullable
              as EngagementMetrics,
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<TrendingInsight>,
      weeklyProgress: null == weeklyProgress
          ? _value._weeklyProgress
          : weeklyProgress // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      achievements: null == achievements
          ? _value._achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<Achievement>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDashboardDataImpl implements _AnalyticsDashboardData {
  const _$AnalyticsDashboardDataImpl(
      {required this.userStats,
      required final List<ContentQualityMetrics> recentContent,
      required this.performance,
      required this.engagement,
      required final List<TrendingInsight> insights,
      required final Map<String, double> weeklyProgress,
      required final List<Achievement> achievements})
      : _recentContent = recentContent,
        _insights = insights,
        _weeklyProgress = weeklyProgress,
        _achievements = achievements;

  factory _$AnalyticsDashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDashboardDataImplFromJson(json);

  @override
  final UserStats userStats;
  final List<ContentQualityMetrics> _recentContent;
  @override
  List<ContentQualityMetrics> get recentContent {
    if (_recentContent is EqualUnmodifiableListView) return _recentContent;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentContent);
  }

  @override
  final PerformanceMetrics performance;
  @override
  final EngagementMetrics engagement;
  final List<TrendingInsight> _insights;
  @override
  List<TrendingInsight> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  final Map<String, double> _weeklyProgress;
  @override
  Map<String, double> get weeklyProgress {
    if (_weeklyProgress is EqualUnmodifiableMapView) return _weeklyProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weeklyProgress);
  }

  final List<Achievement> _achievements;
  @override
  List<Achievement> get achievements {
    if (_achievements is EqualUnmodifiableListView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievements);
  }

  @override
  String toString() {
    return 'AnalyticsDashboardData(userStats: $userStats, recentContent: $recentContent, performance: $performance, engagement: $engagement, insights: $insights, weeklyProgress: $weeklyProgress, achievements: $achievements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDashboardDataImpl &&
            (identical(other.userStats, userStats) ||
                other.userStats == userStats) &&
            const DeepCollectionEquality()
                .equals(other._recentContent, _recentContent) &&
            (identical(other.performance, performance) ||
                other.performance == performance) &&
            (identical(other.engagement, engagement) ||
                other.engagement == engagement) &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            const DeepCollectionEquality()
                .equals(other._weeklyProgress, _weeklyProgress) &&
            const DeepCollectionEquality()
                .equals(other._achievements, _achievements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userStats,
      const DeepCollectionEquality().hash(_recentContent),
      performance,
      engagement,
      const DeepCollectionEquality().hash(_insights),
      const DeepCollectionEquality().hash(_weeklyProgress),
      const DeepCollectionEquality().hash(_achievements));

  /// Create a copy of AnalyticsDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDashboardDataImplCopyWith<_$AnalyticsDashboardDataImpl>
      get copyWith => __$$AnalyticsDashboardDataImplCopyWithImpl<
          _$AnalyticsDashboardDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDashboardDataImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsDashboardData implements AnalyticsDashboardData {
  const factory _AnalyticsDashboardData(
          {required final UserStats userStats,
          required final List<ContentQualityMetrics> recentContent,
          required final PerformanceMetrics performance,
          required final EngagementMetrics engagement,
          required final List<TrendingInsight> insights,
          required final Map<String, double> weeklyProgress,
          required final List<Achievement> achievements}) =
      _$AnalyticsDashboardDataImpl;

  factory _AnalyticsDashboardData.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDashboardDataImpl.fromJson;

  @override
  UserStats get userStats;
  @override
  List<ContentQualityMetrics> get recentContent;
  @override
  PerformanceMetrics get performance;
  @override
  EngagementMetrics get engagement;
  @override
  List<TrendingInsight> get insights;
  @override
  Map<String, double> get weeklyProgress;
  @override
  List<Achievement> get achievements;

  /// Create a copy of AnalyticsDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDashboardDataImplCopyWith<_$AnalyticsDashboardDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TrendingInsight _$TrendingInsightFromJson(Map<String, dynamic> json) {
  return _TrendingInsight.fromJson(json);
}

/// @nodoc
mixin _$TrendingInsight {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get impact => throw _privateConstructorUsedError;
  String get recommendation => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this TrendingInsight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrendingInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrendingInsightCopyWith<TrendingInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendingInsightCopyWith<$Res> {
  factory $TrendingInsightCopyWith(
          TrendingInsight value, $Res Function(TrendingInsight) then) =
      _$TrendingInsightCopyWithImpl<$Res, TrendingInsight>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String category,
      double impact,
      String recommendation,
      DateTime generatedAt});
}

/// @nodoc
class _$TrendingInsightCopyWithImpl<$Res, $Val extends TrendingInsight>
    implements $TrendingInsightCopyWith<$Res> {
  _$TrendingInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrendingInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? impact = null,
    Object? recommendation = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as double,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrendingInsightImplCopyWith<$Res>
    implements $TrendingInsightCopyWith<$Res> {
  factory _$$TrendingInsightImplCopyWith(_$TrendingInsightImpl value,
          $Res Function(_$TrendingInsightImpl) then) =
      __$$TrendingInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String category,
      double impact,
      String recommendation,
      DateTime generatedAt});
}

/// @nodoc
class __$$TrendingInsightImplCopyWithImpl<$Res>
    extends _$TrendingInsightCopyWithImpl<$Res, _$TrendingInsightImpl>
    implements _$$TrendingInsightImplCopyWith<$Res> {
  __$$TrendingInsightImplCopyWithImpl(
      _$TrendingInsightImpl _value, $Res Function(_$TrendingInsightImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrendingInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? impact = null,
    Object? recommendation = null,
    Object? generatedAt = null,
  }) {
    return _then(_$TrendingInsightImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as double,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendingInsightImpl implements _TrendingInsight {
  const _$TrendingInsightImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.impact,
      required this.recommendation,
      required this.generatedAt});

  factory _$TrendingInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendingInsightImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String category;
  @override
  final double impact;
  @override
  final String recommendation;
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'TrendingInsight(id: $id, title: $title, description: $description, category: $category, impact: $impact, recommendation: $recommendation, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendingInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, category,
      impact, recommendation, generatedAt);

  /// Create a copy of TrendingInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendingInsightImplCopyWith<_$TrendingInsightImpl> get copyWith =>
      __$$TrendingInsightImplCopyWithImpl<_$TrendingInsightImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendingInsightImplToJson(
      this,
    );
  }
}

abstract class _TrendingInsight implements TrendingInsight {
  const factory _TrendingInsight(
      {required final String id,
      required final String title,
      required final String description,
      required final String category,
      required final double impact,
      required final String recommendation,
      required final DateTime generatedAt}) = _$TrendingInsightImpl;

  factory _TrendingInsight.fromJson(Map<String, dynamic> json) =
      _$TrendingInsightImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get category;
  @override
  double get impact;
  @override
  String get recommendation;
  @override
  DateTime get generatedAt;

  /// Create a copy of TrendingInsight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrendingInsightImplCopyWith<_$TrendingInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return _Achievement.fromJson(json);
}

/// @nodoc
mixin _$Achievement {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  bool get isUnlocked => throw _privateConstructorUsedError;
  DateTime? get unlockedAt => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;
  int get target => throw _privateConstructorUsedError;
  String get iconPath => throw _privateConstructorUsedError;
  String get badgeColor => throw _privateConstructorUsedError;

  /// Serializes this Achievement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AchievementCopyWith<Achievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementCopyWith<$Res> {
  factory $AchievementCopyWith(
          Achievement value, $Res Function(Achievement) then) =
      _$AchievementCopyWithImpl<$Res, Achievement>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String category,
      bool isUnlocked,
      DateTime? unlockedAt,
      int progress,
      int target,
      String iconPath,
      String badgeColor});
}

/// @nodoc
class _$AchievementCopyWithImpl<$Res, $Val extends Achievement>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? progress = null,
    Object? target = null,
    Object? iconPath = null,
    Object? badgeColor = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as int,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      badgeColor: null == badgeColor
          ? _value.badgeColor
          : badgeColor // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AchievementImplCopyWith<$Res>
    implements $AchievementCopyWith<$Res> {
  factory _$$AchievementImplCopyWith(
          _$AchievementImpl value, $Res Function(_$AchievementImpl) then) =
      __$$AchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String category,
      bool isUnlocked,
      DateTime? unlockedAt,
      int progress,
      int target,
      String iconPath,
      String badgeColor});
}

/// @nodoc
class __$$AchievementImplCopyWithImpl<$Res>
    extends _$AchievementCopyWithImpl<$Res, _$AchievementImpl>
    implements _$$AchievementImplCopyWith<$Res> {
  __$$AchievementImplCopyWithImpl(
      _$AchievementImpl _value, $Res Function(_$AchievementImpl) _then)
      : super(_value, _then);

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? progress = null,
    Object? target = null,
    Object? iconPath = null,
    Object? badgeColor = null,
  }) {
    return _then(_$AchievementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as int,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      badgeColor: null == badgeColor
          ? _value.badgeColor
          : badgeColor // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementImpl implements _Achievement {
  const _$AchievementImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.isUnlocked,
      required this.unlockedAt,
      required this.progress,
      required this.target,
      required this.iconPath,
      required this.badgeColor});

  factory _$AchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String category;
  @override
  final bool isUnlocked;
  @override
  final DateTime? unlockedAt;
  @override
  final int progress;
  @override
  final int target;
  @override
  final String iconPath;
  @override
  final String badgeColor;

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, description: $description, category: $category, isUnlocked: $isUnlocked, unlockedAt: $unlockedAt, progress: $progress, target: $target, iconPath: $iconPath, badgeColor: $badgeColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath) &&
            (identical(other.badgeColor, badgeColor) ||
                other.badgeColor == badgeColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, category,
      isUnlocked, unlockedAt, progress, target, iconPath, badgeColor);

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      __$$AchievementImplCopyWithImpl<_$AchievementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementImplToJson(
      this,
    );
  }
}

abstract class _Achievement implements Achievement {
  const factory _Achievement(
      {required final String id,
      required final String title,
      required final String description,
      required final String category,
      required final bool isUnlocked,
      required final DateTime? unlockedAt,
      required final int progress,
      required final int target,
      required final String iconPath,
      required final String badgeColor}) = _$AchievementImpl;

  factory _Achievement.fromJson(Map<String, dynamic> json) =
      _$AchievementImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get category;
  @override
  bool get isUnlocked;
  @override
  DateTime? get unlockedAt;
  @override
  int get progress;
  @override
  int get target;
  @override
  String get iconPath;
  @override
  String get badgeColor;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChartDataPoint _$ChartDataPointFromJson(Map<String, dynamic> json) {
  return _ChartDataPoint.fromJson(json);
}

/// @nodoc
mixin _$ChartDataPoint {
  DateTime get date => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  /// Serializes this ChartDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChartDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartDataPointCopyWith<ChartDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartDataPointCopyWith<$Res> {
  factory $ChartDataPointCopyWith(
          ChartDataPoint value, $Res Function(ChartDataPoint) then) =
      _$ChartDataPointCopyWithImpl<$Res, ChartDataPoint>;
  @useResult
  $Res call({DateTime date, double value, String label});
}

/// @nodoc
class _$ChartDataPointCopyWithImpl<$Res, $Val extends ChartDataPoint>
    implements $ChartDataPointCopyWith<$Res> {
  _$ChartDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartDataPointImplCopyWith<$Res>
    implements $ChartDataPointCopyWith<$Res> {
  factory _$$ChartDataPointImplCopyWith(_$ChartDataPointImpl value,
          $Res Function(_$ChartDataPointImpl) then) =
      __$$ChartDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double value, String label});
}

/// @nodoc
class __$$ChartDataPointImplCopyWithImpl<$Res>
    extends _$ChartDataPointCopyWithImpl<$Res, _$ChartDataPointImpl>
    implements _$$ChartDataPointImplCopyWith<$Res> {
  __$$ChartDataPointImplCopyWithImpl(
      _$ChartDataPointImpl _value, $Res Function(_$ChartDataPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChartDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_$ChartDataPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartDataPointImpl implements _ChartDataPoint {
  const _$ChartDataPointImpl(
      {required this.date, required this.value, required this.label});

  factory _$ChartDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartDataPointImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double value;
  @override
  final String label;

  @override
  String toString() {
    return 'ChartDataPoint(date: $date, value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, value, label);

  /// Create a copy of ChartDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartDataPointImplCopyWith<_$ChartDataPointImpl> get copyWith =>
      __$$ChartDataPointImplCopyWithImpl<_$ChartDataPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartDataPointImplToJson(
      this,
    );
  }
}

abstract class _ChartDataPoint implements ChartDataPoint {
  const factory _ChartDataPoint(
      {required final DateTime date,
      required final double value,
      required final String label}) = _$ChartDataPointImpl;

  factory _ChartDataPoint.fromJson(Map<String, dynamic> json) =
      _$ChartDataPointImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get value;
  @override
  String get label;

  /// Create a copy of ChartDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartDataPointImplCopyWith<_$ChartDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportConfig _$ReportConfigFromJson(Map<String, dynamic> json) {
  return _ReportConfig.fromJson(json);
}

/// @nodoc
mixin _$ReportConfig {
  AnalyticsTimePeriod get period => throw _privateConstructorUsedError;
  List<String> get includedMetrics => throw _privateConstructorUsedError;
  String get format =>
      throw _privateConstructorUsedError; // 'pdf', 'csv', 'json'
  bool get includeCharts => throw _privateConstructorUsedError;
  bool get includeInsights => throw _privateConstructorUsedError;
  DateTime? get customStartDate => throw _privateConstructorUsedError;
  DateTime? get customEndDate => throw _privateConstructorUsedError;

  /// Serializes this ReportConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportConfigCopyWith<ReportConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportConfigCopyWith<$Res> {
  factory $ReportConfigCopyWith(
          ReportConfig value, $Res Function(ReportConfig) then) =
      _$ReportConfigCopyWithImpl<$Res, ReportConfig>;
  @useResult
  $Res call(
      {AnalyticsTimePeriod period,
      List<String> includedMetrics,
      String format,
      bool includeCharts,
      bool includeInsights,
      DateTime? customStartDate,
      DateTime? customEndDate});
}

/// @nodoc
class _$ReportConfigCopyWithImpl<$Res, $Val extends ReportConfig>
    implements $ReportConfigCopyWith<$Res> {
  _$ReportConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? includedMetrics = null,
    Object? format = null,
    Object? includeCharts = null,
    Object? includeInsights = null,
    Object? customStartDate = freezed,
    Object? customEndDate = freezed,
  }) {
    return _then(_value.copyWith(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as AnalyticsTimePeriod,
      includedMetrics: null == includedMetrics
          ? _value.includedMetrics
          : includedMetrics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      includeCharts: null == includeCharts
          ? _value.includeCharts
          : includeCharts // ignore: cast_nullable_to_non_nullable
              as bool,
      includeInsights: null == includeInsights
          ? _value.includeInsights
          : includeInsights // ignore: cast_nullable_to_non_nullable
              as bool,
      customStartDate: freezed == customStartDate
          ? _value.customStartDate
          : customStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customEndDate: freezed == customEndDate
          ? _value.customEndDate
          : customEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportConfigImplCopyWith<$Res>
    implements $ReportConfigCopyWith<$Res> {
  factory _$$ReportConfigImplCopyWith(
          _$ReportConfigImpl value, $Res Function(_$ReportConfigImpl) then) =
      __$$ReportConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AnalyticsTimePeriod period,
      List<String> includedMetrics,
      String format,
      bool includeCharts,
      bool includeInsights,
      DateTime? customStartDate,
      DateTime? customEndDate});
}

/// @nodoc
class __$$ReportConfigImplCopyWithImpl<$Res>
    extends _$ReportConfigCopyWithImpl<$Res, _$ReportConfigImpl>
    implements _$$ReportConfigImplCopyWith<$Res> {
  __$$ReportConfigImplCopyWithImpl(
      _$ReportConfigImpl _value, $Res Function(_$ReportConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? includedMetrics = null,
    Object? format = null,
    Object? includeCharts = null,
    Object? includeInsights = null,
    Object? customStartDate = freezed,
    Object? customEndDate = freezed,
  }) {
    return _then(_$ReportConfigImpl(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as AnalyticsTimePeriod,
      includedMetrics: null == includedMetrics
          ? _value._includedMetrics
          : includedMetrics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      includeCharts: null == includeCharts
          ? _value.includeCharts
          : includeCharts // ignore: cast_nullable_to_non_nullable
              as bool,
      includeInsights: null == includeInsights
          ? _value.includeInsights
          : includeInsights // ignore: cast_nullable_to_non_nullable
              as bool,
      customStartDate: freezed == customStartDate
          ? _value.customStartDate
          : customStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customEndDate: freezed == customEndDate
          ? _value.customEndDate
          : customEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportConfigImpl implements _ReportConfig {
  const _$ReportConfigImpl(
      {required this.period,
      required final List<String> includedMetrics,
      required this.format,
      required this.includeCharts,
      required this.includeInsights,
      required this.customStartDate,
      required this.customEndDate})
      : _includedMetrics = includedMetrics;

  factory _$ReportConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportConfigImplFromJson(json);

  @override
  final AnalyticsTimePeriod period;
  final List<String> _includedMetrics;
  @override
  List<String> get includedMetrics {
    if (_includedMetrics is EqualUnmodifiableListView) return _includedMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_includedMetrics);
  }

  @override
  final String format;
// 'pdf', 'csv', 'json'
  @override
  final bool includeCharts;
  @override
  final bool includeInsights;
  @override
  final DateTime? customStartDate;
  @override
  final DateTime? customEndDate;

  @override
  String toString() {
    return 'ReportConfig(period: $period, includedMetrics: $includedMetrics, format: $format, includeCharts: $includeCharts, includeInsights: $includeInsights, customStartDate: $customStartDate, customEndDate: $customEndDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportConfigImpl &&
            (identical(other.period, period) || other.period == period) &&
            const DeepCollectionEquality()
                .equals(other._includedMetrics, _includedMetrics) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.includeCharts, includeCharts) ||
                other.includeCharts == includeCharts) &&
            (identical(other.includeInsights, includeInsights) ||
                other.includeInsights == includeInsights) &&
            (identical(other.customStartDate, customStartDate) ||
                other.customStartDate == customStartDate) &&
            (identical(other.customEndDate, customEndDate) ||
                other.customEndDate == customEndDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      period,
      const DeepCollectionEquality().hash(_includedMetrics),
      format,
      includeCharts,
      includeInsights,
      customStartDate,
      customEndDate);

  /// Create a copy of ReportConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportConfigImplCopyWith<_$ReportConfigImpl> get copyWith =>
      __$$ReportConfigImplCopyWithImpl<_$ReportConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportConfigImplToJson(
      this,
    );
  }
}

abstract class _ReportConfig implements ReportConfig {
  const factory _ReportConfig(
      {required final AnalyticsTimePeriod period,
      required final List<String> includedMetrics,
      required final String format,
      required final bool includeCharts,
      required final bool includeInsights,
      required final DateTime? customStartDate,
      required final DateTime? customEndDate}) = _$ReportConfigImpl;

  factory _ReportConfig.fromJson(Map<String, dynamic> json) =
      _$ReportConfigImpl.fromJson;

  @override
  AnalyticsTimePeriod get period;
  @override
  List<String> get includedMetrics;
  @override
  String get format; // 'pdf', 'csv', 'json'
  @override
  bool get includeCharts;
  @override
  bool get includeInsights;
  @override
  DateTime? get customStartDate;
  @override
  DateTime? get customEndDate;

  /// Create a copy of ReportConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportConfigImplCopyWith<_$ReportConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
