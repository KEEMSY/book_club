// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationDto {
  String get id;
  String get ntype;
  String get title;
  String get body;
  Map<String, String> get data;
  DateTime? get readAt;
  DateTime get createdAt;

  /// Create a copy of NotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationDtoCopyWith<NotificationDto> get copyWith =>
      _$NotificationDtoCopyWithImpl<NotificationDto>(
          this as NotificationDto, _$identity);

  /// Serializes this NotificationDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ntype, ntype) || other.ntype == ntype) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, ntype, title, body,
      const DeepCollectionEquality().hash(data), readAt, createdAt);

  @override
  String toString() {
    return 'NotificationDto(id: $id, ntype: $ntype, title: $title, body: $body, data: $data, readAt: $readAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $NotificationDtoCopyWith<$Res> {
  factory $NotificationDtoCopyWith(
          NotificationDto value, $Res Function(NotificationDto) _then) =
      _$NotificationDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String ntype,
      String title,
      String body,
      Map<String, String> data,
      DateTime? readAt,
      DateTime createdAt});
}

/// @nodoc
class _$NotificationDtoCopyWithImpl<$Res>
    implements $NotificationDtoCopyWith<$Res> {
  _$NotificationDtoCopyWithImpl(this._self, this._then);

  final NotificationDto _self;
  final $Res Function(NotificationDto) _then;

  /// Create a copy of NotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ntype = null,
    Object? title = null,
    Object? body = null,
    Object? data = null,
    Object? readAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ntype: null == ntype
          ? _self.ntype
          : ntype // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationDto].
extension NotificationDtoPatterns on NotificationDto {
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
    TResult Function(_NotificationDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationDto() when $default != null:
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
    TResult Function(_NotificationDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationDto():
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
    TResult? Function(_NotificationDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationDto() when $default != null:
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
    TResult Function(String id, String ntype, String title, String body,
            Map<String, String> data, DateTime? readAt, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationDto() when $default != null:
        return $default(_that.id, _that.ntype, _that.title, _that.body,
            _that.data, _that.readAt, _that.createdAt);
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
    TResult Function(String id, String ntype, String title, String body,
            Map<String, String> data, DateTime? readAt, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationDto():
        return $default(_that.id, _that.ntype, _that.title, _that.body,
            _that.data, _that.readAt, _that.createdAt);
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
    TResult? Function(String id, String ntype, String title, String body,
            Map<String, String> data, DateTime? readAt, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationDto() when $default != null:
        return $default(_that.id, _that.ntype, _that.title, _that.body,
            _that.data, _that.readAt, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationDto implements NotificationDto {
  const _NotificationDto(
      {required this.id,
      required this.ntype,
      required this.title,
      required this.body,
      final Map<String, String> data = const {},
      this.readAt,
      required this.createdAt})
      : _data = data;
  factory _NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  @override
  final String id;
  @override
  final String ntype;
  @override
  final String title;
  @override
  final String body;
  final Map<String, String> _data;
  @override
  @JsonKey()
  Map<String, String> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final DateTime? readAt;
  @override
  final DateTime createdAt;

  /// Create a copy of NotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationDtoCopyWith<_NotificationDto> get copyWith =>
      __$NotificationDtoCopyWithImpl<_NotificationDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ntype, ntype) || other.ntype == ntype) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, ntype, title, body,
      const DeepCollectionEquality().hash(_data), readAt, createdAt);

  @override
  String toString() {
    return 'NotificationDto(id: $id, ntype: $ntype, title: $title, body: $body, data: $data, readAt: $readAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$NotificationDtoCopyWith<$Res>
    implements $NotificationDtoCopyWith<$Res> {
  factory _$NotificationDtoCopyWith(
          _NotificationDto value, $Res Function(_NotificationDto) _then) =
      __$NotificationDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String ntype,
      String title,
      String body,
      Map<String, String> data,
      DateTime? readAt,
      DateTime createdAt});
}

/// @nodoc
class __$NotificationDtoCopyWithImpl<$Res>
    implements _$NotificationDtoCopyWith<$Res> {
  __$NotificationDtoCopyWithImpl(this._self, this._then);

  final _NotificationDto _self;
  final $Res Function(_NotificationDto) _then;

  /// Create a copy of NotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? ntype = null,
    Object? title = null,
    Object? body = null,
    Object? data = null,
    Object? readAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_NotificationDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ntype: null == ntype
          ? _self.ntype
          : ntype // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$NotificationListResponse {
  List<NotificationDto> get items;
  String? get nextCursor;
  int get unreadCount;

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationListResponseCopyWith<NotificationListResponse> get copyWith =>
      _$NotificationListResponseCopyWithImpl<NotificationListResponse>(
          this as NotificationListResponse, _$identity);

  /// Serializes this NotificationListResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationListResponse &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), nextCursor, unreadCount);

  @override
  String toString() {
    return 'NotificationListResponse(items: $items, nextCursor: $nextCursor, unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class $NotificationListResponseCopyWith<$Res> {
  factory $NotificationListResponseCopyWith(NotificationListResponse value,
          $Res Function(NotificationListResponse) _then) =
      _$NotificationListResponseCopyWithImpl;
  @useResult
  $Res call({List<NotificationDto> items, String? nextCursor, int unreadCount});
}

/// @nodoc
class _$NotificationListResponseCopyWithImpl<$Res>
    implements $NotificationListResponseCopyWith<$Res> {
  _$NotificationListResponseCopyWithImpl(this._self, this._then);

  final NotificationListResponse _self;
  final $Res Function(NotificationListResponse) _then;

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? unreadCount = null,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationListResponse].
extension NotificationListResponsePatterns on NotificationListResponse {
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
    TResult Function(_NotificationListResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationListResponse() when $default != null:
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
    TResult Function(_NotificationListResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationListResponse():
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
    TResult? Function(_NotificationListResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationListResponse() when $default != null:
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
            List<NotificationDto> items, String? nextCursor, int unreadCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationListResponse() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.unreadCount);
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
            List<NotificationDto> items, String? nextCursor, int unreadCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationListResponse():
        return $default(_that.items, _that.nextCursor, _that.unreadCount);
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
            List<NotificationDto> items, String? nextCursor, int unreadCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationListResponse() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.unreadCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationListResponse implements NotificationListResponse {
  const _NotificationListResponse(
      {required final List<NotificationDto> items,
      this.nextCursor,
      required this.unreadCount})
      : _items = items;
  factory _NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);

  final List<NotificationDto> _items;
  @override
  List<NotificationDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;
  @override
  final int unreadCount;

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationListResponseCopyWith<_NotificationListResponse> get copyWith =>
      __$NotificationListResponseCopyWithImpl<_NotificationListResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationListResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationListResponse &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), nextCursor, unreadCount);

  @override
  String toString() {
    return 'NotificationListResponse(items: $items, nextCursor: $nextCursor, unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class _$NotificationListResponseCopyWith<$Res>
    implements $NotificationListResponseCopyWith<$Res> {
  factory _$NotificationListResponseCopyWith(_NotificationListResponse value,
          $Res Function(_NotificationListResponse) _then) =
      __$NotificationListResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<NotificationDto> items, String? nextCursor, int unreadCount});
}

/// @nodoc
class __$NotificationListResponseCopyWithImpl<$Res>
    implements _$NotificationListResponseCopyWith<$Res> {
  __$NotificationListResponseCopyWithImpl(this._self, this._then);

  final _NotificationListResponse _self;
  final $Res Function(_NotificationListResponse) _then;

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? unreadCount = null,
  }) {
    return _then(_NotificationListResponse(
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
    ));
  }
}

/// @nodoc
mixin _$UnreadCountResponse {
  int get unreadCount;

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnreadCountResponseCopyWith<UnreadCountResponse> get copyWith =>
      _$UnreadCountResponseCopyWithImpl<UnreadCountResponse>(
          this as UnreadCountResponse, _$identity);

  /// Serializes this UnreadCountResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnreadCountResponse &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, unreadCount);

  @override
  String toString() {
    return 'UnreadCountResponse(unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class $UnreadCountResponseCopyWith<$Res> {
  factory $UnreadCountResponseCopyWith(
          UnreadCountResponse value, $Res Function(UnreadCountResponse) _then) =
      _$UnreadCountResponseCopyWithImpl;
  @useResult
  $Res call({int unreadCount});
}

/// @nodoc
class _$UnreadCountResponseCopyWithImpl<$Res>
    implements $UnreadCountResponseCopyWith<$Res> {
  _$UnreadCountResponseCopyWithImpl(this._self, this._then);

  final UnreadCountResponse _self;
  final $Res Function(UnreadCountResponse) _then;

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unreadCount = null,
  }) {
    return _then(_self.copyWith(
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [UnreadCountResponse].
extension UnreadCountResponsePatterns on UnreadCountResponse {
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
    TResult Function(_UnreadCountResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UnreadCountResponse() when $default != null:
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
    TResult Function(_UnreadCountResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountResponse():
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
    TResult? Function(_UnreadCountResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountResponse() when $default != null:
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
    TResult Function(int unreadCount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UnreadCountResponse() when $default != null:
        return $default(_that.unreadCount);
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
    TResult Function(int unreadCount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountResponse():
        return $default(_that.unreadCount);
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
    TResult? Function(int unreadCount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountResponse() when $default != null:
        return $default(_that.unreadCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UnreadCountResponse implements UnreadCountResponse {
  const _UnreadCountResponse({required this.unreadCount});
  factory _UnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountResponseFromJson(json);

  @override
  final int unreadCount;

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UnreadCountResponseCopyWith<_UnreadCountResponse> get copyWith =>
      __$UnreadCountResponseCopyWithImpl<_UnreadCountResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UnreadCountResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UnreadCountResponse &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, unreadCount);

  @override
  String toString() {
    return 'UnreadCountResponse(unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class _$UnreadCountResponseCopyWith<$Res>
    implements $UnreadCountResponseCopyWith<$Res> {
  factory _$UnreadCountResponseCopyWith(_UnreadCountResponse value,
          $Res Function(_UnreadCountResponse) _then) =
      __$UnreadCountResponseCopyWithImpl;
  @override
  @useResult
  $Res call({int unreadCount});
}

/// @nodoc
class __$UnreadCountResponseCopyWithImpl<$Res>
    implements _$UnreadCountResponseCopyWith<$Res> {
  __$UnreadCountResponseCopyWithImpl(this._self, this._then);

  final _UnreadCountResponse _self;
  final $Res Function(_UnreadCountResponse) _then;

  /// Create a copy of UnreadCountResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? unreadCount = null,
  }) {
    return _then(_UnreadCountResponse(
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$WeeklyReportResponse {
  String get id;
  String get weekStart;
  int get totalSeconds;
  int get sessionCount;
  String? get bestDay;
  int get longestSessionSec;
  DateTime get createdAt;

  /// Create a copy of WeeklyReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeeklyReportResponseCopyWith<WeeklyReportResponse> get copyWith =>
      _$WeeklyReportResponseCopyWithImpl<WeeklyReportResponse>(
          this as WeeklyReportResponse, _$identity);

  /// Serializes this WeeklyReportResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeeklyReportResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount) &&
            (identical(other.bestDay, bestDay) || other.bestDay == bestDay) &&
            (identical(other.longestSessionSec, longestSessionSec) ||
                other.longestSessionSec == longestSessionSec) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, weekStart, totalSeconds,
      sessionCount, bestDay, longestSessionSec, createdAt);

  @override
  String toString() {
    return 'WeeklyReportResponse(id: $id, weekStart: $weekStart, totalSeconds: $totalSeconds, sessionCount: $sessionCount, bestDay: $bestDay, longestSessionSec: $longestSessionSec, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $WeeklyReportResponseCopyWith<$Res> {
  factory $WeeklyReportResponseCopyWith(WeeklyReportResponse value,
          $Res Function(WeeklyReportResponse) _then) =
      _$WeeklyReportResponseCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String weekStart,
      int totalSeconds,
      int sessionCount,
      String? bestDay,
      int longestSessionSec,
      DateTime createdAt});
}

/// @nodoc
class _$WeeklyReportResponseCopyWithImpl<$Res>
    implements $WeeklyReportResponseCopyWith<$Res> {
  _$WeeklyReportResponseCopyWithImpl(this._self, this._then);

  final WeeklyReportResponse _self;
  final $Res Function(WeeklyReportResponse) _then;

  /// Create a copy of WeeklyReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekStart = null,
    Object? totalSeconds = null,
    Object? sessionCount = null,
    Object? bestDay = freezed,
    Object? longestSessionSec = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekStart: null == weekStart
          ? _self.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as String,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionCount: null == sessionCount
          ? _self.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
      bestDay: freezed == bestDay
          ? _self.bestDay
          : bestDay // ignore: cast_nullable_to_non_nullable
              as String?,
      longestSessionSec: null == longestSessionSec
          ? _self.longestSessionSec
          : longestSessionSec // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [WeeklyReportResponse].
extension WeeklyReportResponsePatterns on WeeklyReportResponse {
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
    TResult Function(_WeeklyReportResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportResponse() when $default != null:
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
    TResult Function(_WeeklyReportResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportResponse():
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
    TResult? Function(_WeeklyReportResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportResponse() when $default != null:
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
            String weekStart,
            int totalSeconds,
            int sessionCount,
            String? bestDay,
            int longestSessionSec,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportResponse() when $default != null:
        return $default(
            _that.id,
            _that.weekStart,
            _that.totalSeconds,
            _that.sessionCount,
            _that.bestDay,
            _that.longestSessionSec,
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
            String weekStart,
            int totalSeconds,
            int sessionCount,
            String? bestDay,
            int longestSessionSec,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportResponse():
        return $default(
            _that.id,
            _that.weekStart,
            _that.totalSeconds,
            _that.sessionCount,
            _that.bestDay,
            _that.longestSessionSec,
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
            String weekStart,
            int totalSeconds,
            int sessionCount,
            String? bestDay,
            int longestSessionSec,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportResponse() when $default != null:
        return $default(
            _that.id,
            _that.weekStart,
            _that.totalSeconds,
            _that.sessionCount,
            _that.bestDay,
            _that.longestSessionSec,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WeeklyReportResponse implements WeeklyReportResponse {
  const _WeeklyReportResponse(
      {required this.id,
      required this.weekStart,
      required this.totalSeconds,
      required this.sessionCount,
      this.bestDay,
      required this.longestSessionSec,
      required this.createdAt});
  factory _WeeklyReportResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReportResponseFromJson(json);

  @override
  final String id;
  @override
  final String weekStart;
  @override
  final int totalSeconds;
  @override
  final int sessionCount;
  @override
  final String? bestDay;
  @override
  final int longestSessionSec;
  @override
  final DateTime createdAt;

  /// Create a copy of WeeklyReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeeklyReportResponseCopyWith<_WeeklyReportResponse> get copyWith =>
      __$WeeklyReportResponseCopyWithImpl<_WeeklyReportResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WeeklyReportResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeeklyReportResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.sessionCount, sessionCount) ||
                other.sessionCount == sessionCount) &&
            (identical(other.bestDay, bestDay) || other.bestDay == bestDay) &&
            (identical(other.longestSessionSec, longestSessionSec) ||
                other.longestSessionSec == longestSessionSec) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, weekStart, totalSeconds,
      sessionCount, bestDay, longestSessionSec, createdAt);

  @override
  String toString() {
    return 'WeeklyReportResponse(id: $id, weekStart: $weekStart, totalSeconds: $totalSeconds, sessionCount: $sessionCount, bestDay: $bestDay, longestSessionSec: $longestSessionSec, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$WeeklyReportResponseCopyWith<$Res>
    implements $WeeklyReportResponseCopyWith<$Res> {
  factory _$WeeklyReportResponseCopyWith(_WeeklyReportResponse value,
          $Res Function(_WeeklyReportResponse) _then) =
      __$WeeklyReportResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String weekStart,
      int totalSeconds,
      int sessionCount,
      String? bestDay,
      int longestSessionSec,
      DateTime createdAt});
}

/// @nodoc
class __$WeeklyReportResponseCopyWithImpl<$Res>
    implements _$WeeklyReportResponseCopyWith<$Res> {
  __$WeeklyReportResponseCopyWithImpl(this._self, this._then);

  final _WeeklyReportResponse _self;
  final $Res Function(_WeeklyReportResponse) _then;

  /// Create a copy of WeeklyReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? weekStart = null,
    Object? totalSeconds = null,
    Object? sessionCount = null,
    Object? bestDay = freezed,
    Object? longestSessionSec = null,
    Object? createdAt = null,
  }) {
    return _then(_WeeklyReportResponse(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekStart: null == weekStart
          ? _self.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as String,
      totalSeconds: null == totalSeconds
          ? _self.totalSeconds
          : totalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sessionCount: null == sessionCount
          ? _self.sessionCount
          : sessionCount // ignore: cast_nullable_to_non_nullable
              as int,
      bestDay: freezed == bestDay
          ? _self.bestDay
          : bestDay // ignore: cast_nullable_to_non_nullable
              as String?,
      longestSessionSec: null == longestSessionSec
          ? _self.longestSessionSec
          : longestSessionSec // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
