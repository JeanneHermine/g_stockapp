class Product {
final String id;
final String name;
final String barcode;
final String categoryId;
final double price;
final int quantity;
final int minQuantity;
final String? description;
final DateTime createdAt;
final DateTime updatedAt;

Product({
required this.id,
required this.name,
required this.barcode,
required this.categoryId,
required this.price,
required this.quantity,
required this.minQuantity,
this.description,
required this.createdAt,
required this.updatedAt,
});

bool get isLowStock => quantity <= minQuantity;

Map<String, dynamic> toMap() {
return {
'id': id,
'name': name,
'barcode': barcode,
'categoryId': categoryId,
'price': price,
'quantity': quantity,
'minQuantity': minQuantity,
'description': description,
'createdAt': createdAt.toIso8601String(),
'updatedAt': updatedAt.toIso8601String(),
};
}

factory Product.fromMap(Map<String, dynamic> map) {
return Product(
id: map['id'],
name: map['name'],
barcode: map['barcode'],
categoryId: map['categoryId'],
price: map['price'],
quantity: map['quantity'],
minQuantity: map['minQuantity'],
description: map['description'],
createdAt: DateTime.parse(map['createdAt']),
updatedAt: DateTime.parse(map['updatedAt']),
);
}

Product copyWith({
String? id,
String? name,
String? barcode,
String? categoryId,
double? price,
int? quantity,
int? minQuantity,
String? description,
DateTime? createdAt,
DateTime? updatedAt,
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
createdAt: createdAt ?? this.createdAt,
updatedAt: updatedAt ?? this.updatedAt,
);
}
}
