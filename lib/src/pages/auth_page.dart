import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  void _showLoginDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Connexion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                ),
                controller: usernameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                controller: passwordController,
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
              child: const Text('Connexion'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentification')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showLoginDialog(context),
          child: const Text('Se connecter'),
        ),
      ),
    );
  }
}
