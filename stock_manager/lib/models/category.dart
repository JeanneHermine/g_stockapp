class Category {
  final String id;
  final String name;
  final String? parentId;
  final String? description;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as String,
    name: map['name'] as String,
    parentId: map['parentId'] as String?,
    description: map['description'] as String?,
    createdAt: map['createdAt'] as String,
    updatedAt: map['updatedAt'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'parentId': parentId,
    'description': description,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  Category copyWith({
    String? id,
    String? name,
    String? parentId,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
