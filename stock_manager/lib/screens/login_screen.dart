import 'package:flutter/material.dart' as material;
import 'package:stock_manager/database/database_helper.dart';
import 'package:stock_manager/screens/home_screen.dart';

class LoginScreen extends material.StatefulWidget {
  const LoginScreen({super.key});

  @override
  @override
  material.State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends material.State<LoginScreen> {
  final _formKey = material.GlobalKey<material.FormState>();
  final _emailController = material.TextEditingController();
  final _passwordController = material.TextEditingController();
  final _nameController = material.TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        final user = await DatabaseHelper.instance.loginUser(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        if (user != null) {
          material.Navigator.of(context).pushReplacement(
            material.MaterialPageRoute(
              builder: (context) => HomeScreen(userName: user['name']),
            ),
          );
        } else {
          _showError('Email ou mot de passe incorrect');
        }
      } else {
        await DatabaseHelper.instance.registerUser(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );

        if (!mounted) return;

        setState(() => _isLogin = true);
        _showSuccess('Compte créé avec succès !');
      }
    } catch (e) {
      _showError('Une erreur est survenue');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    material.ScaffoldMessenger.of(context).showSnackBar(
      material.SnackBar(
          content: material.Text(message),
          backgroundColor: material.Colors.red),
    );
  }

  void _showSuccess(String message) {
    material.ScaffoldMessenger.of(context).showSnackBar(
      material.SnackBar(
          content: material.Text(message),
          backgroundColor: material.Colors.green),
    );
  }

  @override
  material.Widget build(material.BuildContext context) {
    return material.Scaffold(
      body: material.Container(
        decoration: material.BoxDecoration(
          gradient: material.LinearGradient(
            begin: material.Alignment.topLeft,
            end: material.Alignment.bottomRight,
            colors: [
              material.Theme.of(context).colorScheme.primary,
              material.Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: material.SafeArea(
          child: material.Center(
            child: material.SingleChildScrollView(
              padding: const material.EdgeInsets.all(24),
              child: material.Card(
                elevation: 8,
                shape: material.RoundedRectangleBorder(
                  borderRadius: material.BorderRadius.circular(24),
                ),
                child: material.Padding(
                  padding: const material.EdgeInsets.all(32),
                  child: material.Form(
                    key: _formKey,
                    child: material.Column(
                      mainAxisSize: material.MainAxisSize.min,
                      children: [
                        material.Icon(
                          material.Icons.inventory_2_rounded,
                          size: 80,
                          color: material.Theme.of(context).colorScheme.primary,
                        ),
                        const material.SizedBox(height: 24),
                        material.Text(
                          'Stock Manager',
                          style: material.Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: material.FontWeight.bold),
                        ),
                        const material.SizedBox(height: 8),
                        material.Text(
                          _isLogin ? 'Connexion' : 'Créer un compte',
                          style: material.Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: material.Colors.grey[600]),
                        ),
                        const material.SizedBox(height: 32),
                        if (!_isLogin)
                          material.TextFormField(
                            controller: _nameController,
                            decoration: const material.InputDecoration(
                              labelText: 'Nom complet',
                              prefixIcon: material.Icon(material.Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              return null;
                            },
                          ),
                        if (!_isLogin) const material.SizedBox(height: 16),
                        material.TextFormField(
                          controller: _emailController,
                          decoration: const material.InputDecoration(
                            labelText: 'Email',
                            prefixIcon: material.Icon(material.Icons.email),
                          ),
                          keyboardType: material.TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            if (!value.contains('@')) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),
                        const material.SizedBox(height: 16),
                        material.TextFormField(
                          controller: _passwordController,
                          decoration: material.InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon:
                                const material.Icon(material.Icons.lock),
                            suffixIcon: material.IconButton(
                              icon: material.Icon(
                                _obscurePassword
                                    ? material.Icons.visibility_off
                                    : material.Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                        const material.SizedBox(height: 24),
                        material.SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: material.ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: material.ElevatedButton.styleFrom(
                              shape: material.RoundedRectangleBorder(
                                borderRadius:
                                    material.BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const material.SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: material.CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : material.Text(
                                    _isLogin ? 'Se connecter' : "S'inscrire",
                                    style:
                                        const material.TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                        const material.SizedBox(height: 16),
                        material.TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: material.Text(
                            _isLogin
                                ? "Pas de compte ? S'inscrire"
                                : "Déjà un compte ? Se connecter",
                          ),
                        ),
                        const material.SizedBox(height: 16),
                        material.Container(
                          padding: const material.EdgeInsets.all(12),
                          decoration: material.BoxDecoration(
                            color: material.Colors.blue[50],
                            borderRadius: material.BorderRadius.circular(8),
                          ),
                          child: material.Column(
                            children: [
                              const material.Text(
                                '🎯 Compte de démonstration',
                                style: material.TextStyle(
                                    fontWeight: material.FontWeight.bold),
                              ),
                              const material.SizedBox(height: 8),
                              material.Text(
                                'Email: demo@stockmanager.com',
                                style: material.TextStyle(
                                    color: material.Colors.grey[700]),
                              ),
                              material.Text(
                                'Mot de passe: demo123',
                                style: material.TextStyle(
                                    color: material.Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
