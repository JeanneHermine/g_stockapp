import 'package:flutter/material.dart';
// Utiliser un package comme 'barcode_scan2' pour le scan réel

class BarcodeService {
  static Future<String?> scanBarcode(BuildContext context) async {
    // Simulation d’un scan, à remplacer par l’appel au package réel
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Code-barres'),
        content: const Text('Simuler le scan d’un code-barres.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, '1234567890'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
