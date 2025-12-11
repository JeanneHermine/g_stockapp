import 'package:flutter/material.dart';
import 'package:mon_premier_projet/models/invoice.dart';

class InvoiceListPage extends StatelessWidget {
  final List<Invoice> invoices;
  const InvoiceListPage({super.key, required this.invoices});

  @override
  Widget build(BuildContext context) {
    return _InvoiceListPageContent(invoices: invoices);
  }
}

class _InvoiceListPageContent extends StatefulWidget {
  final List<Invoice> invoices;
  const _InvoiceListPageContent({required this.invoices});

  @override
  State<_InvoiceListPageContent> createState() =>
      _InvoiceListPageContentState();
}

class _InvoiceListPageContentState extends State<_InvoiceListPageContent> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredInvoices = widget.invoices.where((invoice) {
      return invoice.id.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Factures')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher une facture',
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
              itemCount: filteredInvoices.length,
              itemBuilder: (context, index) {
                final invoice = filteredInvoices[index];
                return ListTile(
                  title: Text('Facture #${invoice.id}'),
                  subtitle: Text('Total: ${invoice.total} €'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditInvoiceDialog(context, invoice);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteInvoiceDialog(context, invoice);
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
          _showAddInvoiceDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddInvoiceDialog(BuildContext context) {
    // Ajout logique métier ici
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter une facture'),
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

  void _showEditInvoiceDialog(BuildContext context, Invoice invoice) {
    // Modification logique métier ici
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier la facture'),
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

  void _showDeleteInvoiceDialog(BuildContext context, Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la facture'),
          content: Text(
            'Voulez-vous vraiment supprimer la facture #${invoice.id} ?',
          ),
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
