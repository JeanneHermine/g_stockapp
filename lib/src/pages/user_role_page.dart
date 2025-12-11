import 'package:flutter/material.dart';

class UserRolePage extends StatelessWidget {
  final List<Map<String, String>> users;

  const UserRolePage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return _UserRolePageContent(users: users);
  }
}

class _UserRolePageContent extends StatefulWidget {
  final List<Map<String, String>> users;
  const _UserRolePageContent({required this.users});

  @override
  State<_UserRolePageContent> createState() => _UserRolePageContentState();
}

class _UserRolePageContentState extends State<_UserRolePageContent> {
  String searchQuery = '';
  String selectedRole = 'Tous';

  @override
  Widget build(BuildContext context) {
    final filteredUsers = widget.users.where((user) {
      final matchesSearch = (user['name'] ?? '').toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesRole =
          selectedRole == 'Tous' || (user['role'] ?? '') == selectedRole;
      return matchesSearch && matchesRole;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Utilisateurs & rôles')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un utilisateur',
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
              value: selectedRole,
              items: <String>['Tous', ..._getRoles(widget.users)]
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRole = value;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ListTile(
                  title: Text(user['name'] ?? ''),
                  subtitle: Text('Rôle: ${user['role'] ?? ''}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditRoleDialog(context, user);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<String> _getRoles(List<Map<String, String>> users) {
    final set = <String>{};
    for (var u in users) {
      if ((u['role'] ?? '').isNotEmpty) set.add(u['role']!);
    }
    return set.toList();
  }

  // ...existing code for dialogs...
  // ...existing code...

  void _showEditRoleDialog(BuildContext context, Map<String, String> user) {
    String role = user['role'] ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le rôle de ${user['name']}'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Rôle'),
            controller: TextEditingController(text: role),
            onChanged: (value) => role = value,
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

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un utilisateur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom'),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Rôle'),
                controller: roleController,
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
                // Utiliser nameController.text et roleController.text directement si besoin
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
