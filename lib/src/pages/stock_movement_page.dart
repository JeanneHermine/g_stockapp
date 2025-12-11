import 'package:flutter/material.dart';
import 'package:mon_premier_projet/models/stock_movement.dart';

class StockMovementPage extends StatelessWidget {
  final List<StockMovement> movements;

  const StockMovementPage({super.key, required this.movements});

  @override
  Widget build(BuildContext context) {
    return _StockMovementPageContent(movements: movements);
  }
}

class _StockMovementPageContent extends StatefulWidget {
  final List<StockMovement> movements;
  const _StockMovementPageContent({required this.movements});

  @override
  State<_StockMovementPageContent> createState() =>
      _StockMovementPageContentState();
}

class _StockMovementPageContentState extends State<_StockMovementPageContent> {
  String searchQuery = '';
  String selectedType = 'Tous';

  @override
  Widget build(BuildContext context) {
    final filteredMovements = widget.movements.where((movement) {
      final matchesSearch = movement.productId.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesType =
          selectedType == 'Tous' || movement.type == selectedType;
      return matchesSearch && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mouvements de stock')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher par produit',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: selectedType,
              items: <String>['Tous', 'in', 'out']
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type == 'in'
                            ? 'Entrée'
                            : type == 'out'
                            ? 'Sortie'
                            : 'Tous',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMovements.length,
              itemBuilder: (context, index) {
                final movement = filteredMovements[index];
                return ListTile(
                  title: Text(movement.type == 'in' ? 'Entrée' : 'Sortie'),
                  subtitle: Text(
                    'Produit: ${movement.productId} | Quantité: ${movement.quantity}',
                  ),
                  trailing: Text(movement.date.toString()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMovementDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ...existing code for dialogs...

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
