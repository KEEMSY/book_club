import 'package:geolocator/geolocator.dart';

/// Resolves the origin coordinate used to center the nearby-events search.
///
/// Wraps the `geolocator` platform calls behind a single method so the
/// notifier stays free of permission/SDK details and tests can substitute a
/// fake. When the device denies permission, has location services disabled, or
/// the lookup throws, the search falls back to Seoul City Hall so the screen
/// always has a usable origin (CLAUDE.md §2 default).
class LocationService {
  const LocationService();

  /// Seoul City Hall — the fallback origin when GPS is unavailable.
  static const double fallbackLat = 37.5665;
  static const double fallbackLng = 126.9780;

  /// Requests permission if needed and returns the device position, falling
  /// back to [fallbackLat]/[fallbackLng] when location is unavailable.
  Future<({double lat, double lng})> resolveOrigin() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return _fallback;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _fallback;
      }
      final Position position = await Geolocator.getCurrentPosition();
      return (lat: position.latitude, lng: position.longitude);
    } catch (_) {
      // Any platform/permission failure degrades to the fixed origin rather
      // than leaving the search without coordinates.
      return _fallback;
    }
  }

  ({double lat, double lng}) get _fallback =>
      (lat: fallbackLat, lng: fallbackLng);
}
