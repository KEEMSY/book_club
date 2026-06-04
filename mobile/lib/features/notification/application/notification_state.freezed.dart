// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationState {
  List<NotificationDto> get items;
  String? get nextCursor;
  int get unreadCount;
  bool get isLoading;
  bool get hasMore;
  bool get wsConnected;
  String? get error;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationStateCopyWith<NotificationState> get copyWith =>
      _$NotificationStateCopyWithImpl<NotificationState>(
          this as NotificationState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationState &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.wsConnected, wsConnected) ||
                other.wsConnected == wsConnected) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(items),
      nextCursor,
      unreadCount,
      isLoading,
      hasMore,
      wsConnected,
      error);

  @override
  String toString() {
    return 'NotificationState(items: $items, nextCursor: $nextCursor, unreadCount: $unreadCount, isLoading: $isLoading, hasMore: $hasMore, wsConnected: $wsConnected, error: $error)';
  }
}

/// @nodoc
abstract mixin class $NotificationStateCopyWith<$Res> {
  factory $NotificationStateCopyWith(
          NotificationState value, $Res Function(NotificationState) _then) =
      _$NotificationStateCopyWithImpl;
  @useResult
  $Res call(
      {List<NotificationDto> items,
      String? nextCursor,
      int unreadCount,
      bool isLoading,
      bool hasMore,
      bool wsConnected,
      String? error});
}

/// @nodoc
class _$NotificationStateCopyWithImpl<$Res>
    implements $NotificationStateCopyWith<$Res> {
  _$NotificationStateCopyWithImpl(this._self, this._then);

  final NotificationState _self;
  final $Res Function(NotificationState) _then;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? unreadCount = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? wsConnected = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NotificationDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      wsConnected: null == wsConnected
          ? _self.wsConnected
          : wsConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationState].
extension NotificationStatePatterns on NotificationState {
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
    TResult Function(_NotificationState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationState() when $default != null:
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
    TResult Function(_NotificationState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationState():
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
    TResult? Function(_NotificationState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationState() when $default != null:
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
            List<NotificationDto> items,
            String? nextCursor,
            int unreadCount,
            bool isLoading,
            bool hasMore,
            bool wsConnected,
            String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationState() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.unreadCount,
            _that.isLoading, _that.hasMore, _that.wsConnected, _that.error);
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
    TResult Function(
            List<NotificationDto> items,
            String? nextCursor,
            int unreadCount,
            bool isLoading,
            bool hasMore,
            bool wsConnected,
            String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationState():
        return $default(_that.items, _that.nextCursor, _that.unreadCount,
            _that.isLoading, _that.hasMore, _that.wsConnected, _that.error);
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
            List<NotificationDto> items,
            String? nextCursor,
            int unreadCount,
            bool isLoading,
            bool hasMore,
            bool wsConnected,
            String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationState() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.unreadCount,
            _that.isLoading, _that.hasMore, _that.wsConnected, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _NotificationState implements NotificationState {
  const _NotificationState(
      {final List<NotificationDto> items = const [],
      this.nextCursor,
      this.unreadCount = 0,
      this.isLoading = false,
      this.hasMore = false,
      this.wsConnected = false,
      this.error})
      : _items = items;

  final List<NotificationDto> _items;
  @override
  @JsonKey()
  List<NotificationDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool wsConnected;
  @override
  final String? error;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationStateCopyWith<_NotificationState> get copyWith =>
      __$NotificationStateCopyWithImpl<_NotificationState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationState &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.wsConnected, wsConnected) ||
                other.wsConnected == wsConnected) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      nextCursor,
      unreadCount,
      isLoading,
      hasMore,
      wsConnected,
      error);

  @override
  String toString() {
    return 'NotificationState(items: $items, nextCursor: $nextCursor, unreadCount: $unreadCount, isLoading: $isLoading, hasMore: $hasMore, wsConnected: $wsConnected, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$NotificationStateCopyWith<$Res>
    implements $NotificationStateCopyWith<$Res> {
  factory _$NotificationStateCopyWith(
          _NotificationState value, $Res Function(_NotificationState) _then) =
      __$NotificationStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<NotificationDto> items,
      String? nextCursor,
      int unreadCount,
      bool isLoading,
      bool hasMore,
      bool wsConnected,
      String? error});
}

/// @nodoc
class __$NotificationStateCopyWithImpl<$Res>
    implements _$NotificationStateCopyWith<$Res> {
  __$NotificationStateCopyWithImpl(this._self, this._then);

  final _NotificationState _self;
  final $Res Function(_NotificationState) _then;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? unreadCount = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? wsConnected = null,
    Object? error = freezed,
  }) {
    return _then(_NotificationState(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NotificationDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      wsConnected: null == wsConnected
          ? _self.wsConnected
          : wsConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
