class Variant {
  final String id;
  final String productId;
  final String name;
  final String value;
  final double? priceModifier;
  final int? stock;
  final String createdAt;
  final String updatedAt;

  Variant({
    required this.id,
    required this.productId,
    required this.name,
    required this.value,
    this.priceModifier,
    this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Variant.fromMap(Map<String, dynamic> map) => Variant(
    id: map['id'] as String,
    productId: map['productId'] as String,
    name: map['name'] as String,
    value: map['value'] as String,
    priceModifier: (map['priceModifier'] as num?)?.toDouble(),
    stock: map['stock'] as int?,
    createdAt: map['createdAt'] as String,
    updatedAt: map['updatedAt'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'name': name,
    'value': value,
    'priceModifier': priceModifier,
    'stock': stock,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  Variant copyWith({
    String? id,
    String? productId,
    String? name,
    String? value,
    double? priceModifier,
    int? stock,
    String? createdAt,
    String? updatedAt,
  }) {
    return Variant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      value: value ?? this.value,
      priceModifier: priceModifier ?? this.priceModifier,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
