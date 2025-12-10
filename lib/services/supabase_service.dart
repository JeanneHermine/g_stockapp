import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://YOUR-PROJECT.supabase.co',
      anonKey: 'YOUR-ANON-KEY',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
