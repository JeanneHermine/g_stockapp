# Stock Manager

Application de gestion de stock pour boutiques développée avec Flutter.

## Fonctionnalités

- **Gestion des produits** : Ajout, modification et suppression de produits avec photos
- **Scan de codes-barres** : Ajout rapide de produits via caméra intégrée
- **Gestion du stock** : Suivi des quantités, seuils minimums et alertes automatiques
- **Gestion des ventes** : Enregistrement des transactions avec informations clients
- **Historique complet** : Traçabilité des mouvements de stock et ventes
- **Rapports et analyses** : Graphiques statistiques et export CSV/PDF
- **Notifications** : Alertes de stock faible et rappels
- **Interface moderne** : Thème sombre/clair avec Material Design 3

## Technologies utilisées

- **Flutter 3.0+** : Framework UI multiplateforme
- **Dart 3.0+** : Langage de programmation
- **SQLite** : Base de données locale robuste
- **Provider** : Gestion d'état réactive
- **Sqflite** : Interface SQLite pour Flutter
- **Mobile Scanner** : Scan de codes-barres
- **FL Chart** : Graphiques et visualisations
- **Flutter Local Notifications** : Notifications push

## Plateformes supportées

- Android (API 21+)
- iOS (11.0+)
- Windows (10+)
- macOS (10.14+)
- Linux (Ubuntu 18.04+)
- Web (Chrome, Firefox, Safari, Edge)

## Installation

### Prérequis

- Flutter SDK 3.0.0 ou supérieur
- Dart SDK inclus avec Flutter

### Étapes d'installation

1. **Cloner le repository**

   ```bash
   git clone <repository-url>
   cd stock_manager
   ```

2. **Installer les dépendances**

   ```bash
   flutter pub get
   ```

3. **Vérifier l'installation**

   ```bash
   flutter doctor
   ```

4. **Lancer l'application**

   ```bash
   flutter run
   ```

## Utilisation

1. **Premier démarrage** : Écran de chargement puis connexion
2. **Connexion** : Utiliser les identifiants par défaut (<manager@stockmanager.com> / manager123)
3. **Gestion des produits** : Ajouter/modifier des produits avec photos et codes-barres
4. **Suivi du stock** : Recevoir des alertes automatiques pour le réapprovisionnement
5. **Ventes** : Enregistrer les transactions clients avec historique complet
6. **Rapports** : Consulter les statistiques et exporter les données

## Structure du projet

lib/
├── main.dart                 # Point d'entrée de l'application
├── database/
│   └── database_helper.dart  # Gestionnaire de base de données SQLite
├── models/                   # Modèles de données (Product, Category, Sale, etc.)
├── providers/               # Gestion d'état avec Provider
├── screens/                 # Interfaces utilisateur
│   ├── splash_screen.dart   # Écran de démarrage
│   ├── login_screen.dart    # Connexion manager
│   ├── home_screen.dart     # Écran principal
│   ├── products_screen.dart # Gestion des produits
│   ├── sales_screen.dart    # Gestion des ventes
│   ├── statistics_screen.dart # Graphiques et analyses
│   ├── history_screen.dart  # Historique des mouvements
│   ├── alerts_screen.dart   # Alertes de stock
│   ├── barcode_scanner_screen.dart # Scanner de codes-barres
│   ├── custom_report_screen.dart   # Rapports personnalisés
│   └── product_detail_screen.dart  # Détails produit
├── services/                # Services utilitaires
│   └── notification_service.dart # Notifications push
└── utils/                   # Utilitaires
    └── export_helper.dart   # Export de données

## Déploiement

### Build pour production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Licence

MIT License
