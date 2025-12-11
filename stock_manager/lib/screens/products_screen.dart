import ‘package:flutter/material.dart’;
import ‘package:intl/intl.dart’;
import ‘package:stock_manager/database/database_helper.dart’;
import ‘package:stock_manager/models/product.dart’;
import ‘package:stock_manager/screens/product_detail_screen.dart’;
import ‘package:stock_manager/screens/barcode_scanner_screen.dart’;
import ‘package:stock_manager/utils/export_helper.dart’;

class ProductsScreen extends StatefulWidget {
const ProductsScreen({super.key});

@override
State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
List<Product> _products = [];
List<Product> _filteredProducts = [];
List<String> _categories = [];
String? _selectedCategory;
final _searchController = TextEditingController();
bool _isLoading = true;

@override
void initState() {
super.initState();
_loadData();
}

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

Future<void> _loadData() async {
setState(() => _isLoading = true);
try {
final products = await DatabaseHelper.instance.getAllProducts();
final categories = await DatabaseHelper.instance.getCategories();
setState(() {
_products = products;
_filteredProducts = products;
_categories = categories;
_isLoading = false;
});
} catch (e) {
setState(() => _isLoading = false);
}
}

void _filterProducts() {
setState(() {
_filteredProducts = _products.where((product) {
final matchesSearch = _searchController.text.isEmpty ||
product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
product.barcode.contains(_searchController.text);
final matchesCategory = _selectedCategory == null ||
product.category == _selectedCategory;
return matchesSearch && matchesCategory;
}).toList();
});
}

Future<void> _updateQuantity(Product product, int change) async {
final newQuantity = product.quantity + change;
if (newQuantity < 0) return;


final updatedProduct = product.copyWith(
  quantity: newQuantity,
  updatedAt: DateTime.now(),
);

await DatabaseHelper.instance.updateProduct(updatedProduct);
await DatabaseHelper.instance.createStockMovement(
  StockMovement(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    productId: product.id,
    productName: product.name,
    quantityChange: change.abs(),
    type: change > 0 ? 'in' : 'out',
    reason: 'Ajustement manuel',
    createdAt: DateTime.now(),
  ),
);

_loadData();


}

Future<void> _deleteProduct(Product product) async {
final confirmed = await showDialog<bool>(
context: context,
builder: (context) => AlertDialog(
title: const Text(‘Confirmer la suppression’),
content: Text(‘Voulez-vous vraiment supprimer “${product.name}” ?’),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: const Text(‘Annuler’),
),
TextButton(
onPressed: () => Navigator.pop(context, true),
style: TextButton.styleFrom(foregroundColor: Colors.red),
child: const Text(‘Supprimer’),
),
],
),
);


if (confirmed == true) {
  await DatabaseHelper.instance.deleteProduct(product.id);
  _loadData();
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} supprimé')),
    );
  }
}


}

Future<void> _exportData() async {
try {
await ExportHelper.exportToCSV(_products);
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(‘Données exportées avec succès’),
backgroundColor: Colors.green,
),
);
}
} catch (e) {
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(‘Erreur lors de l'export’),
backgroundColor: Colors.red,
),
);
}
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: Column(
children: [
_buildSearchBar(),
_buildCategoryFilter(),
Expanded(
child: _isLoading
? const Center(child: CircularProgressIndicator())
: _filteredProducts.isEmpty
? _buildEmptyState()
: _buildProductList(),
),
],
),
floatingActionButton: Column(
mainAxisAlignment: MainAxisAlignment.end,
children: [
FloatingActionButton(
heroTag: ‘scan’,
onPressed: () async {
final barcode = await Navigator.push<String>(
context,
MaterialPageRoute(
builder: (context) => const BarcodeScannerScreen(),
),
);
if (barcode != null) {
_searchController.text = barcode;
_filterProducts();
}
},
child: const Icon(Icons.qr_code_scanner),
),
const SizedBox(height: 12),
FloatingActionButton(
heroTag: ‘export’,
onPressed: _exportData,
child: const Icon(Icons.file_download),
),
const SizedBox(height: 12),
FloatingActionButton(
heroTag: ‘add’,
onPressed: () async {
await Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const ProductDetailScreen(),
),
);
_loadData();
},
child: const Icon(Icons.add),
),
],
),
);
}

Widget _buildSearchBar() {
return Padding(
padding: const EdgeInsets.all(16),
child: TextField(
controller: _searchController,
decoration: InputDecoration(
hintText: ‘Rechercher par nom ou code-barres…’,
prefixIcon: const Icon(Icons.search),
suffixIcon: _searchController.text.isNotEmpty
? IconButton(
icon: const Icon(Icons.clear),
onPressed: () {
_searchController.clear();
_filterProducts();
},
)
: null,
),
onChanged: (value) => _filterProducts(),
),
);
}

Widget _buildCategoryFilter() {
return SizedBox(
height: 50,
child: ListView(
scrollDirection: Axis.horizontal,
padding: const EdgeInsets.symmetric(horizontal: 16),
children: [
FilterChip(
label: const Text(‘Tous’),
selected: _selectedCategory == null,
onSelected: (selected) {
setState(() {
_selectedCategory = null;
_filterProducts();
});
},
),
const SizedBox(width: 8),
…_categories.map((category) {
return Padding(
padding: const EdgeInsets.only(right: 8),
child: FilterChip(
label: Text(category),
selected: _selectedCategory == category,
onSelected: (selected) {
setState(() {
_selectedCategory = selected ? category : null;
_filterProducts();
});
},
),
);
}),
],
),
);
}

Widget _buildEmptyState() {
return Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.inventory_2_outlined,
size: 80,
color: Colors.grey[400],
),
const SizedBox(height: 16),
Text(
‘Aucun produit trouvé’,
style: TextStyle(
fontSize: 18,
color: Colors.grey[600],
),
),
],
),
);
}

Widget _buildProductList() {
return ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: _filteredProducts.length,
itemBuilder: (context, index) {
final product = _filteredProducts[index];
return Card(
margin: const EdgeInsets.only(bottom: 12),
child: InkWell(
onTap: () async {
await Navigator.push(
context,
MaterialPageRoute(
builder: (context) => ProductDetailScreen(product: product),
),
);
_loadData();
},
borderRadius: BorderRadius.circular(16),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
width: 50,
height: 50,
decoration: BoxDecoration(
color: Theme.of(context).colorScheme.primaryContainer,
borderRadius: BorderRadius.circular(12),
),
child: Icon(
Icons.shopping_bag,
color: Theme.of(context).colorScheme.primary,
),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
product.name,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 4),
Text(
product.category,
style: TextStyle(
color: Colors.grey[600],
fontSize: 14,
),
),
],
),
),
Column(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text(
NumberFormat.currency(
symbol: ‘€’,
decimalDigits: 2,
).format(product.price),
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
if (product.isLowStock)
Container(
padding: const EdgeInsets.symmetric(
horizontal: 8,
vertical: 4,
),
decoration: BoxDecoration(
color: Colors.red[100],
borderRadius: BorderRadius.circular(8),
),
child: const Text(
‘Stock faible’,
style: TextStyle(
color: Colors.red,
fontSize: 12,
),
),
),
],
),
],
),
const SizedBox(height: 12),
Row(
children: [
Expanded(
child: Text(
‘Stock: ${product.quantity}’,
style: TextStyle(
color: product.isLowStock ? Colors.red : Colors.grey[700],
fontWeight: FontWeight.w500,
),
),
),
IconButton(
icon: const Icon(Icons.remove_circle_outline),
onPressed: () => _updateQuantity(product, -1),
color: Colors.red,
),
IconButton(
icon: const Icon(Icons.add_circle_outline),
onPressed: () => _updateQuantity(product, 1),
color: Colors.green,
),
IconButton(
icon: const Icon(Icons.delete_outline),
onPressed: () => _deleteProduct(product),
color: Colors.grey,
),
],
),
],
),
),
),
);
},
);
}
}