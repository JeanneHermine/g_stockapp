import 'package:flutter/material.dart';
import 'package:stock_manager/database/database_helper.dart';
import 'package:stock_manager/models/product.dart';
import 'package:stock_manager/models/category.dart';
import 'package:stock_manager/utils/export_helper.dart';
import 'package:intl/intl.dart';

class CustomReportScreen extends StatefulWidget {
  const CustomReportScreen({super.key});

  @override
  State<CustomReportScreen> createState() => _CustomReportScreenState();
}

class _CustomReportScreenState extends State<CustomReportScreen> {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  // Report configuration
  final List<String> _selectedFields = ['name', 'quantity', 'price'];
  final List<String> _selectedCategories = [];
  String _sortBy = 'name';
  bool _ascending = true;
  double _minPrice = 0;
  double _maxPrice = 1000;
  int _minQuantity = 0;
  int _maxQuantity = 1000;

  final List<Map<String, String>> _availableFields = [
    {'key': 'name', 'label': 'Nom du produit'},
    {'key': 'barcode', 'label': 'Code-barres'},
    {'key': 'category', 'label': 'Catégorie'},
    {'key': 'price', 'label': 'Prix'},
    {'key': 'quantity', 'label': 'Quantité'},
    {'key': 'minQuantity', 'label': 'Stock minimum'},
    {'key': 'description', 'label': 'Description'},
    {'key': 'createdAt', 'label': 'Date création'},
    {'key': 'updatedAt', 'label': 'Date modification'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final products = await DatabaseHelper.instance.getAllProducts();
    final categories = await DatabaseHelper.instance.getCategories();
    setState(() {
      _products = products;
      _categories = categories;
      _isLoading = false;
    });
  }

  List<Product> _getFilteredProducts() {
    return _products.where((product) {
      final categoryName = _categories
          .firstWhere(
            (cat) => cat.id == product.categoryId,
            // FIX: Paramètres 'createdAt' et 'updatedAt' manquants/invalides
            orElse: () => Category(
                id: '',
                name: 'Unknown',
                createdAt: '2000-01-01T00:00:00Z',
                updatedAt: '2000-01-01T00:00:00Z'),
          )
          .name;

      final matchesCategory = _selectedCategories.isEmpty ||
          _selectedCategories.contains(categoryName);
      final matchesPrice =
          product.price >= _minPrice && product.price <= _maxPrice;
      final matchesQuantity =
          product.quantity >= _minQuantity && product.quantity <= _maxQuantity;

      return matchesCategory && matchesPrice && matchesQuantity;
    }).toList()
      ..sort((a, b) {
        dynamic aValue, bValue;
        switch (_sortBy) {
          case 'name':
            aValue = a.name;
            bValue = b.name;
            break;
          case 'price':
            aValue = a.price;
            bValue = b.price;
            break;
          case 'quantity':
            aValue = a.quantity;
            bValue = b.quantity;
            break;
          case 'category':
            final aCat = _categories
                .firstWhere((cat) => cat.id == a.categoryId,
                    // FIX: Paramètres 'createdAt' et 'updatedAt' manquants/invalides
                    orElse: () => Category(
                        id: '',
                        name: 'Unknown',
                        createdAt: '2000-01-01T00:00:00Z',
                        updatedAt: '2000-01-01T00:00:00Z'))
                .name;
            final bCat = _categories
                .firstWhere((cat) => cat.id == b.categoryId,
                    // FIX: Paramètres 'createdAt' et 'updatedAt' manquants/invalides
                    orElse: () => Category(
                        id: '',
                        name: 'Unknown',
                        createdAt: '2000-01-01T00:00:00Z',
                        updatedAt: '2000-01-01T00:00:00Z'))
                .name;
            aValue = aCat;
            bValue = bCat;
            break;
          default:
            aValue = a.name;
            bValue = b.name;
        }
        return _ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      });
  }

  void _showFieldSelector() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Sélectionner les champs'),
          content: SingleChildScrollView(
            child: Column(
              children: _availableFields.map((field) {
                return CheckboxListTile(
                  title: Text(field['label']!),
                  value: _selectedFields.contains(field['key']),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedFields.add(field['key']!);
                      } else {
                        _selectedFields.remove(field['key']);
                      }
                    });
                    this.setState(() {});
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filtres'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Categories
                const Text('Catégories:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: _categories.map((category) {
                    return FilterChip(
                      label: Text(category.name),
                      selected: _selectedCategories.contains(category.name),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategories.add(category.name);
                          } else {
                            _selectedCategories.remove(category.name);
                          }
                        });
                        this.setState(() {});
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Price range
                Text(
                    'Prix: ${_minPrice.toStringAsFixed(0)}€ - ${_maxPrice.toStringAsFixed(0)}€'),
                RangeSlider(
                  values: RangeValues(_minPrice, _maxPrice),
                  min: 0,
                  max: 1000,
                  divisions: 100,
                  onChanged: (values) {
                    setState(() {
                      _minPrice = values.start;
                      _maxPrice = values.end;
                    });
                    this.setState(() {});
                  },
                ),
                // Quantity range
                Text('Quantité: $_minQuantity - $_maxQuantity'),
                RangeSlider(
                  values: RangeValues(
                      _minQuantity.toDouble(), _maxQuantity.toDouble()),
                  min: 0,
                  max: 1000,
                  divisions: 100,
                  onChanged: (values) {
                    setState(() {
                      _minQuantity = values.start.toInt();
                      _maxQuantity = values.end.toInt();
                    });
                    this.setState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCategories.clear();
                  _minPrice = 0;
                  _maxPrice = 1000;
                  _minQuantity = 0;
                  _maxQuantity = 1000;
                });
                this.setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Réinitialiser'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Trier par'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _sortBy,
                items: const [
                  DropdownMenuItem(value: 'name', child: Text('Nom')),
                  DropdownMenuItem(value: 'price', child: Text('Prix')),
                  DropdownMenuItem(value: 'quantity', child: Text('Quantité')),
                  DropdownMenuItem(value: 'category', child: Text('Catégorie')),
                ],
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  this.setState(() {});
                },
              ),
              // FIX: Remplacement des widgets Radio simples par RadioListTile pour éviter la dépréciation
              // ignore_for_file: deprecated_member_use
              RadioListTile<bool>(
                title: const Text('Croissant'),
                value: true,
                groupValue: _ascending,
                onChanged: (bool? value) {
                  // Accepter explicitement le type nullable (bool?)
                  if (value != null) {
                    setState(() => _ascending =
                        value); // Vérifier qu'il n'est pas null avant l'affectation
                  }
                  this.setState(() {});
                },
              ),
              RadioListTile<bool>(
                title: const Text('Décroissant'),
                value: false,
                groupValue: _ascending,
                onChanged: (bool? value) {
                  // Accepter explicitement le type nullable (bool?)
                  if (value != null) {
                    setState(() => _ascending =
                        value); // Vérifier qu'il n'est pas null avant l'affectation
                  }
                  this.setState(() {});
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportReport(String format) async {
    final filteredProducts = _getFilteredProducts();

    if (filteredProducts.isEmpty) {
      // FIX: Ne pas utiliser context après l'appel à showSnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun produit à exporter')),
      );
      return;
    }

    try {
      switch (format) {
        case 'csv':
          // ERREUR PERSISTANTE : La méthode doit être ajoutée dans ExportHelper
          await ExportHelper.exportCustomReportToCSV(
              filteredProducts, _selectedFields, _categories);
          break;
        case 'pdf':
          // ERREUR PERSISTANTE : La méthode doit être ajoutée dans ExportHelper
          await ExportHelper.exportCustomReportToPDF(
              filteredProducts, _selectedFields, _categories);
          break;
        case 'excel':
          // ERREUR PERSISTANTE : La méthode doit être ajoutée dans ExportHelper
          await ExportHelper.exportCustomReportToExcel(
              filteredProducts, _selectedFields, _categories);
          break;
      }

      // FIX: Utiliser mounted avant d'utiliser context
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rapport exporté au format $format')),
      );
    } catch (e) {
      // FIX: Utiliser mounted avant d'utiliser context
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'export: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créateur de rapports personnalisés'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _exportReport,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'csv', child: Text('Exporter en CSV')),
              const PopupMenuItem(value: 'pdf', child: Text('Exporter en PDF')),
              const PopupMenuItem(
                  value: 'excel', child: Text('Exporter en Excel')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Configuration bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${filteredProducts.length} produit(s) trouvé(s)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showFieldSelector,
                  icon: const Icon(Icons.view_column),
                  label: const Text('Champs'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filtres'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _showSortDialog,
                  icon: const Icon(Icons.sort),
                  label: const Text('Trier'),
                ),
              ],
            ),
          ),
          // Data table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: _selectedFields.map((field) {
                    final fieldInfo = _availableFields.firstWhere(
                      (f) => f['key'] == field,
                      orElse: () => {'label': field},
                    );
                    return DataColumn(
                      label: Text(fieldInfo['label']!),
                    );
                  }).toList(),
                  rows: filteredProducts.map((product) {
                    return DataRow(
                      cells: _selectedFields.map((field) {
                        String value = '';
                        switch (field) {
                          case 'name':
                            value = product.name;
                            break;
                          case 'barcode':
                            // Suppose barcode est String non-nullable ou gère le null dans le modèle
                            value = product.barcode;
                            break;
                          case 'category':
                            value = _categories
                                .firstWhere(
                                  (cat) => cat.id == product.categoryId,
                                  // FIX: Paramètres 'createdAt' et 'updatedAt' manquants/invalides
                                  orElse: () => Category(
                                      id: '',
                                      name: 'Unknown',
                                      createdAt: '2000-01-01T00:00:00Z',
                                      updatedAt: '2000-01-01T00:00:00Z'),
                                )
                                .name;
                            break;
                          case 'price':
                            value = NumberFormat.currency(symbol: '€')
                                .format(product.price);
                            break;
                          case 'quantity':
                            value = product.quantity.toString();
                            break;
                          case 'minQuantity':
                            value = product.minQuantity.toString();
                            break;
                          case 'description':
                            value = product.description ?? '';
                            break;
                          case 'createdAt':
                            value = DateFormat('dd/MM/yyyy')
                                .format(product.createdAt);
                            break;
                          case 'updatedAt':
                            value = DateFormat('dd/MM/yyyy')
                                .format(product.updatedAt);
                            break;
                        }
                        return DataCell(Text(value));
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
