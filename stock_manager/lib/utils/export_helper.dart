import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stock_manager/models/product.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
        product.categoryId,
        product.price,
        product.quantity,
        product.minQuantity,
        product.description ?? '',
        DateFormat('dd/MM/yyyy HH:mm').format(product.createdAt),
        DateFormat('dd/MM/yyyy HH:mm').format(product.updatedAt),
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

  static Future<List<Product>?> importFromCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();
      final csvTable = const CsvToListConverter().convert(csvString);

      if (csvTable.isEmpty) return null;

      // Skip header row
      final dataRows = csvTable.skip(1);

      List<Product> products = [];
      final uuid = const Uuid();
      
      // Correction de l'erreur 95/96 : Utiliser un objet DateTime
      final now = DateTime.now(); 

      for (var row in dataRows) {
        if (row.length >= 7) {
          try {
            final product = Product(
              id: uuid.v4(),
              name: row[1].toString(),
              barcode: row[2].toString(),
              categoryId: row[3].toString(),
              price: double.tryParse(row[4].toString()) ?? 0.0,
              quantity: int.tryParse(row[5].toString()) ?? 0,
              minQuantity: int.tryParse(row[6].toString()) ?? 0,
              description: row.length > 7 ? row[7].toString() : null,
              createdAt: now, // Correction
              updatedAt: now, // Correction
            );
            products.add(product);
          } catch (e) {
            // Skip invalid rows
            continue;
          }
        }
      }

      return products;
    }

    return null;
  }
}