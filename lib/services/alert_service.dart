import 'package:flutter/material.dart';

class AlertService {
  static void showStockLowAlert(
    BuildContext context,
    String productName,
    int stock,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alerte Stock Faible'),
        content: Text(
          'Le stock du produit "$productName" est faible ($stock restant).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showExpirationAlert(
    BuildContext context,
    String productName,
    DateTime expirationDate,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alerte Expiration'),
        content: Text(
          'Le produit "$productName" expire le ${expirationDate.toLocal()}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
