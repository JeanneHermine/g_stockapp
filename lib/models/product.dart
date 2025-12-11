/// Modèle représentant un produit en stock
class Product {
  final String id;
  final String sku;
  final String name;
  final double price;
  final int stock;
  final String storeId;
  final String? categoryId;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.stock,
    required this.storeId,
    this.categoryId,
  });

  Map<String, dynamic> toMap() => {
    'sku': sku,
    'name': name,
    'price': price,
    'stock': stock,
    'storeId': storeId,
    'categoryId': categoryId,
  };

  factory Product.fromMap(String id, Map<String, dynamic> m) {
    // Utilisation de ?? pour fournir une valeur par défaut si la clé est manquante ou null.
    // Utilisation de 'as Type' pour garantir le type ou un cast.
    // Note : Nous forçons le type String, si la valeur est manquante ou null, on utilise '' (chaîne vide).
    final rawPrice = m['price'] ?? 0.0;
    final rawStock = m['stock'] ?? 0;

    return Product(
      id: id,
      sku: (m['sku'] as String?) ?? '', // Garantit String ou utilise ''
      name: (m['name'] as String?) ?? '', // Garantit String ou utilise ''
      // Le prix peut être int ou double dans JSON/Map, nous utilisons num pour la conversion sûre.
      price: (rawPrice as num).toDouble(),
      stock: (rawStock as int).toInt(), // Garantit int ou utilise 0
      storeId: (m['storeId'] as String?) ?? '', // Garantit String ou utilise ''
      categoryId: m['categoryId'] as String?, // Le type String? est conservé
    );
  }
}
