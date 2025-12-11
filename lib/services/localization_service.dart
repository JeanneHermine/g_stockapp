import 'package:flutter/material.dart';

class LocalizationService {
  static const supportedLocales = [Locale('fr'), Locale('en')];

  static String getTranslated(BuildContext context, String key) {
    // Exemple simplifié, à remplacer par une vraie gestion i18n
    final locale = Localizations.localeOf(context).languageCode;
    final translations = _translations[locale] ?? _translations['fr']!;
    return translations[key] ?? key;
  }

  static const Map<String, Map<String, String>> _translations = {
    'fr': {
      'products': 'Produits',
      'categories': 'Catégories',
      'stock': 'Stock',
      'users': 'Utilisateurs',
      'dashboard': 'Tableau de bord',
      'search': 'Rechercher',
    },
    'en': {
      'products': 'Products',
      'categories': 'Categories',
      'stock': 'Stock',
      'users': 'Users',
      'dashboard': 'Dashboard',
      'search': 'Search',
    },
  };
}
