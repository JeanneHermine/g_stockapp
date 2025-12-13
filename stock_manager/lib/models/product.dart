class Product {
final String id;
final String name;
final String barcode;
final String category;
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
required this.category,
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
'category': category,
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
category: map['category'],
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
String? category,
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
category: category ?? this.category,
price: price ?? this.price,
quantity: quantity ?? this.quantity,
minQuantity: minQuantity ?? this.minQuantity,
description: description ?? this.description,
createdAt: createdAt ?? this.createdAt,
updatedAt: updatedAt ?? this.updatedAt,
);
}
}

class StockMovement {
final String id;
final String productId;
final String productName;
final int quantityChange;
final String type; // ‘in’ or ‘out’
final String? reason;
final DateTime createdAt;

StockMovement({
required this.id,
required this.productId,
required this.productName,
required this.quantityChange,
required this.type,
this.reason,
required this.createdAt,
});

Map<String, dynamic> toMap() {
return {
'id': id,
'productId': productId,
'productName': productName,
'quantityChange': quantityChange,
'type': type,
'reason': reason,
'createdAt': createdAt.toIso8601String(),
};
}

factory StockMovement.fromMap(Map<String, dynamic> map) {
return StockMovement(
id: map['id'],
productId: map['productId'],
productName: map['productName'],
quantityChange: map['quantityChange'],
type: map['type'],
reason: map['reason'],
createdAt: DateTime.parse(map['createdAt']),
);
}
}