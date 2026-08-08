import 'package:flutter/material.dart';

/// Predefined profile color-palette keys (backend BC-81, mobile UI BC-84).
///
/// Mirrors `backend/app/domains/auth/models.py::ProfileTheme` — a closed set
/// so the client ships a hand-tuned gradient per key instead of accepting an
/// arbitrary color the header rendering couldn't guarantee stays legible
/// against the avatar/name overlay. Growing this set is a coordinated
/// backend+mobile change, same as the server-side enum.
enum ProfileTheme {
  classic,
  sepia,
  midnight,
  forest,
  sunset,
  ocean;

  /// Wire value sent to `PATCH /me` (`theme` field). Matches the backend
  /// `ProfileTheme` StrEnum values exactly.
  String get wire {
    switch (this) {
      case ProfileTheme.classic:
        return 'classic';
      case ProfileTheme.sepia:
        return 'sepia';
      case ProfileTheme.midnight:
        return 'midnight';
      case ProfileTheme.forest:
        return 'forest';
      case ProfileTheme.sunset:
        return 'sunset';
      case ProfileTheme.ocean:
        return 'ocean';
    }
  }

  /// Parses the backend payload. Unknown/null values fall back to [classic]
  /// so a profile that never set a theme (the common case pre-BC-81
  /// adoption) still renders a sensible header instead of crashing.
  static ProfileTheme fromWire(String? value) {
    switch (value) {
      case 'sepia':
        return ProfileTheme.sepia;
      case 'midnight':
        return ProfileTheme.midnight;
      case 'forest':
        return ProfileTheme.forest;
      case 'sunset':
        return ProfileTheme.sunset;
      case 'ocean':
        return ProfileTheme.ocean;
      case 'classic':
      default:
        return ProfileTheme.classic;
    }
  }
}

/// Hand-tuned gradient + label per [ProfileTheme].
///
/// Consumed by the profile header cover banner (`user_profile_screen.dart`)
/// and the theme picker in `profile_edit_screen.dart`. Kept as a plain color
/// lookup (not a full `ColorScheme`, unlike `GradeTheme`) — this only paints
/// a header banner, it never swaps the app-wide theme.
class ProfileThemePalette {
  const ProfileThemePalette._();

  static const Map<ProfileTheme, List<Color>> _gradients =
      <ProfileTheme, List<Color>>{
    ProfileTheme.classic: <Color>[Color(0xFFF2E9DA), Color(0xFFD8C6A8)],
    ProfileTheme.sepia: <Color>[Color(0xFFCBA671), Color(0xFF8C6239)],
    ProfileTheme.midnight: <Color>[Color(0xFF232946), Color(0xFF0F1226)],
    ProfileTheme.forest: <Color>[Color(0xFF3F6B4F), Color(0xFF1F3D2B)],
    ProfileTheme.sunset: <Color>[Color(0xFFFF9770), Color(0xFFE8546B)],
    ProfileTheme.ocean: <Color>[Color(0xFF2E86AB), Color(0xFF13405A)],
  };

  static const Map<ProfileTheme, Color> _onColors = <ProfileTheme, Color>{
    ProfileTheme.classic: Color(0xFF3B2F22),
    ProfileTheme.sepia: Color(0xFFFFFDF8),
    ProfileTheme.midnight: Color(0xFFF2F2F7),
    ProfileTheme.forest: Color(0xFFF3F7F3),
    ProfileTheme.sunset: Color(0xFFFFFDF8),
    ProfileTheme.ocean: Color(0xFFF3F9FC),
  };

  static const Map<ProfileTheme, String> _labels = <ProfileTheme, String>{
    ProfileTheme.classic: '클래식',
    ProfileTheme.sepia: '세피아',
    ProfileTheme.midnight: '미드나잇',
    ProfileTheme.forest: '포레스트',
    ProfileTheme.sunset: '선셋',
    ProfileTheme.ocean: '오션',
  };

  /// Gradient stops (top → bottom) for the cover banner background.
  static List<Color> gradientOf(ProfileTheme theme) => _gradients[theme]!;

  /// Legible text/icon color against [gradientOf]'s banner.
  static Color onColorOf(ProfileTheme theme) => _onColors[theme]!;

  /// Korean label shown in the theme picker.
  static String labelOf(ProfileTheme theme) => _labels[theme]!;
}
