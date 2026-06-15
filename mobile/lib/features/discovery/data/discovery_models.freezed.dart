// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecommendedBookDto {
  BookDto get book;
  double get score;
  String get reason;
  String get strategy;

  /// Create a copy of RecommendedBookDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecommendedBookDtoCopyWith<RecommendedBookDto> get copyWith =>
      _$RecommendedBookDtoCopyWithImpl<RecommendedBookDto>(
          this as RecommendedBookDto, _$identity);

  /// Serializes this RecommendedBookDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecommendedBookDto &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, book, score, reason, strategy);

  @override
  String toString() {
    return 'RecommendedBookDto(book: $book, score: $score, reason: $reason, strategy: $strategy)';
  }
}

/// @nodoc
abstract mixin class $RecommendedBookDtoCopyWith<$Res> {
  factory $RecommendedBookDtoCopyWith(
          RecommendedBookDto value, $Res Function(RecommendedBookDto) _then) =
      _$RecommendedBookDtoCopyWithImpl;
  @useResult
  $Res call({BookDto book, double score, String reason, String strategy});

  $BookDtoCopyWith<$Res> get book;
}

/// @nodoc
class _$RecommendedBookDtoCopyWithImpl<$Res>
    implements $RecommendedBookDtoCopyWith<$Res> {
  _$RecommendedBookDtoCopyWithImpl(this._self, this._then);

  final RecommendedBookDto _self;
  final $Res Function(RecommendedBookDto) _then;

  /// Create a copy of RecommendedBookDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? book = null,
    Object? score = null,
    Object? reason = null,
    Object? strategy = null,
  }) {
    return _then(_self.copyWith(
      book: null == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as BookDto,
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      strategy: null == strategy
          ? _self.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of RecommendedBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookDtoCopyWith<$Res> get book {
    return $BookDtoCopyWith<$Res>(_self.book, (value) {
      return _then(_self.copyWith(book: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RecommendedBookDto].
extension RecommendedBookDtoPatterns on RecommendedBookDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecommendedBookDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecommendedBookDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecommendedBookDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecommendedBookDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecommendedBookDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecommendedBookDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            BookDto book, double score, String reason, String strategy)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecommendedBookDto() when $default != null:
        return $default(_that.book, _that.score, _that.reason, _that.strategy);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(BookDto book, double score, String reason, String strategy)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecommendedBookDto():
        return $default(_that.book, _that.score, _that.reason, _that.strategy);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            BookDto book, double score, String reason, String strategy)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecommendedBookDto() when $default != null:
        return $default(_that.book, _that.score, _that.reason, _that.strategy);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecommendedBookDto extends RecommendedBookDto {
  const _RecommendedBookDto(
      {required this.book,
      required this.score,
      required this.reason,
      required this.strategy})
      : super._();
  factory _RecommendedBookDto.fromJson(Map<String, dynamic> json) =>
      _$RecommendedBookDtoFromJson(json);

  @override
  final BookDto book;
  @override
  final double score;
  @override
  final String reason;
  @override
  final String strategy;

  /// Create a copy of RecommendedBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecommendedBookDtoCopyWith<_RecommendedBookDto> get copyWith =>
      __$RecommendedBookDtoCopyWithImpl<_RecommendedBookDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecommendedBookDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecommendedBookDto &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, book, score, reason, strategy);

  @override
  String toString() {
    return 'RecommendedBookDto(book: $book, score: $score, reason: $reason, strategy: $strategy)';
  }
}

/// @nodoc
abstract mixin class _$RecommendedBookDtoCopyWith<$Res>
    implements $RecommendedBookDtoCopyWith<$Res> {
  factory _$RecommendedBookDtoCopyWith(
          _RecommendedBookDto value, $Res Function(_RecommendedBookDto) _then) =
      __$RecommendedBookDtoCopyWithImpl;
  @override
  @useResult
  $Res call({BookDto book, double score, String reason, String strategy});

  @override
  $BookDtoCopyWith<$Res> get book;
}

/// @nodoc
class __$RecommendedBookDtoCopyWithImpl<$Res>
    implements _$RecommendedBookDtoCopyWith<$Res> {
  __$RecommendedBookDtoCopyWithImpl(this._self, this._then);

  final _RecommendedBookDto _self;
  final $Res Function(_RecommendedBookDto) _then;

  /// Create a copy of RecommendedBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? book = null,
    Object? score = null,
    Object? reason = null,
    Object? strategy = null,
  }) {
    return _then(_RecommendedBookDto(
      book: null == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as BookDto,
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      strategy: null == strategy
          ? _self.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of RecommendedBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookDtoCopyWith<$Res> get book {
    return $BookDtoCopyWith<$Res>(_self.book, (value) {
      return _then(_self.copyWith(book: value));
    });
  }
}

/// @nodoc
mixin _$OnboardingInterestDto {
  String get category;
  String get value;

  /// Create a copy of OnboardingInterestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OnboardingInterestDtoCopyWith<OnboardingInterestDto> get copyWith =>
      _$OnboardingInterestDtoCopyWithImpl<OnboardingInterestDto>(
          this as OnboardingInterestDto, _$identity);

  /// Serializes this OnboardingInterestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnboardingInterestDto &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, value);

  @override
  String toString() {
    return 'OnboardingInterestDto(category: $category, value: $value)';
  }
}

/// @nodoc
abstract mixin class $OnboardingInterestDtoCopyWith<$Res> {
  factory $OnboardingInterestDtoCopyWith(OnboardingInterestDto value,
          $Res Function(OnboardingInterestDto) _then) =
      _$OnboardingInterestDtoCopyWithImpl;
  @useResult
  $Res call({String category, String value});
}

/// @nodoc
class _$OnboardingInterestDtoCopyWithImpl<$Res>
    implements $OnboardingInterestDtoCopyWith<$Res> {
  _$OnboardingInterestDtoCopyWithImpl(this._self, this._then);

  final OnboardingInterestDto _self;
  final $Res Function(OnboardingInterestDto) _then;

  /// Create a copy of OnboardingInterestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? value = null,
  }) {
    return _then(_self.copyWith(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [OnboardingInterestDto].
extension OnboardingInterestDtoPatterns on OnboardingInterestDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OnboardingInterestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingInterestDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OnboardingInterestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingInterestDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OnboardingInterestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingInterestDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String category, String value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingInterestDto() when $default != null:
        return $default(_that.category, _that.value);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String category, String value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingInterestDto():
        return $default(_that.category, _that.value);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String category, String value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingInterestDto() when $default != null:
        return $default(_that.category, _that.value);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OnboardingInterestDto implements OnboardingInterestDto {
  const _OnboardingInterestDto({required this.category, required this.value});
  factory _OnboardingInterestDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingInterestDtoFromJson(json);

  @override
  final String category;
  @override
  final String value;

  /// Create a copy of OnboardingInterestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OnboardingInterestDtoCopyWith<_OnboardingInterestDto> get copyWith =>
      __$OnboardingInterestDtoCopyWithImpl<_OnboardingInterestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OnboardingInterestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OnboardingInterestDto &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, value);

  @override
  String toString() {
    return 'OnboardingInterestDto(category: $category, value: $value)';
  }
}

/// @nodoc
abstract mixin class _$OnboardingInterestDtoCopyWith<$Res>
    implements $OnboardingInterestDtoCopyWith<$Res> {
  factory _$OnboardingInterestDtoCopyWith(_OnboardingInterestDto value,
          $Res Function(_OnboardingInterestDto) _then) =
      __$OnboardingInterestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String category, String value});
}

/// @nodoc
class __$OnboardingInterestDtoCopyWithImpl<$Res>
    implements _$OnboardingInterestDtoCopyWith<$Res> {
  __$OnboardingInterestDtoCopyWithImpl(this._self, this._then);

  final _OnboardingInterestDto _self;
  final $Res Function(_OnboardingInterestDto) _then;

  /// Create a copy of OnboardingInterestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = null,
    Object? value = null,
  }) {
    return _then(_OnboardingInterestDto(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
