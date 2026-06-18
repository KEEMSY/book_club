// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_plan_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingPlanDto {
  String get id;
  String get clubId;
  String get bookId;
  DateTime get startDate;
  DateTime get endDate;
  int get weeklyPages;
  DateTime get createdAt;

  /// Create a copy of ReadingPlanDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadingPlanDtoCopyWith<ReadingPlanDto> get copyWith =>
      _$ReadingPlanDtoCopyWithImpl<ReadingPlanDto>(
          this as ReadingPlanDto, _$identity);

  /// Serializes this ReadingPlanDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadingPlanDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.weeklyPages, weeklyPages) ||
                other.weeklyPages == weeklyPages) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, bookId, startDate,
      endDate, weeklyPages, createdAt);

  @override
  String toString() {
    return 'ReadingPlanDto(id: $id, clubId: $clubId, bookId: $bookId, startDate: $startDate, endDate: $endDate, weeklyPages: $weeklyPages, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ReadingPlanDtoCopyWith<$Res> {
  factory $ReadingPlanDtoCopyWith(
          ReadingPlanDto value, $Res Function(ReadingPlanDto) _then) =
      _$ReadingPlanDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String bookId,
      DateTime startDate,
      DateTime endDate,
      int weeklyPages,
      DateTime createdAt});
}

/// @nodoc
class _$ReadingPlanDtoCopyWithImpl<$Res>
    implements $ReadingPlanDtoCopyWith<$Res> {
  _$ReadingPlanDtoCopyWithImpl(this._self, this._then);

  final ReadingPlanDto _self;
  final $Res Function(ReadingPlanDto) _then;

  /// Create a copy of ReadingPlanDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? bookId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? weeklyPages = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weeklyPages: null == weeklyPages
          ? _self.weeklyPages
          : weeklyPages // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReadingPlanDto].
extension ReadingPlanDtoPatterns on ReadingPlanDto {
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
    TResult Function(_ReadingPlanDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingPlanDto() when $default != null:
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
    TResult Function(_ReadingPlanDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingPlanDto():
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
    TResult? Function(_ReadingPlanDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingPlanDto() when $default != null:
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
            String clubId,
            String bookId,
            DateTime startDate,
            DateTime endDate,
            int weeklyPages,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingPlanDto() when $default != null:
        return $default(_that.id, _that.clubId, _that.bookId, _that.startDate,
            _that.endDate, _that.weeklyPages, _that.createdAt);
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
            String clubId,
            String bookId,
            DateTime startDate,
            DateTime endDate,
            int weeklyPages,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingPlanDto():
        return $default(_that.id, _that.clubId, _that.bookId, _that.startDate,
            _that.endDate, _that.weeklyPages, _that.createdAt);
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
            String clubId,
            String bookId,
            DateTime startDate,
            DateTime endDate,
            int weeklyPages,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingPlanDto() when $default != null:
        return $default(_that.id, _that.clubId, _that.bookId, _that.startDate,
            _that.endDate, _that.weeklyPages, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReadingPlanDto implements ReadingPlanDto {
  const _ReadingPlanDto(
      {required this.id,
      required this.clubId,
      required this.bookId,
      required this.startDate,
      required this.endDate,
      required this.weeklyPages,
      required this.createdAt});
  factory _ReadingPlanDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingPlanDtoFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String bookId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int weeklyPages;
  @override
  final DateTime createdAt;

  /// Create a copy of ReadingPlanDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReadingPlanDtoCopyWith<_ReadingPlanDto> get copyWith =>
      __$ReadingPlanDtoCopyWithImpl<_ReadingPlanDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReadingPlanDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReadingPlanDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.weeklyPages, weeklyPages) ||
                other.weeklyPages == weeklyPages) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, bookId, startDate,
      endDate, weeklyPages, createdAt);

  @override
  String toString() {
    return 'ReadingPlanDto(id: $id, clubId: $clubId, bookId: $bookId, startDate: $startDate, endDate: $endDate, weeklyPages: $weeklyPages, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ReadingPlanDtoCopyWith<$Res>
    implements $ReadingPlanDtoCopyWith<$Res> {
  factory _$ReadingPlanDtoCopyWith(
          _ReadingPlanDto value, $Res Function(_ReadingPlanDto) _then) =
      __$ReadingPlanDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String bookId,
      DateTime startDate,
      DateTime endDate,
      int weeklyPages,
      DateTime createdAt});
}

/// @nodoc
class __$ReadingPlanDtoCopyWithImpl<$Res>
    implements _$ReadingPlanDtoCopyWith<$Res> {
  __$ReadingPlanDtoCopyWithImpl(this._self, this._then);

  final _ReadingPlanDto _self;
  final $Res Function(_ReadingPlanDto) _then;

  /// Create a copy of ReadingPlanDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? bookId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? weeklyPages = null,
    Object? createdAt = null,
  }) {
    return _then(_ReadingPlanDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weeklyPages: null == weeklyPages
          ? _self.weeklyPages
          : weeklyPages // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$CreateReadingPlanRequest {
  String get bookId;
  String get startDate;
  String get endDate;

  /// Create a copy of CreateReadingPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateReadingPlanRequestCopyWith<CreateReadingPlanRequest> get copyWith =>
      _$CreateReadingPlanRequestCopyWithImpl<CreateReadingPlanRequest>(
          this as CreateReadingPlanRequest, _$identity);

  /// Serializes this CreateReadingPlanRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateReadingPlanRequest &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookId, startDate, endDate);

  @override
  String toString() {
    return 'CreateReadingPlanRequest(bookId: $bookId, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $CreateReadingPlanRequestCopyWith<$Res> {
  factory $CreateReadingPlanRequestCopyWith(CreateReadingPlanRequest value,
          $Res Function(CreateReadingPlanRequest) _then) =
      _$CreateReadingPlanRequestCopyWithImpl;
  @useResult
  $Res call({String bookId, String startDate, String endDate});
}

/// @nodoc
class _$CreateReadingPlanRequestCopyWithImpl<$Res>
    implements $CreateReadingPlanRequestCopyWith<$Res> {
  _$CreateReadingPlanRequestCopyWithImpl(this._self, this._then);

  final CreateReadingPlanRequest _self;
  final $Res Function(CreateReadingPlanRequest) _then;

  /// Create a copy of CreateReadingPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_self.copyWith(
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateReadingPlanRequest].
extension CreateReadingPlanRequestPatterns on CreateReadingPlanRequest {
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
    TResult Function(_CreateReadingPlanRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateReadingPlanRequest() when $default != null:
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
    TResult Function(_CreateReadingPlanRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateReadingPlanRequest():
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
    TResult? Function(_CreateReadingPlanRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateReadingPlanRequest() when $default != null:
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
    TResult Function(String bookId, String startDate, String endDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateReadingPlanRequest() when $default != null:
        return $default(_that.bookId, _that.startDate, _that.endDate);
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
    TResult Function(String bookId, String startDate, String endDate) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateReadingPlanRequest():
        return $default(_that.bookId, _that.startDate, _that.endDate);
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
    TResult? Function(String bookId, String startDate, String endDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateReadingPlanRequest() when $default != null:
        return $default(_that.bookId, _that.startDate, _that.endDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateReadingPlanRequest implements CreateReadingPlanRequest {
  const _CreateReadingPlanRequest(
      {required this.bookId, required this.startDate, required this.endDate});
  factory _CreateReadingPlanRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReadingPlanRequestFromJson(json);

  @override
  final String bookId;
  @override
  final String startDate;
  @override
  final String endDate;

  /// Create a copy of CreateReadingPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateReadingPlanRequestCopyWith<_CreateReadingPlanRequest> get copyWith =>
      __$CreateReadingPlanRequestCopyWithImpl<_CreateReadingPlanRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateReadingPlanRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateReadingPlanRequest &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookId, startDate, endDate);

  @override
  String toString() {
    return 'CreateReadingPlanRequest(bookId: $bookId, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class _$CreateReadingPlanRequestCopyWith<$Res>
    implements $CreateReadingPlanRequestCopyWith<$Res> {
  factory _$CreateReadingPlanRequestCopyWith(_CreateReadingPlanRequest value,
          $Res Function(_CreateReadingPlanRequest) _then) =
      __$CreateReadingPlanRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String bookId, String startDate, String endDate});
}

/// @nodoc
class __$CreateReadingPlanRequestCopyWithImpl<$Res>
    implements _$CreateReadingPlanRequestCopyWith<$Res> {
  __$CreateReadingPlanRequestCopyWithImpl(this._self, this._then);

  final _CreateReadingPlanRequest _self;
  final $Res Function(_CreateReadingPlanRequest) _then;

  /// Create a copy of CreateReadingPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bookId = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_CreateReadingPlanRequest(
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$UpdateProgressRequest {
  int get currentPage;

  /// Create a copy of UpdateProgressRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateProgressRequestCopyWith<UpdateProgressRequest> get copyWith =>
      _$UpdateProgressRequestCopyWithImpl<UpdateProgressRequest>(
          this as UpdateProgressRequest, _$identity);

  /// Serializes this UpdateProgressRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateProgressRequest &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPage);

  @override
  String toString() {
    return 'UpdateProgressRequest(currentPage: $currentPage)';
  }
}

/// @nodoc
abstract mixin class $UpdateProgressRequestCopyWith<$Res> {
  factory $UpdateProgressRequestCopyWith(UpdateProgressRequest value,
          $Res Function(UpdateProgressRequest) _then) =
      _$UpdateProgressRequestCopyWithImpl;
  @useResult
  $Res call({int currentPage});
}

/// @nodoc
class _$UpdateProgressRequestCopyWithImpl<$Res>
    implements $UpdateProgressRequestCopyWith<$Res> {
  _$UpdateProgressRequestCopyWithImpl(this._self, this._then);

  final UpdateProgressRequest _self;
  final $Res Function(UpdateProgressRequest) _then;

  /// Create a copy of UpdateProgressRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
  }) {
    return _then(_self.copyWith(
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [UpdateProgressRequest].
extension UpdateProgressRequestPatterns on UpdateProgressRequest {
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
    TResult Function(_UpdateProgressRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateProgressRequest() when $default != null:
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
    TResult Function(_UpdateProgressRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateProgressRequest():
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
    TResult? Function(_UpdateProgressRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateProgressRequest() when $default != null:
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
    TResult Function(int currentPage)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateProgressRequest() when $default != null:
        return $default(_that.currentPage);
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
    TResult Function(int currentPage) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateProgressRequest():
        return $default(_that.currentPage);
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
    TResult? Function(int currentPage)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateProgressRequest() when $default != null:
        return $default(_that.currentPage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UpdateProgressRequest implements UpdateProgressRequest {
  const _UpdateProgressRequest({required this.currentPage});
  factory _UpdateProgressRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProgressRequestFromJson(json);

  @override
  final int currentPage;

  /// Create a copy of UpdateProgressRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateProgressRequestCopyWith<_UpdateProgressRequest> get copyWith =>
      __$UpdateProgressRequestCopyWithImpl<_UpdateProgressRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdateProgressRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateProgressRequest &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPage);

  @override
  String toString() {
    return 'UpdateProgressRequest(currentPage: $currentPage)';
  }
}

/// @nodoc
abstract mixin class _$UpdateProgressRequestCopyWith<$Res>
    implements $UpdateProgressRequestCopyWith<$Res> {
  factory _$UpdateProgressRequestCopyWith(_UpdateProgressRequest value,
          $Res Function(_UpdateProgressRequest) _then) =
      __$UpdateProgressRequestCopyWithImpl;
  @override
  @useResult
  $Res call({int currentPage});
}

/// @nodoc
class __$UpdateProgressRequestCopyWithImpl<$Res>
    implements _$UpdateProgressRequestCopyWith<$Res> {
  __$UpdateProgressRequestCopyWithImpl(this._self, this._then);

  final _UpdateProgressRequest _self;
  final $Res Function(_UpdateProgressRequest) _then;

  /// Create a copy of UpdateProgressRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentPage = null,
  }) {
    return _then(_UpdateProgressRequest(
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$MemberProgressDto {
  String get userId;
  String get nickname;
  int get currentPage;
  double get progressPct;
  DateTime? get lastPageUpdatedAt;

  /// Create a copy of MemberProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemberProgressDtoCopyWith<MemberProgressDto> get copyWith =>
      _$MemberProgressDtoCopyWithImpl<MemberProgressDto>(
          this as MemberProgressDto, _$identity);

  /// Serializes this MemberProgressDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MemberProgressDto &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.progressPct, progressPct) ||
                other.progressPct == progressPct) &&
            (identical(other.lastPageUpdatedAt, lastPageUpdatedAt) ||
                other.lastPageUpdatedAt == lastPageUpdatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, nickname, currentPage,
      progressPct, lastPageUpdatedAt);

  @override
  String toString() {
    return 'MemberProgressDto(userId: $userId, nickname: $nickname, currentPage: $currentPage, progressPct: $progressPct, lastPageUpdatedAt: $lastPageUpdatedAt)';
  }
}

/// @nodoc
abstract mixin class $MemberProgressDtoCopyWith<$Res> {
  factory $MemberProgressDtoCopyWith(
          MemberProgressDto value, $Res Function(MemberProgressDto) _then) =
      _$MemberProgressDtoCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      String nickname,
      int currentPage,
      double progressPct,
      DateTime? lastPageUpdatedAt});
}

/// @nodoc
class _$MemberProgressDtoCopyWithImpl<$Res>
    implements $MemberProgressDtoCopyWith<$Res> {
  _$MemberProgressDtoCopyWithImpl(this._self, this._then);

  final MemberProgressDto _self;
  final $Res Function(MemberProgressDto) _then;

  /// Create a copy of MemberProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? currentPage = null,
    Object? progressPct = null,
    Object? lastPageUpdatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      progressPct: null == progressPct
          ? _self.progressPct
          : progressPct // ignore: cast_nullable_to_non_nullable
              as double,
      lastPageUpdatedAt: freezed == lastPageUpdatedAt
          ? _self.lastPageUpdatedAt
          : lastPageUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MemberProgressDto].
extension MemberProgressDtoPatterns on MemberProgressDto {
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
    TResult Function(_MemberProgressDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MemberProgressDto() when $default != null:
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
    TResult Function(_MemberProgressDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemberProgressDto():
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
    TResult? Function(_MemberProgressDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemberProgressDto() when $default != null:
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
    TResult Function(String userId, String nickname, int currentPage,
            double progressPct, DateTime? lastPageUpdatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MemberProgressDto() when $default != null:
        return $default(_that.userId, _that.nickname, _that.currentPage,
            _that.progressPct, _that.lastPageUpdatedAt);
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
    TResult Function(String userId, String nickname, int currentPage,
            double progressPct, DateTime? lastPageUpdatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemberProgressDto():
        return $default(_that.userId, _that.nickname, _that.currentPage,
            _that.progressPct, _that.lastPageUpdatedAt);
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
    TResult? Function(String userId, String nickname, int currentPage,
            double progressPct, DateTime? lastPageUpdatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemberProgressDto() when $default != null:
        return $default(_that.userId, _that.nickname, _that.currentPage,
            _that.progressPct, _that.lastPageUpdatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MemberProgressDto implements MemberProgressDto {
  const _MemberProgressDto(
      {required this.userId,
      required this.nickname,
      required this.currentPage,
      required this.progressPct,
      this.lastPageUpdatedAt});
  factory _MemberProgressDto.fromJson(Map<String, dynamic> json) =>
      _$MemberProgressDtoFromJson(json);

  @override
  final String userId;
  @override
  final String nickname;
  @override
  final int currentPage;
  @override
  final double progressPct;
  @override
  final DateTime? lastPageUpdatedAt;

  /// Create a copy of MemberProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MemberProgressDtoCopyWith<_MemberProgressDto> get copyWith =>
      __$MemberProgressDtoCopyWithImpl<_MemberProgressDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MemberProgressDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MemberProgressDto &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.progressPct, progressPct) ||
                other.progressPct == progressPct) &&
            (identical(other.lastPageUpdatedAt, lastPageUpdatedAt) ||
                other.lastPageUpdatedAt == lastPageUpdatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, nickname, currentPage,
      progressPct, lastPageUpdatedAt);

  @override
  String toString() {
    return 'MemberProgressDto(userId: $userId, nickname: $nickname, currentPage: $currentPage, progressPct: $progressPct, lastPageUpdatedAt: $lastPageUpdatedAt)';
  }
}

/// @nodoc
abstract mixin class _$MemberProgressDtoCopyWith<$Res>
    implements $MemberProgressDtoCopyWith<$Res> {
  factory _$MemberProgressDtoCopyWith(
          _MemberProgressDto value, $Res Function(_MemberProgressDto) _then) =
      __$MemberProgressDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId,
      String nickname,
      int currentPage,
      double progressPct,
      DateTime? lastPageUpdatedAt});
}

/// @nodoc
class __$MemberProgressDtoCopyWithImpl<$Res>
    implements _$MemberProgressDtoCopyWith<$Res> {
  __$MemberProgressDtoCopyWithImpl(this._self, this._then);

  final _MemberProgressDto _self;
  final $Res Function(_MemberProgressDto) _then;

  /// Create a copy of MemberProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? currentPage = null,
    Object? progressPct = null,
    Object? lastPageUpdatedAt = freezed,
  }) {
    return _then(_MemberProgressDto(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      progressPct: null == progressPct
          ? _self.progressPct
          : progressPct // ignore: cast_nullable_to_non_nullable
              as double,
      lastPageUpdatedAt: freezed == lastPageUpdatedAt
          ? _self.lastPageUpdatedAt
          : lastPageUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$ClubProgressDto {
  ReadingPlanDto? get plan;
  List<MemberProgressDto> get members;

  /// Create a copy of ClubProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClubProgressDtoCopyWith<ClubProgressDto> get copyWith =>
      _$ClubProgressDtoCopyWithImpl<ClubProgressDto>(
          this as ClubProgressDto, _$identity);

  /// Serializes this ClubProgressDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClubProgressDto &&
            (identical(other.plan, plan) || other.plan == plan) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, plan, const DeepCollectionEquality().hash(members));

  @override
  String toString() {
    return 'ClubProgressDto(plan: $plan, members: $members)';
  }
}

/// @nodoc
abstract mixin class $ClubProgressDtoCopyWith<$Res> {
  factory $ClubProgressDtoCopyWith(
          ClubProgressDto value, $Res Function(ClubProgressDto) _then) =
      _$ClubProgressDtoCopyWithImpl;
  @useResult
  $Res call({ReadingPlanDto? plan, List<MemberProgressDto> members});

  $ReadingPlanDtoCopyWith<$Res>? get plan;
}

/// @nodoc
class _$ClubProgressDtoCopyWithImpl<$Res>
    implements $ClubProgressDtoCopyWith<$Res> {
  _$ClubProgressDtoCopyWithImpl(this._self, this._then);

  final ClubProgressDto _self;
  final $Res Function(ClubProgressDto) _then;

  /// Create a copy of ClubProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plan = freezed,
    Object? members = null,
  }) {
    return _then(_self.copyWith(
      plan: freezed == plan
          ? _self.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as ReadingPlanDto?,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberProgressDto>,
    ));
  }

  /// Create a copy of ClubProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingPlanDtoCopyWith<$Res>? get plan {
    if (_self.plan == null) {
      return null;
    }

    return $ReadingPlanDtoCopyWith<$Res>(_self.plan!, (value) {
      return _then(_self.copyWith(plan: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ClubProgressDto].
extension ClubProgressDtoPatterns on ClubProgressDto {
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
    TResult Function(_ClubProgressDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubProgressDto() when $default != null:
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
    TResult Function(_ClubProgressDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubProgressDto():
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
    TResult? Function(_ClubProgressDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubProgressDto() when $default != null:
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
    TResult Function(ReadingPlanDto? plan, List<MemberProgressDto> members)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubProgressDto() when $default != null:
        return $default(_that.plan, _that.members);
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
    TResult Function(ReadingPlanDto? plan, List<MemberProgressDto> members)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubProgressDto():
        return $default(_that.plan, _that.members);
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
    TResult? Function(ReadingPlanDto? plan, List<MemberProgressDto> members)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubProgressDto() when $default != null:
        return $default(_that.plan, _that.members);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ClubProgressDto implements ClubProgressDto {
  const _ClubProgressDto(
      {this.plan, final List<MemberProgressDto> members = const []})
      : _members = members;
  factory _ClubProgressDto.fromJson(Map<String, dynamic> json) =>
      _$ClubProgressDtoFromJson(json);

  @override
  final ReadingPlanDto? plan;
  final List<MemberProgressDto> _members;
  @override
  @JsonKey()
  List<MemberProgressDto> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  /// Create a copy of ClubProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ClubProgressDtoCopyWith<_ClubProgressDto> get copyWith =>
      __$ClubProgressDtoCopyWithImpl<_ClubProgressDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ClubProgressDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ClubProgressDto &&
            (identical(other.plan, plan) || other.plan == plan) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, plan, const DeepCollectionEquality().hash(_members));

  @override
  String toString() {
    return 'ClubProgressDto(plan: $plan, members: $members)';
  }
}

/// @nodoc
abstract mixin class _$ClubProgressDtoCopyWith<$Res>
    implements $ClubProgressDtoCopyWith<$Res> {
  factory _$ClubProgressDtoCopyWith(
          _ClubProgressDto value, $Res Function(_ClubProgressDto) _then) =
      __$ClubProgressDtoCopyWithImpl;
  @override
  @useResult
  $Res call({ReadingPlanDto? plan, List<MemberProgressDto> members});

  @override
  $ReadingPlanDtoCopyWith<$Res>? get plan;
}

/// @nodoc
class __$ClubProgressDtoCopyWithImpl<$Res>
    implements _$ClubProgressDtoCopyWith<$Res> {
  __$ClubProgressDtoCopyWithImpl(this._self, this._then);

  final _ClubProgressDto _self;
  final $Res Function(_ClubProgressDto) _then;

  /// Create a copy of ClubProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? plan = freezed,
    Object? members = null,
  }) {
    return _then(_ClubProgressDto(
      plan: freezed == plan
          ? _self.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as ReadingPlanDto?,
      members: null == members
          ? _self._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberProgressDto>,
    ));
  }

  /// Create a copy of ClubProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingPlanDtoCopyWith<$Res>? get plan {
    if (_self.plan == null) {
      return null;
    }

    return $ReadingPlanDtoCopyWith<$Res>(_self.plan!, (value) {
      return _then(_self.copyWith(plan: value));
    });
  }
}

// dart format on
