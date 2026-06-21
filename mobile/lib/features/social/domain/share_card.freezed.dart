// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShareCardMeta {
  String get cardType;
  String get nickname;
  String? get profileImageUrl;
  String get referralCode;
  String get joinUrl;
  String get headline;
  String get caption;

  /// Create a copy of ShareCardMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShareCardMetaCopyWith<ShareCardMeta> get copyWith =>
      _$ShareCardMetaCopyWithImpl<ShareCardMeta>(
          this as ShareCardMeta, _$identity);

  /// Serializes this ShareCardMeta to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShareCardMeta &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.joinUrl, joinUrl) || other.joinUrl == joinUrl) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.caption, caption) || other.caption == caption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cardType, nickname,
      profileImageUrl, referralCode, joinUrl, headline, caption);

  @override
  String toString() {
    return 'ShareCardMeta(cardType: $cardType, nickname: $nickname, profileImageUrl: $profileImageUrl, referralCode: $referralCode, joinUrl: $joinUrl, headline: $headline, caption: $caption)';
  }
}

/// @nodoc
abstract mixin class $ShareCardMetaCopyWith<$Res> {
  factory $ShareCardMetaCopyWith(
          ShareCardMeta value, $Res Function(ShareCardMeta) _then) =
      _$ShareCardMetaCopyWithImpl;
  @useResult
  $Res call(
      {String cardType,
      String nickname,
      String? profileImageUrl,
      String referralCode,
      String joinUrl,
      String headline,
      String caption});
}

/// @nodoc
class _$ShareCardMetaCopyWithImpl<$Res>
    implements $ShareCardMetaCopyWith<$Res> {
  _$ShareCardMetaCopyWithImpl(this._self, this._then);

  final ShareCardMeta _self;
  final $Res Function(ShareCardMeta) _then;

  /// Create a copy of ShareCardMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardType = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? referralCode = null,
    Object? joinUrl = null,
    Object? headline = null,
    Object? caption = null,
  }) {
    return _then(_self.copyWith(
      cardType: null == cardType
          ? _self.cardType
          : cardType // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      referralCode: null == referralCode
          ? _self.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      joinUrl: null == joinUrl
          ? _self.joinUrl
          : joinUrl // ignore: cast_nullable_to_non_nullable
              as String,
      headline: null == headline
          ? _self.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String,
      caption: null == caption
          ? _self.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShareCardMeta].
extension ShareCardMetaPatterns on ShareCardMeta {
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
    TResult Function(_ShareCardMeta value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShareCardMeta() when $default != null:
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
    TResult Function(_ShareCardMeta value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShareCardMeta():
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
    TResult? Function(_ShareCardMeta value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShareCardMeta() when $default != null:
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
            String cardType,
            String nickname,
            String? profileImageUrl,
            String referralCode,
            String joinUrl,
            String headline,
            String caption)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShareCardMeta() when $default != null:
        return $default(_that.cardType, _that.nickname, _that.profileImageUrl,
            _that.referralCode, _that.joinUrl, _that.headline, _that.caption);
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
            String cardType,
            String nickname,
            String? profileImageUrl,
            String referralCode,
            String joinUrl,
            String headline,
            String caption)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShareCardMeta():
        return $default(_that.cardType, _that.nickname, _that.profileImageUrl,
            _that.referralCode, _that.joinUrl, _that.headline, _that.caption);
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
            String cardType,
            String nickname,
            String? profileImageUrl,
            String referralCode,
            String joinUrl,
            String headline,
            String caption)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShareCardMeta() when $default != null:
        return $default(_that.cardType, _that.nickname, _that.profileImageUrl,
            _that.referralCode, _that.joinUrl, _that.headline, _that.caption);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ShareCardMeta implements ShareCardMeta {
  const _ShareCardMeta(
      {required this.cardType,
      required this.nickname,
      this.profileImageUrl,
      required this.referralCode,
      required this.joinUrl,
      required this.headline,
      required this.caption});
  factory _ShareCardMeta.fromJson(Map<String, dynamic> json) =>
      _$ShareCardMetaFromJson(json);

  @override
  final String cardType;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;
  @override
  final String referralCode;
  @override
  final String joinUrl;
  @override
  final String headline;
  @override
  final String caption;

  /// Create a copy of ShareCardMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShareCardMetaCopyWith<_ShareCardMeta> get copyWith =>
      __$ShareCardMetaCopyWithImpl<_ShareCardMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ShareCardMetaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShareCardMeta &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.joinUrl, joinUrl) || other.joinUrl == joinUrl) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.caption, caption) || other.caption == caption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cardType, nickname,
      profileImageUrl, referralCode, joinUrl, headline, caption);

  @override
  String toString() {
    return 'ShareCardMeta(cardType: $cardType, nickname: $nickname, profileImageUrl: $profileImageUrl, referralCode: $referralCode, joinUrl: $joinUrl, headline: $headline, caption: $caption)';
  }
}

/// @nodoc
abstract mixin class _$ShareCardMetaCopyWith<$Res>
    implements $ShareCardMetaCopyWith<$Res> {
  factory _$ShareCardMetaCopyWith(
          _ShareCardMeta value, $Res Function(_ShareCardMeta) _then) =
      __$ShareCardMetaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String cardType,
      String nickname,
      String? profileImageUrl,
      String referralCode,
      String joinUrl,
      String headline,
      String caption});
}

/// @nodoc
class __$ShareCardMetaCopyWithImpl<$Res>
    implements _$ShareCardMetaCopyWith<$Res> {
  __$ShareCardMetaCopyWithImpl(this._self, this._then);

  final _ShareCardMeta _self;
  final $Res Function(_ShareCardMeta) _then;

  /// Create a copy of ShareCardMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cardType = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? referralCode = null,
    Object? joinUrl = null,
    Object? headline = null,
    Object? caption = null,
  }) {
    return _then(_ShareCardMeta(
      cardType: null == cardType
          ? _self.cardType
          : cardType // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      referralCode: null == referralCode
          ? _self.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      joinUrl: null == joinUrl
          ? _self.joinUrl
          : joinUrl // ignore: cast_nullable_to_non_nullable
              as String,
      headline: null == headline
          ? _self.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String,
      caption: null == caption
          ? _self.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
