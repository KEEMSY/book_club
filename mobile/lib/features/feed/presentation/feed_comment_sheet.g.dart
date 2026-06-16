// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_comment_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventCommentNotifierHash() =>
    r'69e0cb1967446eb63b6f8d8ce431f3a501369646';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$EventCommentNotifier
    extends BuildlessAutoDisposeNotifier<EventCommentState> {
  late final String eventId;

  EventCommentState build(
    String eventId,
  );
}

/// See also [EventCommentNotifier].
@ProviderFor(EventCommentNotifier)
const eventCommentNotifierProvider = EventCommentNotifierFamily();

/// See also [EventCommentNotifier].
class EventCommentNotifierFamily extends Family<EventCommentState> {
  /// See also [EventCommentNotifier].
  const EventCommentNotifierFamily();

  /// See also [EventCommentNotifier].
  EventCommentNotifierProvider call(
    String eventId,
  ) {
    return EventCommentNotifierProvider(
      eventId,
    );
  }

  @override
  EventCommentNotifierProvider getProviderOverride(
    covariant EventCommentNotifierProvider provider,
  ) {
    return call(
      provider.eventId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'eventCommentNotifierProvider';
}

/// See also [EventCommentNotifier].
class EventCommentNotifierProvider extends AutoDisposeNotifierProviderImpl<
    EventCommentNotifier, EventCommentState> {
  /// See also [EventCommentNotifier].
  EventCommentNotifierProvider(
    String eventId,
  ) : this._internal(
          () => EventCommentNotifier()..eventId = eventId,
          from: eventCommentNotifierProvider,
          name: r'eventCommentNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventCommentNotifierHash,
          dependencies: EventCommentNotifierFamily._dependencies,
          allTransitiveDependencies:
              EventCommentNotifierFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventCommentNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  EventCommentState runNotifierBuild(
    covariant EventCommentNotifier notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventCommentNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventCommentNotifierProvider._internal(
        () => create()..eventId = eventId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<EventCommentNotifier, EventCommentState>
      createElement() {
    return _EventCommentNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventCommentNotifierProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventCommentNotifierRef
    on AutoDisposeNotifierProviderRef<EventCommentState> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventCommentNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<EventCommentNotifier,
        EventCommentState> with EventCommentNotifierRef {
  _EventCommentNotifierProviderElement(super.provider);

  @override
  String get eventId => (origin as EventCommentNotifierProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
