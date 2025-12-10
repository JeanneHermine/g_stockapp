import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductRepositoryFirestore {
  final _col = FirebaseFirestore.instance.collection('products');

  Future<List<Product>> byStore(String storeId) async {
    final snap = await _col.where('storeId', isEqualTo: storeId).get();
    return snap.docs.map((d) => Product.fromMap(d.id, d.data())).toList();
  }

  Future<void> adjustStock(String id, int delta) async {
    await FirebaseFirestore.instance.runTransaction((t) async {
      final ref = _col.doc(id);
      final doc = await t.get(ref);
      final current = (doc['stock'] as int) + delta;
      t.update(ref, {'stock': current});
    });
  }
}
