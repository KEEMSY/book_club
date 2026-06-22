import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/event.dart';
import 'event_providers.dart';

/// Allowed nearby search radii in kilometers, surfaced as a segmented control.
const List<double> kEventRadiusOptions = <double>[5, 10, 20];

/// Genre/category labels reused by the filter chips and the create sheet.
const List<String> kEventCategories = <String>[
  '소설',
  '자기계발',
  '인문학',
  '과학',
  '기타',
];

/// Immutable filter + data snapshot driving the nearby-events screen.
class NearbyEventsState {
  const NearbyEventsState({
    required this.radiusKm,
    this.category,
    this.onDate,
    this.events = const AsyncValue<List<Event>>.loading(),
  });

  /// Active search radius (one of [kEventRadiusOptions]).
  final double radiusKm;

  /// Optional category filter; null means "all".
  final String? category;

  /// Optional day filter; only events on this calendar date are kept.
  final DateTime? onDate;

  /// Loaded events (already filtered) or the loading/error state.
  final AsyncValue<List<Event>> events;

  NearbyEventsState copyWith({
    double? radiusKm,
    AsyncValue<List<Event>>? events,
    Object? category = _sentinel,
    Object? onDate = _sentinel,
  }) {
    return NearbyEventsState(
      radiusKm: radiusKm ?? this.radiusKm,
      category:
          identical(category, _sentinel) ? this.category : category as String?,
      onDate: identical(onDate, _sentinel) ? this.onDate : onDate as DateTime?,
      events: events ?? this.events,
    );
  }

  static const Object _sentinel = Object();
}

/// Owns the nearby-events query origin, filters, and result list.
///
/// The origin is resolved once from the device location (with a Seoul City Hall
/// fallback) via [LocationService] and then cached, so radius/filter changes do
/// not re-prompt for permission; distance is computed server-side off [Event].
class NearbyEventsNotifier extends AutoDisposeNotifier<NearbyEventsState> {
  // Resolved origin, cached after the first successful lookup.
  double? _originLat;
  double? _originLng;

  @override
  NearbyEventsState build() {
    // Kick off the initial fetch; the screen reads `state.events`.
    Future<void>.microtask(load);
    return const NearbyEventsState(radiusKm: 5);
  }

  /// Fetches the first page for the current radius and re-applies filters.
  ///
  /// Resolves the device origin on the first call (requesting location
  /// permission if needed) and reuses it on subsequent loads.
  Future<void> load() async {
    state = state.copyWith(events: const AsyncValue<List<Event>>.loading());
    if (_originLat == null || _originLng == null) {
      final ({double lat, double lng}) origin =
          await ref.read(locationServiceProvider).resolveOrigin();
      _originLat = origin.lat;
      _originLng = origin.lng;
    }
    final AsyncValue<List<Event>> result =
        await AsyncValue.guard<List<Event>>(() async {
      final NearbyEventsResult page =
          await ref.read(eventRepositoryProvider).getNearbyEvents(
                lat: _originLat!,
                lng: _originLng!,
                radiusKm: state.radiusKm,
              );
      return _applyFilters(page.items);
    });
    state = state.copyWith(events: result);
  }

  void setRadius(double radiusKm) {
    if (radiusKm == state.radiusKm) return;
    state = state.copyWith(radiusKm: radiusKm);
    load();
  }

  void setCategory(String? category) {
    if (category == state.category) return;
    state = state.copyWith(category: category);
    // Re-fetch: the loaded list is already filtered, so a purely client-side
    // refilter could not re-add items dropped by a previous, narrower filter.
    load();
  }

  void setDate(DateTime? onDate) {
    state = state.copyWith(onDate: onDate);
    load();
  }

  List<Event> _applyFilters(List<Event> events) {
    Iterable<Event> filtered = events;
    final String? category = state.category;
    if (category != null) {
      filtered = filtered.where((Event e) => e.category == category);
    }
    final DateTime? day = state.onDate;
    if (day != null) {
      filtered = filtered.where((Event e) => _isSameDay(e.eventAt, day));
    }
    return filtered.toList(growable: false);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    final DateTime la = a.toLocal();
    final DateTime lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }
}

final nearbyEventsProvider =
    AutoDisposeNotifierProvider<NearbyEventsNotifier, NearbyEventsState>(
  NearbyEventsNotifier.new,
);
