import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stock_manager/models/product.dart';
import 'package:intl/intl.dart';

class ExportHelper {
  static Future<void> exportToCSV(List<Product> products) async {
    List<List<dynamic>> rows = [];

    // En-têtes
    rows.add([
      'ID',
      'Nom',
      'Code-barres',
      'Catégorie',
      'Prix',
      'Quantité',
      'Stock minimum',
      'Description',
      'Date création',
      'Date modification',
    ]);

    // Données
    for (var product in products) {
      rows.add([
        product.id,
        product.name,
        product.barcode,
        product.category,
        product.price,
        product.quantity,
        product.minQuantity,
        product.description ?? '',
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(product.createdAt)),
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(product.updatedAt)),
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    // Sauvegarder le fichier
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final path = '${directory.path}/stock_export_$timestamp.csv';
    final file = File(path);
    await file.writeAsString(csv);

    // Partager le fichier
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path)],
        text: 'Export des données du stock en date du ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
        subject: 'Export Stock Manager',
      ),
    );
  }
}
