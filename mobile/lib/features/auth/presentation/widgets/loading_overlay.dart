import 'package:flutter/material.dart';

/// Modal barrier + centered spinner used while the auth flow is in progress.
///
/// Stays behind the whole [Stack] so tapping outside the spinner is absorbed
/// (no accidental re-trigger of the Kakao or Apple button mid-flight). Alpha
/// matches Airbnb's scrim (`0x66`) for consistency with later modal sheets.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.24),
          child: Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
