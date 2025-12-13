/// Product model for stock_manager
class Product {
  final String id;
  final String name;
  final String barcode;
  final String categoryId;
  final double price;
  final int quantity;
  final int minQuantity;
  final String? description;
  final List<String>? images;
  final List<Map<String, dynamic>>? variants;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.categoryId,
    required this.price,
    required this.quantity,
    required this.minQuantity,
    this.description,
    this.images,
    this.variants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'] as String,
    name: map['name'] as String,
    barcode: map['barcode'] as String,
    categoryId: map['categoryId'] as String,
    price: (map['price'] as num).toDouble(),
    quantity: map['quantity'] as int,
    minQuantity: map['minQuantity'] as int,
    description: map['description'] as String?,
    images: (map['images'] as String?)?.split(','),
    variants: null, // Will be loaded separately
    createdAt: map['createdAt'] as String,
    updatedAt: map['updatedAt'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'barcode': barcode,
    'categoryId': categoryId,
    'price': price,
    'quantity': quantity,
    'minQuantity': minQuantity,
    'description': description,
    'images': images?.join(','),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  bool get isLowStock => quantity <= minQuantity;

  Product copyWith({
    String? id,
    String? name,
    String? barcode,
    String? categoryId,
    double? price,
    int? quantity,
    int? minQuantity,
    String? description,
    List<String>? images,
    List<Map<String, dynamic>>? variants,
    String? createdAt,
    String? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      description: description ?? this.description,
      images: images ?? this.images,
      variants: variants ?? this.variants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
