import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();

    // Navigate to login screen after animation
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Correction 1: Ajout du Builder pour obtenir un contexte enfant valide
    return Builder(
      builder: (innerContext) {
        return Scaffold(
          // Correction 2: Utilisation de innerContext pour le thème de fond
          backgroundColor: Theme.of(innerContext).colorScheme.primary,
          body: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(51),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.inventory_2_rounded,
                        size: 60,
                        // Correction 2: Utilisation de innerContext pour la couleur de l'icône
                        color: Theme.of(innerContext).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Stock Manager',
                      // Correction 2: Utilisation de innerContext pour le style de texte
                      style: Theme.of(innerContext)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gestion professionnelle des stocks',
                      // Correction 2: Utilisation de innerContext pour le style de texte
                      style:
                          Theme.of(innerContext).textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withAlpha(204))
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          // Correction 3: Utilisation de withValues
                          Colors.white.withAlpha(204),
                        ),
                        strokeWidth: 3,
                      
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 
