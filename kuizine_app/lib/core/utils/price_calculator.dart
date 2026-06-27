/// Price calculator for KUIZINE
/// Implements the 3-5% margin over market prices
class PriceCalculator {
  PriceCalculator._();

  /// Default margin percentage
  static const double defaultMargin = 4.0;

  /// Minimum margin percentage
  static const double minMargin = 3.0;

  /// Maximum margin percentage
  static const double maxMargin = 5.0;

  /// Calculate selling price from market price with margin
  /// Returns price rounded to nearest 5 FCFA for clean pricing
  static int calculateSellingPrice(num marketPrice, {double margin = defaultMargin}) {
    assert(margin >= minMargin && margin <= maxMargin,
        'Margin must be between $minMargin% and $maxMargin%');

    final rawPrice = marketPrice * (1 + margin / 100);
    // Round to nearest 5 FCFA for clean pricing
    return (rawPrice / 5).ceil() * 5;
  }

  /// Calculate the margin amount in FCFA
  static int calculateMarginAmount(num marketPrice, {double margin = defaultMargin}) {
    return calculateSellingPrice(marketPrice, margin: margin) - marketPrice.toInt();
  }

  /// Calculate subtotal for cart items
  static int calculateSubtotal(List<CartPriceItem> items) {
    return items.fold(0, (sum, item) => sum + (item.unitPrice * item.quantity).toInt());
  }

  /// Calculate delivery fee based on zone
  static int getDeliveryFee(String? zone) {
    switch (zone?.toLowerCase()) {
      case 'centre':
      case 'centre porto-novo':
        return 200;
      case 'ouando':
      case 'tokpota':
      case 'djassin':
        return 300;
      case 'houinmé':
      case 'agbokou':
      case 'catchi':
        return 400;
      default:
        return 500;
    }
  }

  /// Calculate total (subtotal + delivery)
  static int calculateTotal(int subtotal, int deliveryFee) {
    return subtotal + deliveryFee;
  }

  /// Calculate savings vs going to market
  /// (estimated transport + time cost - our margin)
  static int calculateEstimatedSavings(int subtotal) {
    // Average transport cost to market: 300-500 FCFA roundtrip
    const avgTransportCost = 400;
    final marginPaid = (subtotal * defaultMargin / 100).round();
    final savings = avgTransportCost - marginPaid;
    return savings > 0 ? savings : 0;
  }
}

/// Simple cart item for price calculation
class CartPriceItem {
  final num unitPrice;
  final num quantity;

  const CartPriceItem({required this.unitPrice, required this.quantity});
}
