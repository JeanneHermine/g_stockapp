import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
const BarcodeScannerScreen({super.key});

@override
State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
MobileScannerController cameraController = MobileScannerController();
bool _hasScanned = false;

@override
void dispose() {
cameraController.dispose();
super.dispose();
}

void _onDetect(BarcodeCapture capture) {
if (_hasScanned) return;


final List<Barcode> barcodes = capture.barcodes;
if (barcodes.isNotEmpty) {
  final barcode = barcodes.first;
  if (barcode.rawValue != null) {
    setState(() => _hasScanned = true);
    Navigator.pop(context, barcode.rawValue);
  }
}


}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Scanner le code-barres'),
actions: [
IconButton(
icon: const Icon(Icons.flash_off),
onPressed: () => cameraController.toggleTorch(),
),
IconButton(
icon: const Icon(Icons.cameraswitch),
onPressed: () => cameraController.switchCamera(),
),
],
),
body: Stack(
children: [
MobileScanner(
controller: cameraController,
onDetect: _onDetect,
),
Positioned(
bottom: 0,
left: 0,
right: 0,
child: Container(
color: Colors.black54,
padding: const EdgeInsets.all(16),
child: const Text(
'Placez le code-barres dans le cadre',
style: TextStyle(
color: Colors.white,
fontSize: 16,
),
textAlign: TextAlign.center,
),
),
),
Center(
child: Container(
width: 250,
height: 250,
decoration: BoxDecoration(
border: Border.all(color: Colors.green, width: 2),
borderRadius: BorderRadius.circular(12),
),
),
),
],
),
);
}
}