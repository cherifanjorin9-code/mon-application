import 'product.dart';

/// Cart item entity
class CartItem {
  final Product product;
  final double quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  /// Total price for this item
  double get totalPrice => product.sellingPrice * quantity;

  /// Market total for comparison
  double get marketTotalPrice => product.marketPrice * quantity;

  CartItem copyWith({Product? product, double? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem && product.id == other.product.id;

  @override
  int get hashCode => product.id.hashCode;
}

/// Cart entity — holds all cart items
class Cart {
  final List<CartItem> items;

  const Cart({this.items = const []});

  /// Number of unique items
  int get itemCount => items.length;

  /// Total number of products (sum of quantities)
  double get totalQuantity =>
      items.fold(0.0, (sum, item) => sum + item.quantity);

  /// Subtotal in FCFA
  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Market subtotal for savings comparison
  double get marketSubtotal =>
      items.fold(0.0, (sum, item) => sum + item.marketTotalPrice);

  /// Total margin paid
  double get totalMargin => subtotal - marketSubtotal;

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Check if a product is in the cart
  bool containsProduct(int productId) =>
      items.any((item) => item.product.id == productId);

  /// Get quantity of a specific product
  double getQuantity(int productId) {
    final item = items.where((i) => i.product.id == productId).firstOrNull;
    return item?.quantity ?? 0;
  }

  /// Add item to cart (or update quantity if exists)
  Cart addItem(Product product, double quantity) {
    final existingIndex =
        items.indexWhere((item) => item.product.id == product.id);

    final newItems = List<CartItem>.from(items);

    if (existingIndex >= 0) {
      final existing = newItems[existingIndex];
      newItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      newItems.add(CartItem(product: product, quantity: quantity));
    }

    return Cart(items: newItems);
  }

  /// Update item quantity
  Cart updateQuantity(int productId, double quantity) {
    if (quantity <= 0) return removeItem(productId);

    final newItems = items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    return Cart(items: newItems);
  }

  /// Remove item from cart
  Cart removeItem(int productId) {
    return Cart(
      items: items.where((item) => item.product.id != productId).toList(),
    );
  }

  /// Clear all items
  Cart clear() => const Cart();
}
