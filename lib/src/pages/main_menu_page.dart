import 'package:flutter/material.dart';
import 'package:mon_premier_projet/src/pages/advanced_stats_page.dart';
import 'package:mon_premier_projet/src/pages/auth_page.dart';
import 'package:mon_premier_projet/src/pages/category_list_page.dart';
import 'package:mon_premier_projet/src/pages/export_import_page.dart';
import 'package:mon_premier_projet/src/pages/notification_page.dart';
import 'package:mon_premier_projet/src/pages/product_list_page.dart';
import 'package:mon_premier_projet/src/pages/stock_movement_page.dart';
import 'package:mon_premier_projet/src/pages/user_role_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu principal')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Produits'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListPage(products: const []),
              ),
            ),
          ),
          ListTile(
            title: const Text('Catégories'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryListPage(categories: const []),
              ),
            ),
          ),
          ListTile(
            title: const Text('Mouvements de stock'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StockMovementPage(movements: const []),
              ),
            ),
          ),
          ListTile(
            title: const Text('Utilisateurs & rôles'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserRolePage(users: const [])),
            ),
          ),
          ListTile(
            title: const Text('Statistiques avancées'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AdvancedStatsPage(totalSales: 0, lowStockProducts: 0),
              ),
            ),
          ),
          ListTile(
            title: const Text('Authentification'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AuthPage()),
            ),
          ),
          ListTile(
            title: const Text('Export / Import des données'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExportImportPage()),
            ),
          ),
          ListTile(
            title: const Text('Notifications'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationPage(notifications: const []),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
