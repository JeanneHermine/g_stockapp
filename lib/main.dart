import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/backend_selector.dart';

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
      home: Scaffold(
        appBar: AppBar(title: const Text('Rapport Stock')),
        body: FutureBuilder<int>(
          future: _getProductCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }
            return Center(
              child: Text(
                'Nombre total de produits en stock: ${snapshot.data ?? 0}',
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<int> _getProductCount() async {
  // Exemple: récupération du nombre de produits depuis Firestore
  final db = FirebaseFirestore.instance;
  final snapshot = await db.collection('products').get();
  return snapshot.docs.length;
}
