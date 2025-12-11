import 'package:flutter/material.dart';
import 'package:mon_premier_projet/models/stock_movement.dart';

class StockMovementPage extends StatelessWidget {
  final List<StockMovement> movements;

  const StockMovementPage({super.key, required this.movements});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mouvements de stock')),
      body: ListView.builder(
        itemCount: movements.length,
        itemBuilder: (context, index) {
          final movement = movements[index];
          return ListTile(
            title: Text(movement.type == 'in' ? 'Entrée' : 'Sortie'),
            subtitle: Text(
              'Produit: ${movement.productId} | Quantité: ${movement.quantity}',
            ),
            trailing: Text(movement.date.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMovementDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMovementDialog(BuildContext context) {
    final productIdController = TextEditingController();
    final quantityController = TextEditingController();
    String type = 'in';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un mouvement de stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'ID Produit'),
                controller: productIdController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
                controller: quantityController,
              ),
              DropdownButton<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'in', child: Text('Entrée')),
                  DropdownMenuItem(value: 'out', child: Text('Sortie')),
                ],
                onChanged: (value) {
                  if (value != null) type = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Ajout logique métier ici
                final productId = productIdController.text;
                final quantity = quantityController.text;
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}
