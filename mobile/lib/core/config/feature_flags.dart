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

  // Deferred (BC-16): social graph (follow/block) — exceeds reading-log MVP.
  static const bool social = true;
  // Deferred (BC-16): community posts/profiles domain.
  static const bool community = false;
  // Deferred (BC-16): reading clubs (group feature).
  static const bool club = true;
  static const bool challenge = true;
  static const bool discovery = false;
  static const bool search = false;
  static const bool curation = false;
  static const bool event = false;
  static const bool referral = true;
  static const bool reminder = true;
  static const bool retention = true;
  static const bool experiment = true;
  static const bool subscription = true;
  static const bool shield = true;
  static const bool review = true;
  // Deferred by BC-18: ai_assistant/video carry large external SDK cost
  // (Claude API / Agora RTC), team is out of consumer MVP scope. Entry points
  // read these; code stays in place. Flip back to true to re-scope.
  static const bool aiAssistant = false;
  static const bool share = true;
  // Deferred (BC-16): club video calls (M71); coupled to club.
  static const bool video = false;
  // Deferred (BC-18): B2B team plan.
  static const bool team = false;
}
