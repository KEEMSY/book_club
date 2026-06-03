// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highlight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Highlight {
  String get id;
  String get userBookId;
  String get quoteText;
  int? get pageNumber;
  String? get noteText;
  DateTime get createdAt;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightCopyWith<Highlight> get copyWith =>
      _$HighlightCopyWithImpl<Highlight>(this as Highlight, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Highlight &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.noteText, noteText) ||
                other.noteText == noteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, quoteText, pageNumber, noteText, createdAt);

  @override
  String toString() {
    return 'Highlight(id: $id, userBookId: $userBookId, quoteText: $quoteText, pageNumber: $pageNumber, noteText: $noteText, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $HighlightCopyWith<$Res> {
  factory $HighlightCopyWith(Highlight value, $Res Function(Highlight) _then) =
      _$HighlightCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userBookId,
      String quoteText,
      int? pageNumber,
      String? noteText,
      DateTime createdAt});
}

/// @nodoc
class _$HighlightCopyWithImpl<$Res> implements $HighlightCopyWith<$Res> {
  _$HighlightCopyWithImpl(this._self, this._then);

  final Highlight _self;
  final $Res Function(Highlight) _then;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? quoteText = null,
    Object? pageNumber = freezed,
    Object? noteText = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: freezed == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      noteText: freezed == noteText
          ? _self.noteText
          : noteText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Highlight].
extension HighlightPatterns on Highlight {
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
    TResult Function(_Highlight value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Highlight() when $default != null:
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
    TResult Function(_Highlight value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Highlight():
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
    TResult? Function(_Highlight value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Highlight() when $default != null:
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
    TResult Function(String id, String userBookId, String quoteText,
            int? pageNumber, String? noteText, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Highlight() when $default != null:
        return $default(_that.id, _that.userBookId, _that.quoteText,
            _that.pageNumber, _that.noteText, _that.createdAt);
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
    TResult Function(String id, String userBookId, String quoteText,
            int? pageNumber, String? noteText, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Highlight():
        return $default(_that.id, _that.userBookId, _that.quoteText,
            _that.pageNumber, _that.noteText, _that.createdAt);
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
    TResult? Function(String id, String userBookId, String quoteText,
            int? pageNumber, String? noteText, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Highlight() when $default != null:
        return $default(_that.id, _that.userBookId, _that.quoteText,
            _that.pageNumber, _that.noteText, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Highlight implements Highlight {
  const _Highlight(
      {required this.id,
      required this.userBookId,
      required this.quoteText,
      this.pageNumber,
      this.noteText,
      required this.createdAt});

  @override
  final String id;
  @override
  final String userBookId;
  @override
  final String quoteText;
  @override
  final int? pageNumber;
  @override
  final String? noteText;
  @override
  final DateTime createdAt;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HighlightCopyWith<_Highlight> get copyWith =>
      __$HighlightCopyWithImpl<_Highlight>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Highlight &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.noteText, noteText) ||
                other.noteText == noteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, quoteText, pageNumber, noteText, createdAt);

  @override
  String toString() {
    return 'Highlight(id: $id, userBookId: $userBookId, quoteText: $quoteText, pageNumber: $pageNumber, noteText: $noteText, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$HighlightCopyWith<$Res>
    implements $HighlightCopyWith<$Res> {
  factory _$HighlightCopyWith(
          _Highlight value, $Res Function(_Highlight) _then) =
      __$HighlightCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userBookId,
      String quoteText,
      int? pageNumber,
      String? noteText,
      DateTime createdAt});
}

/// @nodoc
class __$HighlightCopyWithImpl<$Res> implements _$HighlightCopyWith<$Res> {
  __$HighlightCopyWithImpl(this._self, this._then);

  final _Highlight _self;
  final $Res Function(_Highlight) _then;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? quoteText = null,
    Object? pageNumber = freezed,
    Object? noteText = freezed,
    Object? createdAt = null,
  }) {
    return _then(_Highlight(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: freezed == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      noteText: freezed == noteText
          ? _self.noteText
          : noteText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$HighlightPage {
  List<Highlight> get items;
  String? get nextCursor;

  /// Create a copy of HighlightPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightPageCopyWith<HighlightPage> get copyWith =>
      _$HighlightPageCopyWithImpl<HighlightPage>(
          this as HighlightPage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightPage &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), nextCursor);

  @override
  String toString() {
    return 'HighlightPage(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $HighlightPageCopyWith<$Res> {
  factory $HighlightPageCopyWith(
          HighlightPage value, $Res Function(HighlightPage) _then) =
      _$HighlightPageCopyWithImpl;
  @useResult
  $Res call({List<Highlight> items, String? nextCursor});
}

/// @nodoc
class _$HighlightPageCopyWithImpl<$Res>
    implements $HighlightPageCopyWith<$Res> {
  _$HighlightPageCopyWithImpl(this._self, this._then);

  final HighlightPage _self;
  final $Res Function(HighlightPage) _then;

  /// Create a copy of HighlightPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HighlightPage].
extension HighlightPagePatterns on HighlightPage {
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
    TResult Function(_HighlightPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightPage() when $default != null:
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
    TResult Function(_HighlightPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightPage():
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
    TResult? Function(_HighlightPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightPage() when $default != null:
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
    TResult Function(List<Highlight> items, String? nextCursor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightPage() when $default != null:
        return $default(_that.items, _that.nextCursor);
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
    TResult Function(List<Highlight> items, String? nextCursor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightPage():
        return $default(_that.items, _that.nextCursor);
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
    TResult? Function(List<Highlight> items, String? nextCursor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightPage() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HighlightPage implements HighlightPage {
  const _HighlightPage({required final List<Highlight> items, this.nextCursor})
      : _items = items;

  final List<Highlight> _items;
  @override
  List<Highlight> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  /// Create a copy of HighlightPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HighlightPageCopyWith<_HighlightPage> get copyWith =>
      __$HighlightPageCopyWithImpl<_HighlightPage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HighlightPage &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  @override
  String toString() {
    return 'HighlightPage(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$HighlightPageCopyWith<$Res>
    implements $HighlightPageCopyWith<$Res> {
  factory _$HighlightPageCopyWith(
          _HighlightPage value, $Res Function(_HighlightPage) _then) =
      __$HighlightPageCopyWithImpl;
  @override
  @useResult
  $Res call({List<Highlight> items, String? nextCursor});
}

/// @nodoc
class __$HighlightPageCopyWithImpl<$Res>
    implements _$HighlightPageCopyWith<$Res> {
  __$HighlightPageCopyWithImpl(this._self, this._then);

  final _HighlightPage _self;
  final $Res Function(_HighlightPage) _then;

  /// Create a copy of HighlightPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_HighlightPage(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
