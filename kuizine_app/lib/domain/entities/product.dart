/// Product entity for KUIZINE domain layer
class Product {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final int categoryId;
  final String categoryName;
  final double marketPrice;
  final double marginPercent;
  final double sellingPrice;
  final String unit;
  final double minQuantity;
  final double stepQuantity;
  final int stockQuantity;
  final bool isAvailable;
  final bool isFeatured;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl,
    required this.categoryId,
    this.categoryName = '',
    required this.marketPrice,
    this.marginPercent = 4.0,
    required this.sellingPrice,
    this.unit = 'unité',
    this.minQuantity = 1,
    this.stepQuantity = 1,
    this.stockQuantity = 100,
    this.isAvailable = true,
    this.isFeatured = false,
    this.createdAt,
  });

  /// Calculate savings compared to market price
  double get savings => sellingPrice - marketPrice;

  /// Savings percentage
  String get savingsLabel => '+${marginPercent.toStringAsFixed(1)}%';

  /// Check if in stock
  bool get inStock => isAvailable && stockQuantity > 0;

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    int? categoryId,
    String? categoryName,
    double? marketPrice,
    double? marginPercent,
    double? sellingPrice,
    String? unit,
    double? minQuantity,
    double? stepQuantity,
    int? stockQuantity,
    bool? isAvailable,
    bool? isFeatured,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      marketPrice: marketPrice ?? this.marketPrice,
      marginPercent: marginPercent ?? this.marginPercent,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      unit: unit ?? this.unit,
      minQuantity: minQuantity ?? this.minQuantity,
      stepQuantity: stepQuantity ?? this.stepQuantity,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'category_id': categoryId,
      'category_name': categoryName,
      'market_price': marketPrice,
      'margin_percent': marginPercent,
      'selling_price': sellingPrice,
      'unit': unit,
      'min_quantity': minQuantity,
      'step_quantity': stepQuantity,
      'stock_quantity': stockQuantity,
      'is_available': isAvailable,
      'is_featured': isFeatured,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as int,
      categoryName: json['category_name'] as String? ?? '',
      marketPrice: (json['market_price'] as num).toDouble(),
      marginPercent: (json['margin_percent'] as num?)?.toDouble() ?? 4.0,
      sellingPrice: (json['selling_price'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'unité',
      minQuantity: (json['min_quantity'] as num?)?.toDouble() ?? 1,
      stepQuantity: (json['step_quantity'] as num?)?.toDouble() ?? 1,
      stockQuantity: json['stock_quantity'] as int? ?? 100,
      isAvailable: json['is_available'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
