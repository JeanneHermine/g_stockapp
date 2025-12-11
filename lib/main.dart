import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/backend_selector.dart';
import 'src/pages/advanced_stats_page.dart';
import 'src/pages/auth_page.dart';
import 'src/pages/category_list_page.dart';
import 'src/pages/export_import_page.dart';
import 'src/pages/main_menu_page.dart';
import 'src/pages/notification_page.dart';
import 'src/pages/product_list_page.dart';
import 'src/pages/stock_movement_page.dart';
import 'src/pages/user_role_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> testFirestore() async {
  final db = FirebaseFirestore.instance;
  await db.collection('products').add({
    'name': 'Test produit',
    'stock': 10,
    'price': 99.99,
  });
  // Produit ajouté dans Firestore (log)
}

Future<void> _initBackend() async {
  try {
    // Utilise le sélecteur de backend pour choisir Firebase ou Supabase
    await BackendSelector.init();
  } catch (e) {
    // Affiche une boîte de dialogue en cas d'erreur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Erreur Backend'),
          content: Text('Erreur lors de l\'initialisation du backend: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initBackend();
  runApp(const StockApp());
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock App',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainMenuPage(),
      routes: {
        '/products': (context) => ProductListPage(products: const []),
        '/categories': (context) => CategoryListPage(categories: const []),
        '/movements': (context) => StockMovementPage(movements: const []),
        '/users': (context) => UserRolePage(users: const []),
        '/stats': (context) =>
            AdvancedStatsPage(totalSales: 0, lowStockProducts: 0),
        '/auth': (context) => const AuthPage(),
        '/export': (context) => const ExportImportPage(),
        '/notifications': (context) =>
            NotificationPage(notifications: const []),
      },
    );
  }
}
