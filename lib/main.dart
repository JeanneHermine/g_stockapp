import 'package:flutter/material.dart';
import 'src/app.dart';
import 'services/supabase_service.dart';
import 'services/backend_selector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> testFirestore() async {
  final db = FirebaseFirestore.instance;
  await db.collection('products').add({
    'name': 'Test produit',
    'stock': 10,
    'price': 99.99,
  });
  print('Produit ajouté dans Firestore');
}

Future<void> _initBackend() async {
  try {
    // Utilise le sélecteur de backend pour choisir Firebase ou Supabase
    await BackendSelector.init();
  } catch (e) {
    // Gestion d'erreur basique : imprime l'erreur (à améliorer plus tard)
    print('Erreur lors de l\'initialisation du backend: $e');
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Bienvenue dans l\'app de gestion de stock'),
        ),
      ),
    );
  }
}
