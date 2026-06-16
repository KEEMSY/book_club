// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedEvent {
  String get id;
  String get userId;
  String get eventType;
  Map<String, dynamic> get eventMetadata;
  List<FeedReaction> get reactions;
  int get commentCount;
  DateTime get createdAt;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedEventCopyWith<FeedEvent> get copyWith =>
      _$FeedEventCopyWithImpl<FeedEvent>(this as FeedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            const DeepCollectionEquality()
                .equals(other.eventMetadata, eventMetadata) &&
            const DeepCollectionEquality().equals(other.reactions, reactions) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      eventType,
      const DeepCollectionEquality().hash(eventMetadata),
      const DeepCollectionEquality().hash(reactions),
      commentCount,
      createdAt);

  @override
  String toString() {
    return 'FeedEvent(id: $id, userId: $userId, eventType: $eventType, eventMetadata: $eventMetadata, reactions: $reactions, commentCount: $commentCount, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $FeedEventCopyWith<$Res> {
  factory $FeedEventCopyWith(FeedEvent value, $Res Function(FeedEvent) _then) =
      _$FeedEventCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String eventType,
      Map<String, dynamic> eventMetadata,
      List<FeedReaction> reactions,
      int commentCount,
      DateTime createdAt});
}

/// @nodoc
class _$FeedEventCopyWithImpl<$Res> implements $FeedEventCopyWith<$Res> {
  _$FeedEventCopyWithImpl(this._self, this._then);

  final FeedEvent _self;
  final $Res Function(FeedEvent) _then;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? eventType = null,
    Object? eventMetadata = null,
    Object? reactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _self.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventMetadata: null == eventMetadata
          ? _self.eventMetadata
          : eventMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      reactions: null == reactions
          ? _self.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<FeedReaction>,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedEvent].
extension FeedEventPatterns on FeedEvent {
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
    TResult Function(_FeedEvent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedEvent() when $default != null:
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
    TResult Function(_FeedEvent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedEvent():
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
    TResult? Function(_FeedEvent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedEvent() when $default != null:
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
            String id,
            String userId,
            String eventType,
            Map<String, dynamic> eventMetadata,
            List<FeedReaction> reactions,
            int commentCount,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedEvent() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.eventType,
            _that.eventMetadata,
            _that.reactions,
            _that.commentCount,
            _that.createdAt);
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
            String id,
            String userId,
            String eventType,
            Map<String, dynamic> eventMetadata,
            List<FeedReaction> reactions,
            int commentCount,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedEvent():
        return $default(
            _that.id,
            _that.userId,
            _that.eventType,
            _that.eventMetadata,
            _that.reactions,
            _that.commentCount,
            _that.createdAt);
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
            String id,
            String userId,
            String eventType,
            Map<String, dynamic> eventMetadata,
            List<FeedReaction> reactions,
            int commentCount,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedEvent() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.eventType,
            _that.eventMetadata,
            _that.reactions,
            _that.commentCount,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FeedEvent implements FeedEvent {
  const _FeedEvent(
      {required this.id,
      required this.userId,
      required this.eventType,
      required final Map<String, dynamic> eventMetadata,
      required final List<FeedReaction> reactions,
      required this.commentCount,
      required this.createdAt})
      : _eventMetadata = eventMetadata,
        _reactions = reactions;

  @override
  final String id;
  @override
  final String userId;
  @override
  final String eventType;
  final Map<String, dynamic> _eventMetadata;
  @override
  Map<String, dynamic> get eventMetadata {
    if (_eventMetadata is EqualUnmodifiableMapView) return _eventMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_eventMetadata);
  }

  final List<FeedReaction> _reactions;
  @override
  List<FeedReaction> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  @override
  final int commentCount;
  @override
  final DateTime createdAt;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedEventCopyWith<_FeedEvent> get copyWith =>
      __$FeedEventCopyWithImpl<_FeedEvent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            const DeepCollectionEquality()
                .equals(other._eventMetadata, _eventMetadata) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      eventType,
      const DeepCollectionEquality().hash(_eventMetadata),
      const DeepCollectionEquality().hash(_reactions),
      commentCount,
      createdAt);

  @override
  String toString() {
    return 'FeedEvent(id: $id, userId: $userId, eventType: $eventType, eventMetadata: $eventMetadata, reactions: $reactions, commentCount: $commentCount, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$FeedEventCopyWith<$Res>
    implements $FeedEventCopyWith<$Res> {
  factory _$FeedEventCopyWith(
          _FeedEvent value, $Res Function(_FeedEvent) _then) =
      __$FeedEventCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String eventType,
      Map<String, dynamic> eventMetadata,
      List<FeedReaction> reactions,
      int commentCount,
      DateTime createdAt});
}

/// @nodoc
class __$FeedEventCopyWithImpl<$Res> implements _$FeedEventCopyWith<$Res> {
  __$FeedEventCopyWithImpl(this._self, this._then);

  final _FeedEvent _self;
  final $Res Function(_FeedEvent) _then;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? eventType = null,
    Object? eventMetadata = null,
    Object? reactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
  }) {
    return _then(_FeedEvent(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _self.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventMetadata: null == eventMetadata
          ? _self._eventMetadata
          : eventMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      reactions: null == reactions
          ? _self._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<FeedReaction>,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$FeedEventPage {
  List<FeedEvent> get items;
  String? get cursor;

  /// Create a copy of FeedEventPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedEventPageCopyWith<FeedEventPage> get copyWith =>
      _$FeedEventPageCopyWithImpl<FeedEventPage>(
          this as FeedEventPage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedEventPage &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.cursor, cursor) || other.cursor == cursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), cursor);

  @override
  String toString() {
    return 'FeedEventPage(items: $items, cursor: $cursor)';
  }
}

/// @nodoc
abstract mixin class $FeedEventPageCopyWith<$Res> {
  factory $FeedEventPageCopyWith(
          FeedEventPage value, $Res Function(FeedEventPage) _then) =
      _$FeedEventPageCopyWithImpl;
  @useResult
  $Res call({List<FeedEvent> items, String? cursor});
}

/// @nodoc
class _$FeedEventPageCopyWithImpl<$Res>
    implements $FeedEventPageCopyWith<$Res> {
  _$FeedEventPageCopyWithImpl(this._self, this._then);

  final FeedEventPage _self;
  final $Res Function(FeedEventPage) _then;

  /// Create a copy of FeedEventPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? cursor = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FeedEvent>,
      cursor: freezed == cursor
          ? _self.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedEventPage].
extension FeedEventPagePatterns on FeedEventPage {
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
    TResult Function(_FeedEventPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedEventPage() when $default != null:
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
    TResult Function(_FeedEventPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedEventPage():
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
    TResult? Function(_FeedEventPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedEventPage() when $default != null:
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
    TResult Function(List<FeedEvent> items, String? cursor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedEventPage() when $default != null:
        return $default(_that.items, _that.cursor);
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
    TResult Function(List<FeedEvent> items, String? cursor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedEventPage():
        return $default(_that.items, _that.cursor);
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
    TResult? Function(List<FeedEvent> items, String? cursor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedEventPage() when $default != null:
        return $default(_that.items, _that.cursor);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FeedEventPage implements FeedEventPage {
  const _FeedEventPage({required final List<FeedEvent> items, this.cursor})
      : _items = items;

  final List<FeedEvent> _items;
  @override
  List<FeedEvent> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? cursor;

  /// Create a copy of FeedEventPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedEventPageCopyWith<_FeedEventPage> get copyWith =>
      __$FeedEventPageCopyWithImpl<_FeedEventPage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedEventPage &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.cursor, cursor) || other.cursor == cursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), cursor);

  @override
  String toString() {
    return 'FeedEventPage(items: $items, cursor: $cursor)';
  }
}

/// @nodoc
abstract mixin class _$FeedEventPageCopyWith<$Res>
    implements $FeedEventPageCopyWith<$Res> {
  factory _$FeedEventPageCopyWith(
          _FeedEventPage value, $Res Function(_FeedEventPage) _then) =
      __$FeedEventPageCopyWithImpl;
  @override
  @useResult
  $Res call({List<FeedEvent> items, String? cursor});
}

/// @nodoc
class __$FeedEventPageCopyWithImpl<$Res>
    implements _$FeedEventPageCopyWith<$Res> {
  __$FeedEventPageCopyWithImpl(this._self, this._then);

  final _FeedEventPage _self;
  final $Res Function(_FeedEventPage) _then;

  /// Create a copy of FeedEventPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? cursor = freezed,
  }) {
    return _then(_FeedEventPage(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FeedEvent>,
      cursor: freezed == cursor
          ? _self.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$FeedReactionToggleResult {
  bool get added;
  String get emoji;
  int get reactionCount;

  /// Create a copy of FeedReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedReactionToggleResultCopyWith<FeedReactionToggleResult> get copyWith =>
      _$FeedReactionToggleResultCopyWithImpl<FeedReactionToggleResult>(
          this as FeedReactionToggleResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedReactionToggleResult &&
            (identical(other.added, added) || other.added == added) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, added, emoji, reactionCount);

  @override
  String toString() {
    return 'FeedReactionToggleResult(added: $added, emoji: $emoji, reactionCount: $reactionCount)';
  }
}

/// @nodoc
abstract mixin class $FeedReactionToggleResultCopyWith<$Res> {
  factory $FeedReactionToggleResultCopyWith(FeedReactionToggleResult value,
          $Res Function(FeedReactionToggleResult) _then) =
      _$FeedReactionToggleResultCopyWithImpl;
  @useResult
  $Res call({bool added, String emoji, int reactionCount});
}

/// @nodoc
class _$FeedReactionToggleResultCopyWithImpl<$Res>
    implements $FeedReactionToggleResultCopyWith<$Res> {
  _$FeedReactionToggleResultCopyWithImpl(this._self, this._then);

  final FeedReactionToggleResult _self;
  final $Res Function(FeedReactionToggleResult) _then;

  /// Create a copy of FeedReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? added = null,
    Object? emoji = null,
    Object? reactionCount = null,
  }) {
    return _then(_self.copyWith(
      added: null == added
          ? _self.added
          : added // ignore: cast_nullable_to_non_nullable
              as bool,
      emoji: null == emoji
          ? _self.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      reactionCount: null == reactionCount
          ? _self.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedReactionToggleResult].
extension FeedReactionToggleResultPatterns on FeedReactionToggleResult {
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
    TResult Function(_FeedReactionToggleResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedReactionToggleResult() when $default != null:
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
    TResult Function(_FeedReactionToggleResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedReactionToggleResult():
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
    TResult? Function(_FeedReactionToggleResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedReactionToggleResult() when $default != null:
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
    TResult Function(bool added, String emoji, int reactionCount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedReactionToggleResult() when $default != null:
        return $default(_that.added, _that.emoji, _that.reactionCount);
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
    TResult Function(bool added, String emoji, int reactionCount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedReactionToggleResult():
        return $default(_that.added, _that.emoji, _that.reactionCount);
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
    TResult? Function(bool added, String emoji, int reactionCount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedReactionToggleResult() when $default != null:
        return $default(_that.added, _that.emoji, _that.reactionCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FeedReactionToggleResult implements FeedReactionToggleResult {
  const _FeedReactionToggleResult(
      {required this.added, required this.emoji, required this.reactionCount});

  @override
  final bool added;
  @override
  final String emoji;
  @override
  final int reactionCount;

  /// Create a copy of FeedReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedReactionToggleResultCopyWith<_FeedReactionToggleResult> get copyWith =>
      __$FeedReactionToggleResultCopyWithImpl<_FeedReactionToggleResult>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedReactionToggleResult &&
            (identical(other.added, added) || other.added == added) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, added, emoji, reactionCount);

  @override
  String toString() {
    return 'FeedReactionToggleResult(added: $added, emoji: $emoji, reactionCount: $reactionCount)';
  }
}

/// @nodoc
abstract mixin class _$FeedReactionToggleResultCopyWith<$Res>
    implements $FeedReactionToggleResultCopyWith<$Res> {
  factory _$FeedReactionToggleResultCopyWith(_FeedReactionToggleResult value,
          $Res Function(_FeedReactionToggleResult) _then) =
      __$FeedReactionToggleResultCopyWithImpl;
  @override
  @useResult
  $Res call({bool added, String emoji, int reactionCount});
}

/// @nodoc
class __$FeedReactionToggleResultCopyWithImpl<$Res>
    implements _$FeedReactionToggleResultCopyWith<$Res> {
  __$FeedReactionToggleResultCopyWithImpl(this._self, this._then);

  final _FeedReactionToggleResult _self;
  final $Res Function(_FeedReactionToggleResult) _then;

  /// Create a copy of FeedReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? added = null,
    Object? emoji = null,
    Object? reactionCount = null,
  }) {
    return _then(_FeedReactionToggleResult(
      added: null == added
          ? _self.added
          : added // ignore: cast_nullable_to_non_nullable
              as bool,
      emoji: null == emoji
          ? _self.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      reactionCount: null == reactionCount
          ? _self.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
