// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiPrepCard {
  String get authorIntro;
  List<String> get themeKeywords;
  List<String> get prereadingQuestions;

  /// Create a copy of AiPrepCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AiPrepCardCopyWith<AiPrepCard> get copyWith =>
      _$AiPrepCardCopyWithImpl<AiPrepCard>(this as AiPrepCard, _$identity);

  /// Serializes this AiPrepCard to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AiPrepCard &&
            (identical(other.authorIntro, authorIntro) ||
                other.authorIntro == authorIntro) &&
            const DeepCollectionEquality()
                .equals(other.themeKeywords, themeKeywords) &&
            const DeepCollectionEquality()
                .equals(other.prereadingQuestions, prereadingQuestions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      authorIntro,
      const DeepCollectionEquality().hash(themeKeywords),
      const DeepCollectionEquality().hash(prereadingQuestions));

  @override
  String toString() {
    return 'AiPrepCard(authorIntro: $authorIntro, themeKeywords: $themeKeywords, prereadingQuestions: $prereadingQuestions)';
  }
}

/// @nodoc
abstract mixin class $AiPrepCardCopyWith<$Res> {
  factory $AiPrepCardCopyWith(
          AiPrepCard value, $Res Function(AiPrepCard) _then) =
      _$AiPrepCardCopyWithImpl;
  @useResult
  $Res call(
      {String authorIntro,
      List<String> themeKeywords,
      List<String> prereadingQuestions});
}

/// @nodoc
class _$AiPrepCardCopyWithImpl<$Res> implements $AiPrepCardCopyWith<$Res> {
  _$AiPrepCardCopyWithImpl(this._self, this._then);

  final AiPrepCard _self;
  final $Res Function(AiPrepCard) _then;

  /// Create a copy of AiPrepCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorIntro = null,
    Object? themeKeywords = null,
    Object? prereadingQuestions = null,
  }) {
    return _then(_self.copyWith(
      authorIntro: null == authorIntro
          ? _self.authorIntro
          : authorIntro // ignore: cast_nullable_to_non_nullable
              as String,
      themeKeywords: null == themeKeywords
          ? _self.themeKeywords
          : themeKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      prereadingQuestions: null == prereadingQuestions
          ? _self.prereadingQuestions
          : prereadingQuestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AiPrepCard].
extension AiPrepCardPatterns on AiPrepCard {
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
    TResult Function(_AiPrepCard value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AiPrepCard() when $default != null:
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
    TResult Function(_AiPrepCard value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiPrepCard():
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
    TResult? Function(_AiPrepCard value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiPrepCard() when $default != null:
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
    TResult Function(String authorIntro, List<String> themeKeywords,
            List<String> prereadingQuestions)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AiPrepCard() when $default != null:
        return $default(
            _that.authorIntro, _that.themeKeywords, _that.prereadingQuestions);
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
    TResult Function(String authorIntro, List<String> themeKeywords,
            List<String> prereadingQuestions)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiPrepCard():
        return $default(
            _that.authorIntro, _that.themeKeywords, _that.prereadingQuestions);
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
    TResult? Function(String authorIntro, List<String> themeKeywords,
            List<String> prereadingQuestions)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiPrepCard() when $default != null:
        return $default(
            _that.authorIntro, _that.themeKeywords, _that.prereadingQuestions);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AiPrepCard implements AiPrepCard {
  const _AiPrepCard(
      {required this.authorIntro,
      required final List<String> themeKeywords,
      required final List<String> prereadingQuestions})
      : _themeKeywords = themeKeywords,
        _prereadingQuestions = prereadingQuestions;
  factory _AiPrepCard.fromJson(Map<String, dynamic> json) =>
      _$AiPrepCardFromJson(json);

  @override
  final String authorIntro;
  final List<String> _themeKeywords;
  @override
  List<String> get themeKeywords {
    if (_themeKeywords is EqualUnmodifiableListView) return _themeKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_themeKeywords);
  }

  final List<String> _prereadingQuestions;
  @override
  List<String> get prereadingQuestions {
    if (_prereadingQuestions is EqualUnmodifiableListView)
      return _prereadingQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prereadingQuestions);
  }

  /// Create a copy of AiPrepCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AiPrepCardCopyWith<_AiPrepCard> get copyWith =>
      __$AiPrepCardCopyWithImpl<_AiPrepCard>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AiPrepCardToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AiPrepCard &&
            (identical(other.authorIntro, authorIntro) ||
                other.authorIntro == authorIntro) &&
            const DeepCollectionEquality()
                .equals(other._themeKeywords, _themeKeywords) &&
            const DeepCollectionEquality()
                .equals(other._prereadingQuestions, _prereadingQuestions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      authorIntro,
      const DeepCollectionEquality().hash(_themeKeywords),
      const DeepCollectionEquality().hash(_prereadingQuestions));

  @override
  String toString() {
    return 'AiPrepCard(authorIntro: $authorIntro, themeKeywords: $themeKeywords, prereadingQuestions: $prereadingQuestions)';
  }
}

/// @nodoc
abstract mixin class _$AiPrepCardCopyWith<$Res>
    implements $AiPrepCardCopyWith<$Res> {
  factory _$AiPrepCardCopyWith(
          _AiPrepCard value, $Res Function(_AiPrepCard) _then) =
      __$AiPrepCardCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String authorIntro,
      List<String> themeKeywords,
      List<String> prereadingQuestions});
}

/// @nodoc
class __$AiPrepCardCopyWithImpl<$Res> implements _$AiPrepCardCopyWith<$Res> {
  __$AiPrepCardCopyWithImpl(this._self, this._then);

  final _AiPrepCard _self;
  final $Res Function(_AiPrepCard) _then;

  /// Create a copy of AiPrepCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? authorIntro = null,
    Object? themeKeywords = null,
    Object? prereadingQuestions = null,
  }) {
    return _then(_AiPrepCard(
      authorIntro: null == authorIntro
          ? _self.authorIntro
          : authorIntro // ignore: cast_nullable_to_non_nullable
              as String,
      themeKeywords: null == themeKeywords
          ? _self._themeKeywords
          : themeKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      prereadingQuestions: null == prereadingQuestions
          ? _self._prereadingQuestions
          : prereadingQuestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
mixin _$AiNextBook {
  String get title;
  String get reason;

  /// Create a copy of AiNextBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AiNextBookCopyWith<AiNextBook> get copyWith =>
      _$AiNextBookCopyWithImpl<AiNextBook>(this as AiNextBook, _$identity);

  /// Serializes this AiNextBook to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AiNextBook &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, reason);

  @override
  String toString() {
    return 'AiNextBook(title: $title, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $AiNextBookCopyWith<$Res> {
  factory $AiNextBookCopyWith(
          AiNextBook value, $Res Function(AiNextBook) _then) =
      _$AiNextBookCopyWithImpl;
  @useResult
  $Res call({String title, String reason});
}

/// @nodoc
class _$AiNextBookCopyWithImpl<$Res> implements $AiNextBookCopyWith<$Res> {
  _$AiNextBookCopyWithImpl(this._self, this._then);

  final AiNextBook _self;
  final $Res Function(AiNextBook) _then;

  /// Create a copy of AiNextBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? reason = null,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AiNextBook].
extension AiNextBookPatterns on AiNextBook {
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
    TResult Function(_AiNextBook value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AiNextBook() when $default != null:
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
    TResult Function(_AiNextBook value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiNextBook():
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
    TResult? Function(_AiNextBook value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiNextBook() when $default != null:
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
    TResult Function(String title, String reason)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AiNextBook() when $default != null:
        return $default(_that.title, _that.reason);
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
    TResult Function(String title, String reason) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiNextBook():
        return $default(_that.title, _that.reason);
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
    TResult? Function(String title, String reason)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiNextBook() when $default != null:
        return $default(_that.title, _that.reason);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AiNextBook implements AiNextBook {
  const _AiNextBook({required this.title, required this.reason});
  factory _AiNextBook.fromJson(Map<String, dynamic> json) =>
      _$AiNextBookFromJson(json);

  @override
  final String title;
  @override
  final String reason;

  /// Create a copy of AiNextBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AiNextBookCopyWith<_AiNextBook> get copyWith =>
      __$AiNextBookCopyWithImpl<_AiNextBook>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AiNextBookToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AiNextBook &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, reason);

  @override
  String toString() {
    return 'AiNextBook(title: $title, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class _$AiNextBookCopyWith<$Res>
    implements $AiNextBookCopyWith<$Res> {
  factory _$AiNextBookCopyWith(
          _AiNextBook value, $Res Function(_AiNextBook) _then) =
      __$AiNextBookCopyWithImpl;
  @override
  @useResult
  $Res call({String title, String reason});
}

/// @nodoc
class __$AiNextBookCopyWithImpl<$Res> implements _$AiNextBookCopyWith<$Res> {
  __$AiNextBookCopyWithImpl(this._self, this._then);

  final _AiNextBook _self;
  final $Res Function(_AiNextBook) _then;

  /// Create a copy of AiNextBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? reason = null,
  }) {
    return _then(_AiNextBook(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$AiReflection {
  List<String> get insights;
  String get actionPoint;
  List<AiNextBook> get nextBooks;

  /// Create a copy of AiReflection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AiReflectionCopyWith<AiReflection> get copyWith =>
      _$AiReflectionCopyWithImpl<AiReflection>(
          this as AiReflection, _$identity);

  /// Serializes this AiReflection to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AiReflection &&
            const DeepCollectionEquality().equals(other.insights, insights) &&
            (identical(other.actionPoint, actionPoint) ||
                other.actionPoint == actionPoint) &&
            const DeepCollectionEquality().equals(other.nextBooks, nextBooks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(insights),
      actionPoint,
      const DeepCollectionEquality().hash(nextBooks));

  @override
  String toString() {
    return 'AiReflection(insights: $insights, actionPoint: $actionPoint, nextBooks: $nextBooks)';
  }
}

/// @nodoc
abstract mixin class $AiReflectionCopyWith<$Res> {
  factory $AiReflectionCopyWith(
          AiReflection value, $Res Function(AiReflection) _then) =
      _$AiReflectionCopyWithImpl;
  @useResult
  $Res call(
      {List<String> insights, String actionPoint, List<AiNextBook> nextBooks});
}

/// @nodoc
class _$AiReflectionCopyWithImpl<$Res> implements $AiReflectionCopyWith<$Res> {
  _$AiReflectionCopyWithImpl(this._self, this._then);

  final AiReflection _self;
  final $Res Function(AiReflection) _then;

  /// Create a copy of AiReflection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? actionPoint = null,
    Object? nextBooks = null,
  }) {
    return _then(_self.copyWith(
      insights: null == insights
          ? _self.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      actionPoint: null == actionPoint
          ? _self.actionPoint
          : actionPoint // ignore: cast_nullable_to_non_nullable
              as String,
      nextBooks: null == nextBooks
          ? _self.nextBooks
          : nextBooks // ignore: cast_nullable_to_non_nullable
              as List<AiNextBook>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AiReflection].
extension AiReflectionPatterns on AiReflection {
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
    TResult Function(_AiReflection value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AiReflection() when $default != null:
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
    TResult Function(_AiReflection value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiReflection():
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
    TResult? Function(_AiReflection value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiReflection() when $default != null:
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
    TResult Function(List<String> insights, String actionPoint,
            List<AiNextBook> nextBooks)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AiReflection() when $default != null:
        return $default(_that.insights, _that.actionPoint, _that.nextBooks);
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
    TResult Function(List<String> insights, String actionPoint,
            List<AiNextBook> nextBooks)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiReflection():
        return $default(_that.insights, _that.actionPoint, _that.nextBooks);
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
    TResult? Function(List<String> insights, String actionPoint,
            List<AiNextBook> nextBooks)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiReflection() when $default != null:
        return $default(_that.insights, _that.actionPoint, _that.nextBooks);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AiReflection implements AiReflection {
  const _AiReflection(
      {required final List<String> insights,
      required this.actionPoint,
      required final List<AiNextBook> nextBooks})
      : _insights = insights,
        _nextBooks = nextBooks;
  factory _AiReflection.fromJson(Map<String, dynamic> json) =>
      _$AiReflectionFromJson(json);

  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  final String actionPoint;
  final List<AiNextBook> _nextBooks;
  @override
  List<AiNextBook> get nextBooks {
    if (_nextBooks is EqualUnmodifiableListView) return _nextBooks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nextBooks);
  }

  /// Create a copy of AiReflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AiReflectionCopyWith<_AiReflection> get copyWith =>
      __$AiReflectionCopyWithImpl<_AiReflection>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AiReflectionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AiReflection &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.actionPoint, actionPoint) ||
                other.actionPoint == actionPoint) &&
            const DeepCollectionEquality()
                .equals(other._nextBooks, _nextBooks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_insights),
      actionPoint,
      const DeepCollectionEquality().hash(_nextBooks));

  @override
  String toString() {
    return 'AiReflection(insights: $insights, actionPoint: $actionPoint, nextBooks: $nextBooks)';
  }
}

/// @nodoc
abstract mixin class _$AiReflectionCopyWith<$Res>
    implements $AiReflectionCopyWith<$Res> {
  factory _$AiReflectionCopyWith(
          _AiReflection value, $Res Function(_AiReflection) _then) =
      __$AiReflectionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<String> insights, String actionPoint, List<AiNextBook> nextBooks});
}

/// @nodoc
class __$AiReflectionCopyWithImpl<$Res>
    implements _$AiReflectionCopyWith<$Res> {
  __$AiReflectionCopyWithImpl(this._self, this._then);

  final _AiReflection _self;
  final $Res Function(_AiReflection) _then;

  /// Create a copy of AiReflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? insights = null,
    Object? actionPoint = null,
    Object? nextBooks = null,
  }) {
    return _then(_AiReflection(
      insights: null == insights
          ? _self._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      actionPoint: null == actionPoint
          ? _self.actionPoint
          : actionPoint // ignore: cast_nullable_to_non_nullable
              as String,
      nextBooks: null == nextBooks
          ? _self._nextBooks
          : nextBooks // ignore: cast_nullable_to_non_nullable
              as List<AiNextBook>,
    ));
  }
}

/// @nodoc
mixin _$AiUsage {
  int get prepCard;
  int get reflection;
  int get clubTopics;

  /// Create a copy of AiUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AiUsageCopyWith<AiUsage> get copyWith =>
      _$AiUsageCopyWithImpl<AiUsage>(this as AiUsage, _$identity);

  /// Serializes this AiUsage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AiUsage &&
            (identical(other.prepCard, prepCard) ||
                other.prepCard == prepCard) &&
            (identical(other.reflection, reflection) ||
                other.reflection == reflection) &&
            (identical(other.clubTopics, clubTopics) ||
                other.clubTopics == clubTopics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, prepCard, reflection, clubTopics);

  @override
  String toString() {
    return 'AiUsage(prepCard: $prepCard, reflection: $reflection, clubTopics: $clubTopics)';
  }
}

/// @nodoc
abstract mixin class $AiUsageCopyWith<$Res> {
  factory $AiUsageCopyWith(AiUsage value, $Res Function(AiUsage) _then) =
      _$AiUsageCopyWithImpl;
  @useResult
  $Res call({int prepCard, int reflection, int clubTopics});
}

/// @nodoc
class _$AiUsageCopyWithImpl<$Res> implements $AiUsageCopyWith<$Res> {
  _$AiUsageCopyWithImpl(this._self, this._then);

  final AiUsage _self;
  final $Res Function(AiUsage) _then;

  /// Create a copy of AiUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prepCard = null,
    Object? reflection = null,
    Object? clubTopics = null,
  }) {
    return _then(_self.copyWith(
      prepCard: null == prepCard
          ? _self.prepCard
          : prepCard // ignore: cast_nullable_to_non_nullable
              as int,
      reflection: null == reflection
          ? _self.reflection
          : reflection // ignore: cast_nullable_to_non_nullable
              as int,
      clubTopics: null == clubTopics
          ? _self.clubTopics
          : clubTopics // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AiUsage].
extension AiUsagePatterns on AiUsage {
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
    TResult Function(_AiUsage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AiUsage() when $default != null:
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
    TResult Function(_AiUsage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiUsage():
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
    TResult? Function(_AiUsage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiUsage() when $default != null:
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
    TResult Function(int prepCard, int reflection, int clubTopics)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AiUsage() when $default != null:
        return $default(_that.prepCard, _that.reflection, _that.clubTopics);
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
    TResult Function(int prepCard, int reflection, int clubTopics) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiUsage():
        return $default(_that.prepCard, _that.reflection, _that.clubTopics);
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
    TResult? Function(int prepCard, int reflection, int clubTopics)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AiUsage() when $default != null:
        return $default(_that.prepCard, _that.reflection, _that.clubTopics);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AiUsage implements AiUsage {
  const _AiUsage({this.prepCard = 0, this.reflection = 0, this.clubTopics = 0});
  factory _AiUsage.fromJson(Map<String, dynamic> json) =>
      _$AiUsageFromJson(json);

  @override
  @JsonKey()
  final int prepCard;
  @override
  @JsonKey()
  final int reflection;
  @override
  @JsonKey()
  final int clubTopics;

  /// Create a copy of AiUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AiUsageCopyWith<_AiUsage> get copyWith =>
      __$AiUsageCopyWithImpl<_AiUsage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AiUsageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AiUsage &&
            (identical(other.prepCard, prepCard) ||
                other.prepCard == prepCard) &&
            (identical(other.reflection, reflection) ||
                other.reflection == reflection) &&
            (identical(other.clubTopics, clubTopics) ||
                other.clubTopics == clubTopics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, prepCard, reflection, clubTopics);

  @override
  String toString() {
    return 'AiUsage(prepCard: $prepCard, reflection: $reflection, clubTopics: $clubTopics)';
  }
}

/// @nodoc
abstract mixin class _$AiUsageCopyWith<$Res> implements $AiUsageCopyWith<$Res> {
  factory _$AiUsageCopyWith(_AiUsage value, $Res Function(_AiUsage) _then) =
      __$AiUsageCopyWithImpl;
  @override
  @useResult
  $Res call({int prepCard, int reflection, int clubTopics});
}

/// @nodoc
class __$AiUsageCopyWithImpl<$Res> implements _$AiUsageCopyWith<$Res> {
  __$AiUsageCopyWithImpl(this._self, this._then);

  final _AiUsage _self;
  final $Res Function(_AiUsage) _then;

  /// Create a copy of AiUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? prepCard = null,
    Object? reflection = null,
    Object? clubTopics = null,
  }) {
    return _then(_AiUsage(
      prepCard: null == prepCard
          ? _self.prepCard
          : prepCard // ignore: cast_nullable_to_non_nullable
              as int,
      reflection: null == reflection
          ? _self.reflection
          : reflection // ignore: cast_nullable_to_non_nullable
              as int,
      clubTopics: null == clubTopics
          ? _self.clubTopics
          : clubTopics // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
