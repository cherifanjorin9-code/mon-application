/// Category entity for KUIZINE domain layer
class Category {
  final int id;
  final String name;
  final String icon;
  final String description;
  final int sortOrder;
  final bool isActive;
  final int productCount;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.description = '',
    this.sortOrder = 0,
    this.isActive = true,
    this.productCount = 0,
  });

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    String? description,
    int? sortOrder,
    bool? isActive,
    int? productCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      productCount: productCount ?? this.productCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '🍽️',
      description: json['description'] as String? ?? '',
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      productCount: json['product_count'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
