import 'package:flutter_test/flutter_test.dart';
import 'package:mon_premier_projet/models/product.dart';

void main() {
  group('Product Model', () {
    test('toMap and fromMap should work correctly', () {
      final product = Product(
        id: '1',
        sku: 'SKU123',
        name: 'Produit Test',
        price: 10.5,
        stock: 5,
        storeId: 'store1',
        categoryId: 'cat1',
      );
      final map = product.toMap();
      final productFromMap = Product.fromMap('1', map);
      expect(productFromMap.id, product.id);
      expect(productFromMap.sku, product.sku);
      expect(productFromMap.name, product.name);
      expect(productFromMap.price, product.price);
      expect(productFromMap.stock, product.stock);
      expect(productFromMap.storeId, product.storeId);
      expect(productFromMap.categoryId, product.categoryId);
    });
  });
}
