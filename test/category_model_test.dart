import 'package:flutter_test/flutter_test.dart';
import 'package:mon_premier_projet/models/category.dart';

void main() {
  group('Category Model', () {
    test('toMap and fromMap should work correctly', () {
      final category = Category(id: 'cat1', name: 'Catégorie Test');
      final map = category.toMap();
      final categoryFromMap = Category.fromMap(map);
      expect(categoryFromMap.id, category.id);
      expect(categoryFromMap.name, category.name);
    });
  });
}
