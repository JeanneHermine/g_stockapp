import "package:flutter/material.dart";
import "package:stock_manager/database/database_helper.dart";
import "package:stock_manager/models/product.dart";
import "package:uuid/uuid.dart";

class ProductDetailScreen extends StatefulWidget {
final Product? product;

const ProductDetailScreen({super.key, this.product});

@override
State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
final _formKey = GlobalKey<FormState>();
late TextEditingController _nameController;
late TextEditingController _barcodeController;
late TextEditingController _priceController;
late TextEditingController _quantityController;
late TextEditingController _minQuantityController;
late TextEditingController _descriptionController;
String _selectedCategory = ‘Électronique’;
final List<String> _categories = [
‘Électronique’,
‘Vêtements’,
‘Chaussures’,
‘Accessoires’,
‘Alimentation’,
‘Beauté’,
‘Sports’,
‘Maison’,
‘Autre’,
];

@override
void initState() {
super.initState();
_nameController = TextEditingController(text: widget.product?.name);
_barcodeController = TextEditingController(text: widget.product?.barcode);
_priceController = TextEditingController(
text: widget.product?.price.toString() ?? ‘’,
);
_quantityController = TextEditingController(
text: widget.product?.quantity.toString() ?? ‘0’,
);
_minQuantityController = TextEditingController(
text: widget.product?.minQuantity.toString() ?? ‘5’,
);
_descriptionController = TextEditingController(
text: widget.product?.description,
);
if (widget.product != null) {
_selectedCategory = widget.product!.category;
}
}

@override
void dispose() {
_nameController.dispose();
_barcodeController.dispose();
_priceController.dispose();
_quantityController.dispose();
_minQuantityController.dispose();
_descriptionController.dispose();
super.dispose();
}

Future<void> _saveProduct() async {
if (!_formKey.currentState!.validate()) return;


final now = DateTime.now();
final product = Product(
  id: widget.product?.id ?? const Uuid().v4(),
  name: _nameController.text,
  barcode: _barcodeController.text,
  category: _selectedCategory,
  price: double.parse(_priceController.text),
  quantity: int.parse(_quantityController.text),
  minQuantity: int.parse(_minQuantityController.text),
  description: _descriptionController.text.isEmpty
      ? null
      : _descriptionController.text,
  createdAt: widget.product?.createdAt ?? now,
  updatedAt: now,
);

try {
  if (widget.product == null) {
    await DatabaseHelper.instance.createProduct(product);
  } else {
    await DatabaseHelper.instance.updateProduct(product);
  }

  if (mounted) {
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.product == null
              ? 'Produit ajouté avec succès'
              : 'Produit modifié avec succès',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
} catch (e) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Erreur lors de l\'enregistrement'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(
widget.product == null ? ‘Nouveau produit’ : ‘Modifier produit’,
),
actions: [
IconButton(
icon: const Icon(Icons.check),
onPressed: _saveProduct,
),
],
),
body: Form(
key: _formKey,
child: ListView(
padding: const EdgeInsets.all(16),
children: [
Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
‘Informations générales’,
style: Theme.of(context).textTheme.titleLarge,
),
const SizedBox(height: 16),
TextFormField(
controller: _nameController,
decoration: const InputDecoration(
labelText: ‘Nom du produit *’,
prefixIcon: Icon(Icons.shopping_bag),
),
validator: (value) {
if (value == null || value.isEmpty) {
return ‘Veuillez entrer un nom’;
}
return null;
},
),
const SizedBox(height: 16),
TextFormField(
controller: _barcodeController,
decoration: const InputDecoration(
labelText: ‘Code-barres *’,
prefixIcon: Icon(Icons.qr_code),
),
validator: (value) {
if (value == null || value.isEmpty) {
return ‘Veuillez entrer un code-barres’;
}
return null;
},
),
const SizedBox(height: 16),
DropdownButtonFormField<String>(
initialValue: _selectedCategory,
decoration: const InputDecoration(
labelText: ‘Catégorie’,
prefixIcon: Icon(Icons.category),
),
items: _categories.map((category) {
return DropdownMenuItem(
value: category,
child: Text(category),
);
}).toList(),
onChanged: (value) {
setState(() {
_selectedCategory = value!;
});
},
),
const SizedBox(height: 16),
TextFormField(
controller: _descriptionController,
decoration: const InputDecoration(
labelText: ‘Description’,
prefixIcon: Icon(Icons.description),
),
maxLines: 3,
),
],
),
),
),
const SizedBox(height: 16),
Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
‘Prix et stock’,
style: Theme.of(context).textTheme.titleLarge,
),
const SizedBox(height: 16),
TextFormField(
controller: _priceController,
decoration: const InputDecoration(
labelText: ‘Prix (€) *’,
prefixIcon: Icon(Icons.euro),
),
keyboardType: const TextInputType.numberWithOptions(
decimal: true,
),
validator: (value) {
if (value == null || value.isEmpty) {
return ‘Veuillez entrer un prix’;
}
if (double.tryParse(value) == null) {
return ‘Prix invalide’;
}
return null;
},
),
const SizedBox(height: 16),
TextFormField(
controller: _quantityController,
decoration: const InputDecoration(
labelText: ‘Quantité en stock *’,
prefixIcon: Icon(Icons.inventory),
),
keyboardType: TextInputType.number,
validator: (value) {
if (value == null || value.isEmpty) {
return ‘Veuillez entrer une quantité’;
}
if (int.tryParse(value) == null) {
return ‘Quantité invalide’;
}
return null;
},
),
const SizedBox(height: 16),
TextFormField(
controller: _minQuantityController,
decoration: const InputDecoration(
labelText: ‘Stock minimum *’,
prefixIcon: Icon(Icons.warning_amber),
helperText: ‘Alerte si stock inférieur à cette valeur’,
),
keyboardType: TextInputType.number,
validator: (value) {
if (value == null || value.isEmpty) {
return ‘Veuillez entrer un stock minimum’;
}
if (int.tryParse(value) == null) {
return ‘Valeur invalide’;
}
return null;
},
),
],
),
),
),
const SizedBox(height: 24),
ElevatedButton(
onPressed: _saveProduct,
style: ElevatedButton.styleFrom(
padding: const EdgeInsets.all(16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: Text(
widget.product == null ? ‘Ajouter le produit’ : ‘Enregistrer’,
style: const TextStyle(fontSize: 16),
),
),
],
),
),
);
}
}