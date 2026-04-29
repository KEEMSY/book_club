// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highlight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Highlight {
  String get id => throw _privateConstructorUsedError;
  String get userBookId => throw _privateConstructorUsedError;
  String get quoteText => throw _privateConstructorUsedError;
  int? get pageNumber => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HighlightCopyWith<Highlight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightCopyWith<$Res> {
  factory $HighlightCopyWith(Highlight value, $Res Function(Highlight) then) =
      _$HighlightCopyWithImpl<$Res, Highlight>;
  @useResult
  $Res call(
      {String id,
      String userBookId,
      String quoteText,
      int? pageNumber,
      DateTime createdAt});
}

/// @nodoc
class _$HighlightCopyWithImpl<$Res, $Val extends Highlight>
    implements $HighlightCopyWith<$Res> {
  _$HighlightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? quoteText = null,
    Object? pageNumber = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _value.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: freezed == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HighlightImplCopyWith<$Res>
    implements $HighlightCopyWith<$Res> {
  factory _$$HighlightImplCopyWith(
          _$HighlightImpl value, $Res Function(_$HighlightImpl) then) =
      __$$HighlightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userBookId,
      String quoteText,
      int? pageNumber,
      DateTime createdAt});
}

/// @nodoc
class __$$HighlightImplCopyWithImpl<$Res>
    extends _$HighlightCopyWithImpl<$Res, _$HighlightImpl>
    implements _$$HighlightImplCopyWith<$Res> {
  __$$HighlightImplCopyWithImpl(
      _$HighlightImpl _value, $Res Function(_$HighlightImpl) _then)
      : super(_value, _then);

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? quoteText = null,
    Object? pageNumber = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$HighlightImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _value.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: freezed == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$HighlightImpl implements _Highlight {
  const _$HighlightImpl(
      {required this.id,
      required this.userBookId,
      required this.quoteText,
      this.pageNumber,
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
  final DateTime createdAt;

  @override
  String toString() {
    return 'Highlight(id: $id, userBookId: $userBookId, quoteText: $quoteText, pageNumber: $pageNumber, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, quoteText, pageNumber, createdAt);

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightImplCopyWith<_$HighlightImpl> get copyWith =>
      __$$HighlightImplCopyWithImpl<_$HighlightImpl>(this, _$identity);
}

abstract class _Highlight implements Highlight {
  const factory _Highlight(
      {required final String id,
      required final String userBookId,
      required final String quoteText,
      final int? pageNumber,
      required final DateTime createdAt}) = _$HighlightImpl;

  @override
  String get id;
  @override
  String get userBookId;
  @override
  String get quoteText;
  @override
  int? get pageNumber;
  @override
  DateTime get createdAt;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightImplCopyWith<_$HighlightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HighlightPage {
  List<Highlight> get items => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Create a copy of HighlightPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HighlightPageCopyWith<HighlightPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightPageCopyWith<$Res> {
  factory $HighlightPageCopyWith(
          HighlightPage value, $Res Function(HighlightPage) then) =
      _$HighlightPageCopyWithImpl<$Res, HighlightPage>;
  @useResult
  $Res call({List<Highlight> items, String? nextCursor});
}

/// @nodoc
class _$HighlightPageCopyWithImpl<$Res, $Val extends HighlightPage>
    implements $HighlightPageCopyWith<$Res> {
  _$HighlightPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HighlightPage
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
              as List<Highlight>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HighlightPageImplCopyWith<$Res>
    implements $HighlightPageCopyWith<$Res> {
  factory _$$HighlightPageImplCopyWith(
          _$HighlightPageImpl value, $Res Function(_$HighlightPageImpl) then) =
      __$$HighlightPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Highlight> items, String? nextCursor});
}

/// @nodoc
class __$$HighlightPageImplCopyWithImpl<$Res>
    extends _$HighlightPageCopyWithImpl<$Res, _$HighlightPageImpl>
    implements _$$HighlightPageImplCopyWith<$Res> {
  __$$HighlightPageImplCopyWithImpl(
      _$HighlightPageImpl _value, $Res Function(_$HighlightPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of HighlightPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$HighlightPageImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HighlightPageImpl implements _HighlightPage {
  const _$HighlightPageImpl(
      {required final List<Highlight> items, this.nextCursor})
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

  @override
  String toString() {
    return 'HighlightPage(items: $items, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightPageImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  /// Create a copy of HighlightPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightPageImplCopyWith<_$HighlightPageImpl> get copyWith =>
      __$$HighlightPageImplCopyWithImpl<_$HighlightPageImpl>(this, _$identity);
}

abstract class _HighlightPage implements HighlightPage {
  const factory _HighlightPage(
      {required final List<Highlight> items,
      final String? nextCursor}) = _$HighlightPageImpl;

  @override
  List<Highlight> get items;
  @override
  String? get nextCursor;

  /// Create a copy of HighlightPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightPageImplCopyWith<_$HighlightPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
