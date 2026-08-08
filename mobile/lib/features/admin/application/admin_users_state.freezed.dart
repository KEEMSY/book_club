// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_users_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUsersState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AdminUsersState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AdminUsersState()';
  }
}

/// @nodoc
class $AdminUsersStateCopyWith<$Res> {
  $AdminUsersStateCopyWith(
      AdminUsersState _, $Res Function(AdminUsersState) __);
}

/// Adds pattern-matching-related methods to [AdminUsersState].
extension AdminUsersStatePatterns on AdminUsersState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminUsersLoading value)? loading,
    TResult Function(AdminUsersLoaded value)? loaded,
    TResult Function(AdminUsersError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AdminUsersLoading() when loading != null:
        return loading(_that);
      case AdminUsersLoaded() when loaded != null:
        return loaded(_that);
      case AdminUsersError() when error != null:
        return error(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(AdminUsersLoading value) loading,
    required TResult Function(AdminUsersLoaded value) loaded,
    required TResult Function(AdminUsersError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case AdminUsersLoading():
        return loading(_that);
      case AdminUsersLoaded():
        return loaded(_that);
      case AdminUsersError():
        return error(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminUsersLoading value)? loading,
    TResult? Function(AdminUsersLoaded value)? loaded,
    TResult? Function(AdminUsersError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case AdminUsersLoading() when loading != null:
        return loading(_that);
      case AdminUsersLoaded() when loaded != null:
        return loaded(_that);
      case AdminUsersError() when error != null:
        return error(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String search, List<AdminUser> items, int page, int total,
            bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AdminUsersLoading() when loading != null:
        return loading();
      case AdminUsersLoaded() when loaded != null:
        return loaded(_that.search, _that.items, _that.page, _that.total,
            _that.isLoadingMore);
      case AdminUsersError() when error != null:
        return error(_that.code, _that.message);
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
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String search, List<AdminUser> items, int page,
            int total, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case AdminUsersLoading():
        return loading();
      case AdminUsersLoaded():
        return loaded(_that.search, _that.items, _that.page, _that.total,
            _that.isLoadingMore);
      case AdminUsersError():
        return error(_that.code, _that.message);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(String search, List<AdminUser> items, int page, int total,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case AdminUsersLoading() when loading != null:
        return loading();
      case AdminUsersLoaded() when loaded != null:
        return loaded(_that.search, _that.items, _that.page, _that.total,
            _that.isLoadingMore);
      case AdminUsersError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AdminUsersLoading implements AdminUsersState {
  const AdminUsersLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AdminUsersLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AdminUsersState.loading()';
  }
}

/// @nodoc

class AdminUsersLoaded implements AdminUsersState {
  const AdminUsersLoaded(
      {required this.search,
      required final List<AdminUser> items,
      required this.page,
      required this.total,
      this.isLoadingMore = false})
      : _items = items;

  final String search;
  final List<AdminUser> _items;
  List<AdminUser> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final int page;
  final int total;
  @JsonKey()
  final bool isLoadingMore;

  /// Create a copy of AdminUsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminUsersLoadedCopyWith<AdminUsersLoaded> get copyWith =>
      _$AdminUsersLoadedCopyWithImpl<AdminUsersLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminUsersLoaded &&
            (identical(other.search, search) || other.search == search) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType, search,
      const DeepCollectionEquality().hash(_items), page, total, isLoadingMore);

  @override
  String toString() {
    return 'AdminUsersState.loaded(search: $search, items: $items, page: $page, total: $total, isLoadingMore: $isLoadingMore)';
  }
}

/// @nodoc
abstract mixin class $AdminUsersLoadedCopyWith<$Res>
    implements $AdminUsersStateCopyWith<$Res> {
  factory $AdminUsersLoadedCopyWith(
          AdminUsersLoaded value, $Res Function(AdminUsersLoaded) _then) =
      _$AdminUsersLoadedCopyWithImpl;
  @useResult
  $Res call(
      {String search,
      List<AdminUser> items,
      int page,
      int total,
      bool isLoadingMore});
}

/// @nodoc
class _$AdminUsersLoadedCopyWithImpl<$Res>
    implements $AdminUsersLoadedCopyWith<$Res> {
  _$AdminUsersLoadedCopyWithImpl(this._self, this._then);

  final AdminUsersLoaded _self;
  final $Res Function(AdminUsersLoaded) _then;

  /// Create a copy of AdminUsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? search = null,
    Object? items = null,
    Object? page = null,
    Object? total = null,
    Object? isLoadingMore = null,
  }) {
    return _then(AdminUsersLoaded(
      search: null == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AdminUser>,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class AdminUsersError implements AdminUsersState {
  const AdminUsersError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of AdminUsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminUsersErrorCopyWith<AdminUsersError> get copyWith =>
      _$AdminUsersErrorCopyWithImpl<AdminUsersError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminUsersError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'AdminUsersState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $AdminUsersErrorCopyWith<$Res>
    implements $AdminUsersStateCopyWith<$Res> {
  factory $AdminUsersErrorCopyWith(
          AdminUsersError value, $Res Function(AdminUsersError) _then) =
      _$AdminUsersErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$AdminUsersErrorCopyWithImpl<$Res>
    implements $AdminUsersErrorCopyWith<$Res> {
  _$AdminUsersErrorCopyWithImpl(this._self, this._then);

  final AdminUsersError _self;
  final $Res Function(AdminUsersError) _then;

  /// Create a copy of AdminUsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(AdminUsersError(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
