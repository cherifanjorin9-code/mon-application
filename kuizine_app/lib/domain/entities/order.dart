/// Order entity for KUIZINE domain layer
class Order {
  final int id;
  final String orderNumber;
  final int userId;
  final OrderStatus status;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryAddress;
  final String deliveryQuarter;
  final String? deliveryNotes;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final List<OrderItem> items;
  final DateTime? estimatedDelivery;
  final DateTime? deliveredAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryAddress,
    this.deliveryQuarter = '',
    this.deliveryNotes,
    required this.paymentMethod,
    required this.paymentStatus,
    this.items = const [],
    this.estimatedDelivery,
    this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if order can be cancelled
  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  /// Check if order is active (not completed or cancelled)
  bool get isActive =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;

  /// Get status label in French
  String get statusLabel => status.label;

  Order copyWith({
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    DateTime? deliveredAt,
  }) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      userId: userId,
      status: status ?? this.status,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      deliveryAddress: deliveryAddress,
      deliveryQuarter: deliveryQuarter,
      deliveryNotes: deliveryNotes,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      items: items,
      estimatedDelivery: estimatedDelivery,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      userId: json['user_id'] as int,
      status: OrderStatus.fromString(json['status'] as String),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: json['delivery_address'] as String,
      deliveryQuarter: json['delivery_quarter'] as String? ?? '',
      deliveryNotes: json['delivery_notes'] as String?,
      paymentMethod: PaymentMethod.fromString(json['payment_method'] as String),
      paymentStatus: PaymentStatus.fromString(json['payment_status'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

/// Order item
class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String? productImage;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}

/// Order status enum
enum OrderStatus {
  pending('PENDING', 'En attente', '⏳'),
  confirmed('CONFIRMED', 'Confirmée', '✅'),
  preparing('PREPARING', 'En préparation', '👨‍🍳'),
  outForDelivery('OUT_FOR_DELIVERY', 'En livraison', '🛵'),
  delivered('DELIVERED', 'Livrée', '🎉'),
  cancelled('CANCELLED', 'Annulée', '❌');

  final String value;
  final String label;
  final String emoji;

  const OrderStatus(this.value, this.label, this.emoji);

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => OrderStatus.pending,
    );
  }

  /// Get the step index for timeline (0-based)
  int get stepIndex {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

/// Payment method enum
enum PaymentMethod {
  mtnMomo('MTN_MOMO', 'MTN MoMo', '📱'),
  moovMoney('MOOV_MONEY', 'Moov Money', '📱'),
  cash('CASH', 'Espèces', '💵');

  final String value;
  final String label;
  final String emoji;

  const PaymentMethod(this.value, this.label, this.emoji);

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => PaymentMethod.cash,
    );
  }
}

/// Payment status enum
enum PaymentStatus {
  pending('PENDING', 'En attente'),
  paid('PAID', 'Payé'),
  failed('FAILED', 'Échoué'),
  refunded('REFUNDED', 'Remboursé');

  final String value;
  final String label;

  const PaymentStatus(this.value, this.label);

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => PaymentStatus.pending,
    );
  }
}
