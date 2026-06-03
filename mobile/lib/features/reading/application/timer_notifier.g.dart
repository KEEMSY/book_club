// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timerClockHash() => r'aa13d8bf05f97581d4ffac3e562c23c6a1e2f5d2';

/// Orchestrates the timer state machine. Owns the wall-clock tick stream so
/// the TimerScreen can stay declarative (it only watches [TimerState] and
/// the separate [timerElapsedProvider] for the seconds-updating clock).
/// Overridable wall-clock used by [TimerNotifier]. Tests inject a manual clock
/// via `timerClockProvider.overrideWith((_) => manualClock.now)`.
///
/// Copied from [timerClock].
@ProviderFor(timerClock)
final timerClockProvider = AutoDisposeProvider<DateTime Function()>.internal(
  timerClock,
  name: r'timerClockProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$timerClockHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimerClockRef = AutoDisposeProviderRef<DateTime Function()>;
String _$timerNotifierHash() => r'51052277542b66bd2e3c3a31e2c0fa4b32387473';

/// See also [TimerNotifier].
@ProviderFor(TimerNotifier)
final timerNotifierProvider =
    NotifierProvider<TimerNotifier, TimerState>.internal(
  TimerNotifier.new,
  name: r'timerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimerNotifier = Notifier<TimerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
