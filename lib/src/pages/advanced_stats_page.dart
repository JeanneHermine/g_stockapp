import 'package:flutter/material.dart';

class AdvancedStatsPage extends StatelessWidget {
  final int totalSales;
  final int lowStockProducts;

  const AdvancedStatsPage({
    super.key,
    required this.totalSales,
    required this.lowStockProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques avancées')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ventes totales: $totalSales',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            'Produits en stock faible: $lowStockProducts',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              _showStatsDialog(context);
            },
            child: const Text('Voir détails'),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Détails des statistiques'),
          content: const Text('Statistiques détaillées à implémenter.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
