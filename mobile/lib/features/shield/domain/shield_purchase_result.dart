/// Domain model returned after a successful shield purchase.
class ShieldPurchaseResult {
  const ShieldPurchaseResult({
    required this.shieldsGranted,
    required this.totalShields,
  });

  final int shieldsGranted;
  final int totalShields;
}
