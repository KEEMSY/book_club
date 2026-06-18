import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits whether the device currently has any network connectivity (M55).
///
/// Drives the global offline banner. Resolves the current state first, then
/// follows live changes — until the first value arrives the UI treats the app
/// as online so a healthy launch never flashes the banner.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  yield _isOnline(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(_isOnline);
});

bool _isOnline(List<ConnectivityResult> results) =>
    results.any((ConnectivityResult r) => r != ConnectivityResult.none);
