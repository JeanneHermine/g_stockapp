class ProductImage {
  final String id;
  final String productId;
  final String imagePath;
  final String? description;
  final bool isPrimary;
  final String createdAt;
  final String updatedAt;

  ProductImage({
    required this.id,
    required this.productId,
    required this.imagePath,
    this.description,
    this.isPrimary = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductImage.fromMap(Map<String, dynamic> map) => ProductImage(
    id: map['id'] as String,
    productId: map['productId'] as String,
    imagePath: map['imagePath'] as String,
    description: map['description'] as String?,
    isPrimary: (map['isPrimary'] as int) == 1,
    createdAt: map['createdAt'] as String,
    updatedAt: map['updatedAt'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'imagePath': imagePath,
    'description': description,
    'isPrimary': isPrimary ? 1 : 0,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  ProductImage copyWith({
    String? id,
    String? productId,
    String? imagePath,
    String? description,
    bool? isPrimary,
    String? createdAt,
    String? updatedAt,
  }) {
    return ProductImage(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
