import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stock_manager/models/product.dart';
import 'package:stock_manager/models/category.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';

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

  static Future<void> exportCustomReportToCSV(List<Product> products, List<String> selectedFields, List<Category> categories) async {
    List<List<dynamic>> rows = [];

    // En-têtes basés sur les champs sélectionnés
    List<String> headers = selectedFields.map((field) {
      switch (field) {
        case 'name': return 'Nom';
        case 'barcode': return 'Code-barres';
        case 'category': return 'Catégorie';
        case 'price': return 'Prix';
        case 'quantity': return 'Quantité';
        case 'minQuantity': return 'Stock minimum';
        case 'description': return 'Description';
        case 'createdAt': return 'Date création';
        case 'updatedAt': return 'Date modification';
        default: return field;
      }
    }).toList();
    rows.add(headers);

    // Données
    for (var product in products) {
      List<dynamic> row = [];
      for (var field in selectedFields) {
        switch (field) {
          case 'name':
            row.add(product.name);
            break;
          case 'barcode':
            row.add(product.barcode );
            break;
          case 'category':
            final category = categories.firstWhere(
              (cat) => cat.id == product.categoryId,
              orElse: () => Category(id: '', name: 'Unknown', createdAt: DateTime.now().toIso8601String(), updatedAt: DateTime.now().toIso8601String()),
            );
            row.add(category.name);
            break;
          case 'price':
            row.add(product.price);
            break;
          case 'quantity':
            row.add(product.quantity);
            break;
          case 'minQuantity':
            row.add(product.minQuantity);
            break;
          case 'description':
            row.add(product.description ?? '');
            break;
          case 'createdAt':
            row.add(DateFormat('dd/MM/yyyy').format(product.createdAt));
            break;
          case 'updatedAt':
            row.add(DateFormat('dd/MM/yyyy').format(product.updatedAt));
            break;
        }
      }
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    // Sauvegarder le fichier
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final path = '${directory.path}/custom_report_$timestamp.csv';
    final file = File(path);
    await file.writeAsString(csv);

    // Partager le fichier
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path)],
        text: 'Rapport personnalisé en date du ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
        subject: 'Rapport Stock Manager',
      ),
    );
  }

  static Future<void> exportCustomReportToPDF(List<Product> products, List<String> selectedFields, List<Category> categories) async {
    final pdf = pw.Document();

    // En-têtes
    List<String> headers = selectedFields.map((field) {
      switch (field) {
        case 'name': return 'Nom';
        case 'barcode': return 'Code-barres';
        case 'category': return 'Catégorie';
        case 'price': return 'Prix';
        case 'quantity': return 'Quantité';
        case 'minQuantity': return 'Stock minimum';
        case 'description': return 'Description';
        case 'createdAt': return 'Date création';
        case 'updatedAt': return 'Date modification';
        default: return field;
      }
    }).toList();

    // Données
    List<List<String>> data = [];
    for (var product in products) {
      List<String> row = [];
      for (var field in selectedFields) {
        switch (field) {
          case 'name':
            row.add(product.name);
            break;
          case 'barcode':
            row.add(product.barcode );
            break;
          case 'category':
            final category = categories.firstWhere(
              (cat) => cat.id == product.categoryId,
              orElse: () => Category(id: '', name: 'Unknown', createdAt: DateTime.now().toIso8601String(), updatedAt: DateTime.now().toIso8601String()),
            );
            row.add(category.name);
            break;
          case 'price':
            row.add(NumberFormat.currency(symbol: '€').format(product.price));
            break;
          case 'quantity':
            row.add(product.quantity.toString());
            break;
          case 'minQuantity':
            row.add(product.minQuantity.toString());
            break;
          case 'description':
            row.add(product.description ?? '');
            break;
          case 'createdAt':
            row.add(DateFormat('dd/MM/yyyy').format(product.createdAt));
            break;
          case 'updatedAt':
            row.add(DateFormat('dd/MM/yyyy').format(product.updatedAt));
            break;
        }
      }
      data.add(row);
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Rapport personnalisé', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: headers,
                data: data,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellHeight: 30,
                cellAlignments: {
                  for (int i = 0; i < headers.length; i++) i: pw.Alignment.centerLeft,
                },
              ),
            ],
          );
        },
      ),
    );

    // Sauvegarder le fichier
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final path = '${directory.path}/custom_report_$timestamp.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    // Partager le fichier
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path)],
        text: 'Rapport personnalisé en date du ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
        subject: 'Rapport Stock Manager',
      ),
    );
  }

  static Future<void> exportCustomReportToExcel(List<Product> products, List<String> selectedFields, List<Category> categories) async {
    var excel = Excel.createExcel();

    Sheet sheetObject = excel['Rapport'];

    // En-têtes
    List<String> headers = selectedFields.map((field) {
      switch (field) {
        case 'name': return 'Nom';
        case 'barcode': return 'Code-barres';
        case 'category': return 'Catégorie';
        case 'price': return 'Prix';
        case 'quantity': return 'Quantité';
        case 'minQuantity': return 'Stock minimum';
        case 'description': return 'Description';
        case 'createdAt': return 'Date création';
        case 'updatedAt': return 'Date modification';
        default: return field;
      }
    }).toList();

    // Ajouter les en-têtes
    for (int i = 0; i < headers.length; i++) {
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
    }

    // Données
    for (int rowIndex = 0; rowIndex < products.length; rowIndex++) {
      var product = products[rowIndex];
      for (int colIndex = 0; colIndex < selectedFields.length; colIndex++) {
        var field = selectedFields[colIndex];
        dynamic value;
        switch (field) {
          case 'name':
            value = product.name;
            break;
          case 'barcode':
            value = product.barcode;
            break;
          case 'category':
            final category = categories.firstWhere(
              (cat) => cat.id == product.categoryId,
              orElse: () => Category(id: '', name: 'Unknown', createdAt: DateTime.now().toIso8601String(), updatedAt: DateTime.now().toIso8601String()),
            );
            value = category.name;
            break;
          case 'price':
            value = product.price;
            break;
          case 'quantity':
            value = product.quantity;
            break;
          case 'minQuantity':
            value = product.minQuantity;
            break;
          case 'description':
            value = product.description ?? '';
            break;
          case 'createdAt':
            value = DateFormat('dd/MM/yyyy').format(product.createdAt);
            break;
          case 'updatedAt':
            value = DateFormat('dd/MM/yyyy').format(product.updatedAt);
            break;
        }
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex + 1)).value = TextCellValue(value.toString());
      }
    }

    // Sauvegarder le fichier
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final path = '${directory.path}/custom_report_$timestamp.xlsx';
    final file = File(path);
    await file.writeAsBytes(excel.encode()!);

    // Partager le fichier
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path)],
        text: 'Rapport personnalisé en date du ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
        subject: 'Rapport Stock Manager',
      ),
    );
  }
}
