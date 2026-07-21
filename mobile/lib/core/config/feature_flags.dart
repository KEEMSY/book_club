/// Feature flags for scope cleanup (BC-1).
///
/// Non-MVP features are gated here so they can be deferred (hidden) without
/// deleting code. MVP core (auth/book/reading/feed/notification) is always on
/// and has no flag. Default [true] preserves current behavior; the scope audit
/// (BC-16~20) flips individual flags to [false] for deferred features. UI entry
/// points (navigation items, route guards, buttons) read these flags to decide
/// whether to render the feature.
class FeatureFlags {
  const FeatureFlags._();

  static const bool social = true;
  static const bool community = true;
  static const bool club = true;
  static const bool challenge = true;
  static const bool discovery = true;
  static const bool search = true;
  static const bool curation = true;
  static const bool event = true;
  static const bool referral = false;
  static const bool reminder = true;
  static const bool retention = false;
  static const bool experiment = false;
  static const bool subscription = false;
  static const bool shield = true;
  static const bool review = true;
  static const bool aiAssistant = true;
  static const bool share = true;
  static const bool video = true;
  static const bool team = true;
}
