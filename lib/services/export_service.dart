import 'dart:io';

import 'package:excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  static Future<void> exportProductsToPDF(
    List products,
    String filePath,
  ) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.ListView(
          children: products.map((p) => pw.Text(p.toString())).toList(),
        ),
      ),
    );
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }

  static void exportProductsToExcel(List products, String filePath) {
    final excel = Excel.createExcel();
    final sheet = excel['Produits'];
    sheet.appendRow([
      TextCellValue('Nom'),
      TextCellValue('SKU'),
      TextCellValue('Prix'),
      TextCellValue('Stock'),
    ]);
    for (var p in products) {
      sheet.appendRow([
        TextCellValue(p.name ?? ''),
        TextCellValue(p.sku ?? ''),
        TextCellValue(p.price?.toString() ?? '0'),
        TextCellValue(p.stock?.toString() ?? '0'),
      ]);
    }
    final file = File(filePath);
    file.writeAsBytesSync(excel.encode()!);
  }
}
