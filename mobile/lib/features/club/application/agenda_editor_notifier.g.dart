// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_editor_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$agendaForEditHash() => r'9a643af5246835859545de46588a3a168def2ec7';

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

/// Loads (or lazily creates) the agenda draft for [sessionId] to prefill the
/// BC-50 editor screen.
///
/// Distinct from `sessionAgendaProvider` (BC-49), which only surfaces
/// *published* agendas for the read-only detail screen — the editor also
/// needs to resume an unpublished draft, or start from a fresh empty one
/// when the session has no agenda at all yet. The editor invalidates this
/// provider after every mutation (draft save, publish, topic add/remove/
/// reorder) so its view always reflects what the repository holds.
///
/// Copied from [agendaForEdit].
@ProviderFor(agendaForEdit)
const agendaForEditProvider = AgendaForEditFamily();

/// Loads (or lazily creates) the agenda draft for [sessionId] to prefill the
/// BC-50 editor screen.
///
/// Distinct from `sessionAgendaProvider` (BC-49), which only surfaces
/// *published* agendas for the read-only detail screen — the editor also
/// needs to resume an unpublished draft, or start from a fresh empty one
/// when the session has no agenda at all yet. The editor invalidates this
/// provider after every mutation (draft save, publish, topic add/remove/
/// reorder) so its view always reflects what the repository holds.
///
/// Copied from [agendaForEdit].
class AgendaForEditFamily extends Family<AsyncValue<SessionAgenda>> {
  /// Loads (or lazily creates) the agenda draft for [sessionId] to prefill the
  /// BC-50 editor screen.
  ///
  /// Distinct from `sessionAgendaProvider` (BC-49), which only surfaces
  /// *published* agendas for the read-only detail screen — the editor also
  /// needs to resume an unpublished draft, or start from a fresh empty one
  /// when the session has no agenda at all yet. The editor invalidates this
  /// provider after every mutation (draft save, publish, topic add/remove/
  /// reorder) so its view always reflects what the repository holds.
  ///
  /// Copied from [agendaForEdit].
  const AgendaForEditFamily();

  /// Loads (or lazily creates) the agenda draft for [sessionId] to prefill the
  /// BC-50 editor screen.
  ///
  /// Distinct from `sessionAgendaProvider` (BC-49), which only surfaces
  /// *published* agendas for the read-only detail screen — the editor also
  /// needs to resume an unpublished draft, or start from a fresh empty one
  /// when the session has no agenda at all yet. The editor invalidates this
  /// provider after every mutation (draft save, publish, topic add/remove/
  /// reorder) so its view always reflects what the repository holds.
  ///
  /// Copied from [agendaForEdit].
  AgendaForEditProvider call(
    String sessionId,
  ) {
    return AgendaForEditProvider(
      sessionId,
    );
  }

  @override
  AgendaForEditProvider getProviderOverride(
    covariant AgendaForEditProvider provider,
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
  String? get name => r'agendaForEditProvider';
}

/// Loads (or lazily creates) the agenda draft for [sessionId] to prefill the
/// BC-50 editor screen.
///
/// Distinct from `sessionAgendaProvider` (BC-49), which only surfaces
/// *published* agendas for the read-only detail screen — the editor also
/// needs to resume an unpublished draft, or start from a fresh empty one
/// when the session has no agenda at all yet. The editor invalidates this
/// provider after every mutation (draft save, publish, topic add/remove/
/// reorder) so its view always reflects what the repository holds.
///
/// Copied from [agendaForEdit].
class AgendaForEditProvider extends AutoDisposeFutureProvider<SessionAgenda> {
  /// Loads (or lazily creates) the agenda draft for [sessionId] to prefill the
  /// BC-50 editor screen.
  ///
  /// Distinct from `sessionAgendaProvider` (BC-49), which only surfaces
  /// *published* agendas for the read-only detail screen — the editor also
  /// needs to resume an unpublished draft, or start from a fresh empty one
  /// when the session has no agenda at all yet. The editor invalidates this
  /// provider after every mutation (draft save, publish, topic add/remove/
  /// reorder) so its view always reflects what the repository holds.
  ///
  /// Copied from [agendaForEdit].
  AgendaForEditProvider(
    String sessionId,
  ) : this._internal(
          (ref) => agendaForEdit(
            ref as AgendaForEditRef,
            sessionId,
          ),
          from: agendaForEditProvider,
          name: r'agendaForEditProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$agendaForEditHash,
          dependencies: AgendaForEditFamily._dependencies,
          allTransitiveDependencies:
              AgendaForEditFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  AgendaForEditProvider._internal(
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
    FutureOr<SessionAgenda> Function(AgendaForEditRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AgendaForEditProvider._internal(
        (ref) => create(ref as AgendaForEditRef),
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
  AutoDisposeFutureProviderElement<SessionAgenda> createElement() {
    return _AgendaForEditProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AgendaForEditProvider && other.sessionId == sessionId;
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
mixin AgendaForEditRef on AutoDisposeFutureProviderRef<SessionAgenda> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _AgendaForEditProviderElement
    extends AutoDisposeFutureProviderElement<SessionAgenda>
    with AgendaForEditRef {
  _AgendaForEditProviderElement(super.provider);

  @override
  String get sessionId => (origin as AgendaForEditProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
