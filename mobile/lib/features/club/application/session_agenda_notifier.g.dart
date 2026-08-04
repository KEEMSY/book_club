// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_agenda_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionAgendaHash() => r'108858f62eeeebd13a20a23646a2236c98c1bafd';

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

/// Fetches the published agenda for [sessionId], if any.
///
/// `null` means the session has no published agenda yet — the detail screen
/// shows an empty state instead of the accordion in that case.
///
/// Copied from [sessionAgenda].
@ProviderFor(sessionAgenda)
const sessionAgendaProvider = SessionAgendaFamily();

/// Fetches the published agenda for [sessionId], if any.
///
/// `null` means the session has no published agenda yet — the detail screen
/// shows an empty state instead of the accordion in that case.
///
/// Copied from [sessionAgenda].
class SessionAgendaFamily extends Family<AsyncValue<SessionAgenda?>> {
  /// Fetches the published agenda for [sessionId], if any.
  ///
  /// `null` means the session has no published agenda yet — the detail screen
  /// shows an empty state instead of the accordion in that case.
  ///
  /// Copied from [sessionAgenda].
  const SessionAgendaFamily();

  /// Fetches the published agenda for [sessionId], if any.
  ///
  /// `null` means the session has no published agenda yet — the detail screen
  /// shows an empty state instead of the accordion in that case.
  ///
  /// Copied from [sessionAgenda].
  SessionAgendaProvider call(
    String sessionId,
  ) {
    return SessionAgendaProvider(
      sessionId,
    );
  }

  @override
  SessionAgendaProvider getProviderOverride(
    covariant SessionAgendaProvider provider,
  ) {
    return call(
      provider.sessionId,
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
  String? get name => r'sessionAgendaProvider';
}

/// Fetches the published agenda for [sessionId], if any.
///
/// `null` means the session has no published agenda yet — the detail screen
/// shows an empty state instead of the accordion in that case.
///
/// Copied from [sessionAgenda].
class SessionAgendaProvider extends AutoDisposeFutureProvider<SessionAgenda?> {
  /// Fetches the published agenda for [sessionId], if any.
  ///
  /// `null` means the session has no published agenda yet — the detail screen
  /// shows an empty state instead of the accordion in that case.
  ///
  /// Copied from [sessionAgenda].
  SessionAgendaProvider(
    String sessionId,
  ) : this._internal(
          (ref) => sessionAgenda(
            ref as SessionAgendaRef,
            sessionId,
          ),
          from: sessionAgendaProvider,
          name: r'sessionAgendaProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionAgendaHash,
          dependencies: SessionAgendaFamily._dependencies,
          allTransitiveDependencies:
              SessionAgendaFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  SessionAgendaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  Override overrideWith(
    FutureOr<SessionAgenda?> Function(SessionAgendaRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionAgendaProvider._internal(
        (ref) => create(ref as SessionAgendaRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SessionAgenda?> createElement() {
    return _SessionAgendaProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionAgendaProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionAgendaRef on AutoDisposeFutureProviderRef<SessionAgenda?> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _SessionAgendaProviderElement
    extends AutoDisposeFutureProviderElement<SessionAgenda?>
    with SessionAgendaRef {
  _SessionAgendaProviderElement(super.provider);

  @override
  String get sessionId => (origin as SessionAgendaProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
