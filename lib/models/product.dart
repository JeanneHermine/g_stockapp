class Product {
  final String id;
  final String sku;
  final String name;
  final double price;
  final int stock;
  final String storeId;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.stock,
    required this.storeId,
  });

  Map<String, dynamic> toMap() => {
    'sku': sku,
    'name': name,
    'price': price,
    'stock': stock,
    'storeId': storeId,
  };

  factory Product.fromMap(String id, Map<String, dynamic> m) => Product(
    id: id,
    sku: m['sku'],
    name: m['name'],
    price: (m['price'] as num).toDouble(),
    stock: m['stock'],
    storeId: m['storeId'],
  );
}
