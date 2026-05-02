// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GradeStats _$GradeStatsFromJson(Map<String, dynamic> json) {
  return _GradeStats.fromJson(json);
}

/// @nodoc
mixin _$GradeStats {
  int get grade => throw _privateConstructorUsedError;
  int get tier => throw _privateConstructorUsedError;
  int get totalBooks => throw _privateConstructorUsedError;
  int get totalSeconds => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;

  /// Serializes this GradeStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GradeStatsCopyWith<GradeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeStatsCopyWith<$Res> {
  factory $GradeStatsCopyWith(
          GradeStats value, $Res Function(GradeStats) then) =
      _$GradeStatsCopyWithImpl<$Res, GradeStats>;
  @useResult
  $Res call(
      {int grade, int tier, int totalBooks, int totalSeconds, int streakDays});
}

/// @nodoc
class _$GradeStatsCopyWithImpl<$Res, $Val extends GradeStats>
    implements $GradeStatsCopyWith<$Res> {
  _$GradeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grade = null,
    Object? tier = null,
    Object? totalBooks = null,
    Object? totalSeconds = null,
    Object? streakDays = null,
  }) {
    return _then(_value.copyWith(
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
      totalBooks: null == totalBooks
          ? _value.totalBooks
          : totalBooks // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeconds: null == totalSeconds
          ? _value.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GradeStatsImplCopyWith<$Res>
    implements $GradeStatsCopyWith<$Res> {
  factory _$$GradeStatsImplCopyWith(
          _$GradeStatsImpl value, $Res Function(_$GradeStatsImpl) then) =
      __$$GradeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int grade, int tier, int totalBooks, int totalSeconds, int streakDays});
}

/// @nodoc
class __$$GradeStatsImplCopyWithImpl<$Res>
    extends _$GradeStatsCopyWithImpl<$Res, _$GradeStatsImpl>
    implements _$$GradeStatsImplCopyWith<$Res> {
  __$$GradeStatsImplCopyWithImpl(
      _$GradeStatsImpl _value, $Res Function(_$GradeStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grade = null,
    Object? tier = null,
    Object? totalBooks = null,
    Object? totalSeconds = null,
    Object? streakDays = null,
  }) {
    return _then(_$GradeStatsImpl(
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
      totalBooks: null == totalBooks
          ? _value.totalBooks
          : totalBooks // ignore: cast_nullable_to_non_nullable
              as int,
      totalSeconds: null == totalSeconds
          ? _value.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GradeStatsImpl implements _GradeStats {
  const _$GradeStatsImpl(
      {required this.grade,
      required this.tier,
      required this.totalBooks,
      required this.totalSeconds,
      required this.streakDays});

  factory _$GradeStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GradeStatsImplFromJson(json);

  @override
  final int grade;
  @override
  final int tier;
  @override
  final int totalBooks;
  @override
  final int totalSeconds;
  @override
  final int streakDays;

  @override
  String toString() {
    return 'GradeStats(grade: $grade, tier: $tier, totalBooks: $totalBooks, totalSeconds: $totalSeconds, streakDays: $streakDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeStatsImpl &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.totalBooks, totalBooks) ||
                other.totalBooks == totalBooks) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, grade, tier, totalBooks, totalSeconds, streakDays);

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeStatsImplCopyWith<_$GradeStatsImpl> get copyWith =>
      __$$GradeStatsImplCopyWithImpl<_$GradeStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GradeStatsImplToJson(
      this,
    );
  }
}

abstract class _GradeStats implements GradeStats {
  const factory _GradeStats(
      {required final int grade,
      required final int tier,
      required final int totalBooks,
      required final int totalSeconds,
      required final int streakDays}) = _$GradeStatsImpl;

  factory _GradeStats.fromJson(Map<String, dynamic> json) =
      _$GradeStatsImpl.fromJson;

  @override
  int get grade;
  @override
  int get tier;
  @override
  int get totalBooks;
  @override
  int get totalSeconds;
  @override
  int get streakDays;

  /// Create a copy of GradeStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeStatsImplCopyWith<_$GradeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BadgeSummary _$BadgeSummaryFromJson(Map<String, dynamic> json) {
  return _BadgeSummary.fromJson(json);
}

/// @nodoc
mixin _$BadgeSummary {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get iconUrl => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get earnedAt => throw _privateConstructorUsedError;

  /// Serializes this BadgeSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeSummaryCopyWith<BadgeSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeSummaryCopyWith<$Res> {
  factory $BadgeSummaryCopyWith(
          BadgeSummary value, $Res Function(BadgeSummary) then) =
      _$BadgeSummaryCopyWithImpl<$Res, BadgeSummary>;
  @useResult
  $Res call(
      {String id,
      String name,
      String iconUrl,
      String category,
      DateTime earnedAt});
}

/// @nodoc
class _$BadgeSummaryCopyWithImpl<$Res, $Val extends BadgeSummary>
    implements $BadgeSummaryCopyWith<$Res> {
  _$BadgeSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = null,
    Object? category = null,
    Object? earnedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: null == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      earnedAt: null == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BadgeSummaryImplCopyWith<$Res>
    implements $BadgeSummaryCopyWith<$Res> {
  factory _$$BadgeSummaryImplCopyWith(
          _$BadgeSummaryImpl value, $Res Function(_$BadgeSummaryImpl) then) =
      __$$BadgeSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String iconUrl,
      String category,
      DateTime earnedAt});
}

/// @nodoc
class __$$BadgeSummaryImplCopyWithImpl<$Res>
    extends _$BadgeSummaryCopyWithImpl<$Res, _$BadgeSummaryImpl>
    implements _$$BadgeSummaryImplCopyWith<$Res> {
  __$$BadgeSummaryImplCopyWithImpl(
      _$BadgeSummaryImpl _value, $Res Function(_$BadgeSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconUrl = null,
    Object? category = null,
    Object? earnedAt = null,
  }) {
    return _then(_$BadgeSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: null == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      earnedAt: null == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeSummaryImpl implements _BadgeSummary {
  const _$BadgeSummaryImpl(
      {required this.id,
      required this.name,
      required this.iconUrl,
      required this.category,
      required this.earnedAt});

  factory _$BadgeSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String iconUrl;
  @override
  final String category;
  @override
  final DateTime earnedAt;

  @override
  String toString() {
    return 'BadgeSummary(id: $id, name: $name, iconUrl: $iconUrl, category: $category, earnedAt: $earnedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, iconUrl, category, earnedAt);

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeSummaryImplCopyWith<_$BadgeSummaryImpl> get copyWith =>
      __$$BadgeSummaryImplCopyWithImpl<_$BadgeSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeSummaryImplToJson(
      this,
    );
  }
}

abstract class _BadgeSummary implements BadgeSummary {
  const factory _BadgeSummary(
      {required final String id,
      required final String name,
      required final String iconUrl,
      required final String category,
      required final DateTime earnedAt}) = _$BadgeSummaryImpl;

  factory _BadgeSummary.fromJson(Map<String, dynamic> json) =
      _$BadgeSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get iconUrl;
  @override
  String get category;
  @override
  DateTime get earnedAt;

  /// Create a copy of BadgeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeSummaryImplCopyWith<_$BadgeSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HighlightSummary _$HighlightSummaryFromJson(Map<String, dynamic> json) {
  return _HighlightSummary.fromJson(json);
}

/// @nodoc
mixin _$HighlightSummary {
  String get id => throw _privateConstructorUsedError;
  String get quoteText => throw _privateConstructorUsedError;
  String? get bookTitle => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HighlightSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HighlightSummaryCopyWith<HighlightSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightSummaryCopyWith<$Res> {
  factory $HighlightSummaryCopyWith(
          HighlightSummary value, $Res Function(HighlightSummary) then) =
      _$HighlightSummaryCopyWithImpl<$Res, HighlightSummary>;
  @useResult
  $Res call(
      {String id, String quoteText, String? bookTitle, DateTime createdAt});
}

/// @nodoc
class _$HighlightSummaryCopyWithImpl<$Res, $Val extends HighlightSummary>
    implements $HighlightSummaryCopyWith<$Res> {
  _$HighlightSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteText = null,
    Object? bookTitle = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _value.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _value.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HighlightSummaryImplCopyWith<$Res>
    implements $HighlightSummaryCopyWith<$Res> {
  factory _$$HighlightSummaryImplCopyWith(_$HighlightSummaryImpl value,
          $Res Function(_$HighlightSummaryImpl) then) =
      __$$HighlightSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String quoteText, String? bookTitle, DateTime createdAt});
}

/// @nodoc
class __$$HighlightSummaryImplCopyWithImpl<$Res>
    extends _$HighlightSummaryCopyWithImpl<$Res, _$HighlightSummaryImpl>
    implements _$$HighlightSummaryImplCopyWith<$Res> {
  __$$HighlightSummaryImplCopyWithImpl(_$HighlightSummaryImpl _value,
      $Res Function(_$HighlightSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteText = null,
    Object? bookTitle = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$HighlightSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _value.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _value.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HighlightSummaryImpl implements _HighlightSummary {
  const _$HighlightSummaryImpl(
      {required this.id,
      required this.quoteText,
      this.bookTitle,
      required this.createdAt});

  factory _$HighlightSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$HighlightSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String quoteText;
  @override
  final String? bookTitle;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'HighlightSummary(id: $id, quoteText: $quoteText, bookTitle: $bookTitle, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quoteText, bookTitle, createdAt);

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightSummaryImplCopyWith<_$HighlightSummaryImpl> get copyWith =>
      __$$HighlightSummaryImplCopyWithImpl<_$HighlightSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HighlightSummaryImplToJson(
      this,
    );
  }
}

abstract class _HighlightSummary implements HighlightSummary {
  const factory _HighlightSummary(
      {required final String id,
      required final String quoteText,
      final String? bookTitle,
      required final DateTime createdAt}) = _$HighlightSummaryImpl;

  factory _HighlightSummary.fromJson(Map<String, dynamic> json) =
      _$HighlightSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get quoteText;
  @override
  String? get bookTitle;
  @override
  DateTime get createdAt;

  /// Create a copy of HighlightSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightSummaryImplCopyWith<_$HighlightSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) {
  return _UserSummary.fromJson(json);
}

/// @nodoc
mixin _$UserSummary {
  String get id => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;

  /// Serializes this UserSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSummaryCopyWith<UserSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSummaryCopyWith<$Res> {
  factory $UserSummaryCopyWith(
          UserSummary value, $Res Function(UserSummary) then) =
      _$UserSummaryCopyWithImpl<$Res, UserSummary>;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? profileImageUrl,
      String? bio,
      bool isFollowing});
}

/// @nodoc
class _$UserSummaryCopyWithImpl<$Res, $Val extends UserSummary>
    implements $UserSummaryCopyWith<$Res> {
  _$UserSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? isFollowing = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSummaryImplCopyWith<$Res>
    implements $UserSummaryCopyWith<$Res> {
  factory _$$UserSummaryImplCopyWith(
          _$UserSummaryImpl value, $Res Function(_$UserSummaryImpl) then) =
      __$$UserSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? profileImageUrl,
      String? bio,
      bool isFollowing});
}

/// @nodoc
class __$$UserSummaryImplCopyWithImpl<$Res>
    extends _$UserSummaryCopyWithImpl<$Res, _$UserSummaryImpl>
    implements _$$UserSummaryImplCopyWith<$Res> {
  __$$UserSummaryImplCopyWithImpl(
      _$UserSummaryImpl _value, $Res Function(_$UserSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? isFollowing = null,
  }) {
    return _then(_$UserSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSummaryImpl implements _UserSummary {
  const _$UserSummaryImpl(
      {required this.id,
      required this.nickname,
      this.profileImageUrl,
      this.bio,
      required this.isFollowing});

  factory _$UserSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;
  @override
  final String? bio;
  @override
  final bool isFollowing;

  @override
  String toString() {
    return 'UserSummary(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl, bio: $bio, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nickname, profileImageUrl, bio, isFollowing);

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSummaryImplCopyWith<_$UserSummaryImpl> get copyWith =>
      __$$UserSummaryImplCopyWithImpl<_$UserSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSummaryImplToJson(
      this,
    );
  }
}

abstract class _UserSummary implements UserSummary {
  const factory _UserSummary(
      {required final String id,
      required final String nickname,
      final String? profileImageUrl,
      final String? bio,
      required final bool isFollowing}) = _$UserSummaryImpl;

  factory _UserSummary.fromJson(Map<String, dynamic> json) =
      _$UserSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get nickname;
  @override
  String? get profileImageUrl;
  @override
  String? get bio;
  @override
  bool get isFollowing;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSummaryImplCopyWith<_$UserSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSummaryPage _$UserSummaryPageFromJson(Map<String, dynamic> json) {
  return _UserSummaryPage.fromJson(json);
}

/// @nodoc
mixin _$UserSummaryPage {
  List<UserSummary> get items => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this UserSummaryPage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSummaryPageCopyWith<UserSummaryPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSummaryPageCopyWith<$Res> {
  factory $UserSummaryPageCopyWith(
          UserSummaryPage value, $Res Function(UserSummaryPage) then) =
      _$UserSummaryPageCopyWithImpl<$Res, UserSummaryPage>;
  @useResult
  $Res call({List<UserSummary> items, String? nextCursor});
}

/// @nodoc
class _$UserSummaryPageCopyWithImpl<$Res, $Val extends UserSummaryPage>
    implements $UserSummaryPageCopyWith<$Res> {
  _$UserSummaryPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserSummary>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSummaryPageImplCopyWith<$Res>
    implements $UserSummaryPageCopyWith<$Res> {
  factory _$$UserSummaryPageImplCopyWith(_$UserSummaryPageImpl value,
          $Res Function(_$UserSummaryPageImpl) then) =
      __$$UserSummaryPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserSummary> items, String? nextCursor});
}

/// @nodoc
class __$$UserSummaryPageImplCopyWithImpl<$Res>
    extends _$UserSummaryPageCopyWithImpl<$Res, _$UserSummaryPageImpl>
    implements _$$UserSummaryPageImplCopyWith<$Res> {
  __$$UserSummaryPageImplCopyWithImpl(
      _$UserSummaryPageImpl _value, $Res Function(_$UserSummaryPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$UserSummaryPageImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserSummary>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSummaryPageImpl implements _UserSummaryPage {
  const _$UserSummaryPageImpl(
      {required final List<UserSummary> items, this.nextCursor})
      : _items = items;

  factory _$UserSummaryPageImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSummaryPageImplFromJson(json);

  final List<UserSummary> _items;
  @override
  List<UserSummary> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'UserSummaryPage(items: $items, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSummaryPageImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSummaryPageImplCopyWith<_$UserSummaryPageImpl> get copyWith =>
      __$$UserSummaryPageImplCopyWithImpl<_$UserSummaryPageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSummaryPageImplToJson(
      this,
    );
  }
}

abstract class _UserSummaryPage implements UserSummaryPage {
  const factory _UserSummaryPage(
      {required final List<UserSummary> items,
      final String? nextCursor}) = _$UserSummaryPageImpl;

  factory _UserSummaryPage.fromJson(Map<String, dynamic> json) =
      _$UserSummaryPageImpl.fromJson;

  @override
  List<UserSummary> get items;
  @override
  String? get nextCursor;

  /// Create a copy of UserSummaryPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSummaryPageImplCopyWith<_$UserSummaryPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;
  bool get isMe => throw _privateConstructorUsedError;
  GradeStats? get gradeStats => throw _privateConstructorUsedError;
  List<BadgeSummary> get badges => throw _privateConstructorUsedError;
  List<HighlightSummary> get recentHighlights =>
      throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? profileImageUrl,
      String? bio,
      int followerCount,
      int followingCount,
      bool isFollowing,
      bool isMe,
      GradeStats? gradeStats,
      List<BadgeSummary> badges,
      List<HighlightSummary> recentHighlights});

  $GradeStatsCopyWith<$Res>? get gradeStats;
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? isFollowing = null,
    Object? isMe = null,
    Object? gradeStats = freezed,
    Object? badges = null,
    Object? recentHighlights = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      gradeStats: freezed == gradeStats
          ? _value.gradeStats
          : gradeStats // ignore: cast_nullable_to_non_nullable
              as GradeStats?,
      badges: null == badges
          ? _value.badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<BadgeSummary>,
      recentHighlights: null == recentHighlights
          ? _value.recentHighlights
          : recentHighlights // ignore: cast_nullable_to_non_nullable
              as List<HighlightSummary>,
    ) as $Val);
  }

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeStatsCopyWith<$Res>? get gradeStats {
    if (_value.gradeStats == null) {
      return null;
    }

    return $GradeStatsCopyWith<$Res>(_value.gradeStats!, (value) {
      return _then(_value.copyWith(gradeStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String? profileImageUrl,
      String? bio,
      int followerCount,
      int followingCount,
      bool isFollowing,
      bool isMe,
      GradeStats? gradeStats,
      List<BadgeSummary> badges,
      List<HighlightSummary> recentHighlights});

  @override
  $GradeStatsCopyWith<$Res>? get gradeStats;
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? isFollowing = null,
    Object? isMe = null,
    Object? gradeStats = freezed,
    Object? badges = null,
    Object? recentHighlights = null,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      gradeStats: freezed == gradeStats
          ? _value.gradeStats
          : gradeStats // ignore: cast_nullable_to_non_nullable
              as GradeStats?,
      badges: null == badges
          ? _value._badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<BadgeSummary>,
      recentHighlights: null == recentHighlights
          ? _value._recentHighlights
          : recentHighlights // ignore: cast_nullable_to_non_nullable
              as List<HighlightSummary>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.nickname,
      this.profileImageUrl,
      this.bio,
      required this.followerCount,
      required this.followingCount,
      required this.isFollowing,
      required this.isMe,
      this.gradeStats,
      final List<BadgeSummary> badges = const [],
      final List<HighlightSummary> recentHighlights = const []})
      : _badges = badges,
        _recentHighlights = recentHighlights;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;
  @override
  final String? bio;
  @override
  final int followerCount;
  @override
  final int followingCount;
  @override
  final bool isFollowing;
  @override
  final bool isMe;
  @override
  final GradeStats? gradeStats;
  final List<BadgeSummary> _badges;
  @override
  @JsonKey()
  List<BadgeSummary> get badges {
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_badges);
  }

  final List<HighlightSummary> _recentHighlights;
  @override
  @JsonKey()
  List<HighlightSummary> get recentHighlights {
    if (_recentHighlights is EqualUnmodifiableListView)
      return _recentHighlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentHighlights);
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl, bio: $bio, followerCount: $followerCount, followingCount: $followingCount, isFollowing: $isFollowing, isMe: $isMe, gradeStats: $gradeStats, badges: $badges, recentHighlights: $recentHighlights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.gradeStats, gradeStats) ||
                other.gradeStats == gradeStats) &&
            const DeepCollectionEquality().equals(other._badges, _badges) &&
            const DeepCollectionEquality()
                .equals(other._recentHighlights, _recentHighlights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nickname,
      profileImageUrl,
      bio,
      followerCount,
      followingCount,
      isFollowing,
      isMe,
      gradeStats,
      const DeepCollectionEquality().hash(_badges),
      const DeepCollectionEquality().hash(_recentHighlights));

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String nickname,
      final String? profileImageUrl,
      final String? bio,
      required final int followerCount,
      required final int followingCount,
      required final bool isFollowing,
      required final bool isMe,
      final GradeStats? gradeStats,
      final List<BadgeSummary> badges,
      final List<HighlightSummary> recentHighlights}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get nickname;
  @override
  String? get profileImageUrl;
  @override
  String? get bio;
  @override
  int get followerCount;
  @override
  int get followingCount;
  @override
  bool get isFollowing;
  @override
  bool get isMe;
  @override
  GradeStats? get gradeStats;
  @override
  List<BadgeSummary> get badges;
  @override
  List<HighlightSummary> get recentHighlights;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
