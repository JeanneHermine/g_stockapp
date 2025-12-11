import 'package:flutter/material.dart';
import 'package:mon_premier_projet/models/batch.dart';

class BatchListPage extends StatelessWidget {
  final List<Batch> batches;
  const BatchListPage({super.key, required this.batches});

  @override
  Widget build(BuildContext context) {
    return _BatchListPageContent(batches: batches);
  }
}

class _BatchListPageContent extends StatefulWidget {
  final List<Batch> batches;
  const _BatchListPageContent({required this.batches});

  @override
  State<_BatchListPageContent> createState() => _BatchListPageContentState();
}

class _BatchListPageContentState extends State<_BatchListPageContent> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredBatches = widget.batches.where((batch) {
      return batch.serialNumber.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Lots & Numéros de série')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un numéro de série',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBatches.length,
              itemBuilder: (context, index) {
                final batch = filteredBatches[index];
                return ListTile(
                  title: Text('Lot #${batch.id}'),
                  subtitle: Text(
                    'Produit: ${batch.productId} | Série: ${batch.serialNumber}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditBatchDialog(context, batch);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteBatchDialog(context, batch);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBatchDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBatchDialog(BuildContext context) {
    // Ajout logique métier ici
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un lot'),
          content: const Text('Formulaire à compléter...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBatchDialog(BuildContext context, Batch batch) {
    // Modification logique métier ici
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le lot'),
          content: const Text('Formulaire à compléter...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteBatchDialog(BuildContext context, Batch batch) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le lot'),
          content: Text('Voulez-vous vraiment supprimer le lot #${batch.id} ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
