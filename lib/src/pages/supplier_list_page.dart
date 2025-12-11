import 'package:flutter/material.dart';
import 'package:mon_premier_projet/models/supplier.dart';

class SupplierListPage extends StatelessWidget {
  final List<Supplier> suppliers;
  const SupplierListPage({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    return _SupplierListPageContent(suppliers: suppliers);
  }
}

class _SupplierListPageContent extends StatefulWidget {
  final List<Supplier> suppliers;
  const _SupplierListPageContent({required this.suppliers});

  @override
  State<_SupplierListPageContent> createState() =>
      _SupplierListPageContentState();
}

class _SupplierListPageContentState extends State<_SupplierListPageContent> {
  String searchQuery = '';

  // Ajoute ici la logique de recherche, filtrage et gestion des dialogs pour les fournisseurs

  @override
  Widget build(BuildContext context) {
    // Ajoute ici la logique d'affichage de la liste des fournisseurs
    return Scaffold(
      appBar: AppBar(title: const Text('Fournisseurs')),
      body: Center(child: Text('Liste des fournisseurs à afficher ici')),
    );
  }
}
