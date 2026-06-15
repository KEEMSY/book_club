// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curation_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CurationCard {
  String get id;
  String get bookId;
  String get cardType;
  String get title;
  String get body;
  int get orderIndex;

  /// Create a copy of CurationCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CurationCardCopyWith<CurationCard> get copyWith =>
      _$CurationCardCopyWithImpl<CurationCard>(
          this as CurationCard, _$identity);

  /// Serializes this CurationCard to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CurationCard &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, bookId, cardType, title, body, orderIndex);

  @override
  String toString() {
    return 'CurationCard(id: $id, bookId: $bookId, cardType: $cardType, title: $title, body: $body, orderIndex: $orderIndex)';
  }
}

/// @nodoc
abstract mixin class $CurationCardCopyWith<$Res> {
  factory $CurationCardCopyWith(
          CurationCard value, $Res Function(CurationCard) _then) =
      _$CurationCardCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String bookId,
      String cardType,
      String title,
      String body,
      int orderIndex});
}

/// @nodoc
class _$CurationCardCopyWithImpl<$Res> implements $CurationCardCopyWith<$Res> {
  _$CurationCardCopyWithImpl(this._self, this._then);

  final CurationCard _self;
  final $Res Function(CurationCard) _then;

  /// Create a copy of CurationCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? cardType = null,
    Object? title = null,
    Object? body = null,
    Object? orderIndex = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      cardType: null == cardType
          ? _self.cardType
          : cardType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _self.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [CurationCard].
extension CurationCardPatterns on CurationCard {
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
    TResult Function(_CurationCard value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CurationCard() when $default != null:
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
    TResult Function(_CurationCard value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurationCard():
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
    TResult? Function(_CurationCard value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurationCard() when $default != null:
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
    TResult Function(String id, String bookId, String cardType, String title,
            String body, int orderIndex)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CurationCard() when $default != null:
        return $default(_that.id, _that.bookId, _that.cardType, _that.title,
            _that.body, _that.orderIndex);
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
    TResult Function(String id, String bookId, String cardType, String title,
            String body, int orderIndex)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurationCard():
        return $default(_that.id, _that.bookId, _that.cardType, _that.title,
            _that.body, _that.orderIndex);
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
    TResult? Function(String id, String bookId, String cardType, String title,
            String body, int orderIndex)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurationCard() when $default != null:
        return $default(_that.id, _that.bookId, _that.cardType, _that.title,
            _that.body, _that.orderIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CurationCard implements CurationCard {
  const _CurationCard(
      {required this.id,
      required this.bookId,
      required this.cardType,
      required this.title,
      required this.body,
      required this.orderIndex});
  factory _CurationCard.fromJson(Map<String, dynamic> json) =>
      _$CurationCardFromJson(json);

  @override
  final String id;
  @override
  final String bookId;
  @override
  final String cardType;
  @override
  final String title;
  @override
  final String body;
  @override
  final int orderIndex;

  /// Create a copy of CurationCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CurationCardCopyWith<_CurationCard> get copyWith =>
      __$CurationCardCopyWithImpl<_CurationCard>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CurationCardToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CurationCard &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, bookId, cardType, title, body, orderIndex);

  @override
  String toString() {
    return 'CurationCard(id: $id, bookId: $bookId, cardType: $cardType, title: $title, body: $body, orderIndex: $orderIndex)';
  }
}

/// @nodoc
abstract mixin class _$CurationCardCopyWith<$Res>
    implements $CurationCardCopyWith<$Res> {
  factory _$CurationCardCopyWith(
          _CurationCard value, $Res Function(_CurationCard) _then) =
      __$CurationCardCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String bookId,
      String cardType,
      String title,
      String body,
      int orderIndex});
}

/// @nodoc
class __$CurationCardCopyWithImpl<$Res>
    implements _$CurationCardCopyWith<$Res> {
  __$CurationCardCopyWithImpl(this._self, this._then);

  final _CurationCard _self;
  final $Res Function(_CurationCard) _then;

  /// Create a copy of CurationCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? cardType = null,
    Object? title = null,
    Object? body = null,
    Object? orderIndex = null,
  }) {
    return _then(_CurationCard(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      cardType: null == cardType
          ? _self.cardType
          : cardType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _self.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
