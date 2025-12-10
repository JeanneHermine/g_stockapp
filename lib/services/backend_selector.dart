import 'firebase_service.dart';
import 'supabase_service.dart';

enum BackendType { firebase, supabase }

class BackendSelector {
  static const BackendType selected = BackendType.firebase; 
  // Change ici pour basculer entre Firebase et Supabase

  static Future<void> init() async {
    switch (selected) {
      case BackendType.firebase:
        await FirebaseService.init();
        break;
      case BackendType.supabase:
        await SupabaseService.init();
        break;
    }
  }
}
