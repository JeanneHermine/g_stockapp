import 'package:flutter/material.dart';
import 'package:mon_premier_projet/models/customer.dart';

class CustomerListPage extends StatelessWidget {
  final List<Customer> customers;
  const CustomerListPage({super.key, required this.customers});

  @override
  Widget build(BuildContext context) {
    return _CustomerListPageContent(customers: customers);
  }
}

class _CustomerListPageContent extends StatefulWidget {
  final List<Customer> customers;
  const _CustomerListPageContent({required this.customers});

  @override
  State<_CustomerListPageContent> createState() =>
      _CustomerListPageContentState();
}

class _CustomerListPageContentState extends State<_CustomerListPageContent> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = widget.customers.where((customer) {
      return customer.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un client',
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
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return ListTile(
                  title: Text(customer.name),
                  subtitle: Text(customer.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditCustomerDialog(context, customer);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteCustomerDialog(context, customer);
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
          _showAddCustomerDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un client'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom'),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Contact'),
                controller: contactController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: emailController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Adresse'),
                controller: addressController,
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
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _showEditCustomerDialog(BuildContext context, Customer customer) {
    final nameController = TextEditingController(text: customer.name);
    final contactController = TextEditingController(text: customer.contact);
    final emailController = TextEditingController(text: customer.email);
    final addressController = TextEditingController(text: customer.address);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le client'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom'),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Contact'),
                controller: contactController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: emailController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Adresse'),
                controller: addressController,
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
                // Modification logique métier ici
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCustomerDialog(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le client'),
          content: Text('Voulez-vous vraiment supprimer ${customer.name} ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Suppression logique métier ici
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
