import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../services/supabase_service.dart';

class ProductRepositorySupabase {
  final SupabaseClient _c = SupabaseService.client;

  Future<List<Product>> byStore(String storeId) async {
    final res = await _c.from('products').select().eq('store_id', storeId);
    return (res as List).map((m) => Product.fromMap(m['id'], m)).toList();
  }

  Future<void> adjustStock(String id, int delta) async {
    await _c.rpc('adjust_stock', params: {'product_id': id, 'delta': delta});
  }
}
