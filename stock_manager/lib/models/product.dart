/// Product model for stock_manager
class Product {
  final String id;
  final String name;
  final String barcode;
  final String category;
  final double price;
  final int quantity;
  final int minQuantity;
  final String? description;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.category,
    required this.price,
    required this.quantity,
    required this.minQuantity,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'] as String,
    name: map['name'] as String,
    barcode: map['barcode'] as String,
    category: map['category'] as String,
    price: (map['price'] as num).toDouble(),
    quantity: map['quantity'] as int,
    minQuantity: map['minQuantity'] as int,
    description: map['description'] as String?,
    createdAt: map['createdAt'] as String,
    updatedAt: map['updatedAt'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'barcode': barcode,
    'category': category,
    'price': price,
    'quantity': quantity,
    'minQuantity': minQuantity,
    'description': description,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
