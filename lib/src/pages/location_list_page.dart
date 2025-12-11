import 'package:flutter/material.dart';
import 'package:mon_premier_projet/models/location.dart';

class LocationListPage extends StatelessWidget {
  final List<Location> locations;
  const LocationListPage({super.key, required this.locations});

  @override
  Widget build(BuildContext context) {
    return _LocationListPageContent(locations: locations);
  }
}

class _LocationListPageContent extends StatefulWidget {
  final List<Location> locations;
  const _LocationListPageContent({required this.locations});

  @override
  State<_LocationListPageContent> createState() =>
      _LocationListPageContentState();
}

class _LocationListPageContentState extends State<_LocationListPageContent> {
  String searchQuery = '';
  String selectedType = 'Tous';

  @override
  Widget build(BuildContext context) {
    final filteredLocations = widget.locations.where((location) {
      final matchesSearch = location.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesType =
          selectedType == 'Tous' || location.type == selectedType;
      return matchesSearch && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Emplacements')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un emplacement',
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
              items: <String>['Tous', 'magasin', 'entrepôt']
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
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
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                return ListTile(
                  title: Text(location.name),
                  subtitle: Text(location.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditLocationDialog(context, location);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteLocationDialog(context, location);
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
          _showAddLocationDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddLocationDialog(BuildContext context) {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un emplacement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom'),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Type'),
                controller: typeController,
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

  void _showEditLocationDialog(BuildContext context, Location location) {
    final nameController = TextEditingController(text: location.name);
    final typeController = TextEditingController(text: location.type);
    final addressController = TextEditingController(text: location.address);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier l\'emplacement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom'),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Type'),
                controller: typeController,
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

  void _showDeleteLocationDialog(BuildContext context, Location location) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer l\'emplacement'),
          content: Text('Voulez-vous vraiment supprimer ${location.name} ?'),
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
