import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_manager/database/database_helper.dart';
import 'package:stock_manager/models/sale.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Sale> _sales = [];
  List<Sale> _filteredSales = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();
  String? _selectedPeriod;
  DateTimeRange? _dateRange;

  final List<String> _periods = ['Aujourd\'hui', 'Cette semaine', 'Ce mois', 'Cette année', 'Tout'];

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSales() async {
    setState(() => _isLoading = true);
    try {
      final sales = await DatabaseHelper.instance.getAllSales();
      setState(() {
        _sales = sales;
        _filteredSales = sales;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterSales() {
    setState(() {
      _filteredSales = _sales.where((sale) {
        final matchesSearch = _searchController.text.isEmpty ||
            sale.customerName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            sale.productName.toLowerCase().contains(_searchController.text.toLowerCase());

        bool matchesPeriod = true;
        if (_selectedPeriod != null && _selectedPeriod != 'Tout') {
          final saleDate = DateTime.parse(sale.createdAt);
          final now = DateTime.now();

          switch (_selectedPeriod) {
            case 'Aujourd\'hui':
              matchesPeriod = saleDate.year == now.year &&
                  saleDate.month == now.month &&
                  saleDate.day == now.day;
              break;
            case 'Cette semaine':
              final weekStart = now.subtract(Duration(days: now.weekday - 1));
              matchesPeriod = saleDate.isAfter(weekStart.subtract(const Duration(days: 1)));
              break;
            case 'Ce mois':
              matchesPeriod = saleDate.year == now.year && saleDate.month == now.month;
              break;
            case 'Cette année':
              matchesPeriod = saleDate.year == now.year;
              break;
          }
        }

        bool matchesDateRange = true;
        if (_dateRange != null) {
          final saleDate = DateTime.parse(sale.createdAt);
          matchesDateRange = saleDate.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
              saleDate.isBefore(_dateRange!.end.add(const Duration(days: 1)));
        }

        return matchesSearch && matchesPeriod && matchesDateRange;
      }).toList();
    });
  }

  double _calculateTotalRevenue() {
    return _filteredSales.fold(0, (sum, sale) => sum + sale.totalPrice);
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _dateRange = picked;
        _selectedPeriod = null;
      });
      _filterSales();
    }
  }

  Future<void> _deleteSale(Sale sale) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer cette vente de ${sale.productName} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteSale(sale.id);
      _loadSales();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vente supprimée')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des ventes'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey.shade50, Colors.blueGrey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.blueGrey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade600,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.euro,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revenus totaux',
                        style: TextStyle(
                          color: Colors.blueGrey.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NumberFormat.currency(symbol: '€', decimalDigits: 2)
                            .format(_calculateTotalRevenue()),
                        style: TextStyle(
                          color: Colors.blueGrey.shade900,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade600,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    '${_filteredSales.length} vente${_filteredSales.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher par client ou produit...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterSales();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (value) => _filterSales(),
                ),
                const SizedBox(height: 12),

                // Period and Date Filters
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedPeriod,
                        decoration: InputDecoration(
                          labelText: 'Période',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                        ),
                        items: _periods.map((period) {
                          return DropdownMenuItem(
                            value: period,
                            child: Text(period),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPeriod = value;
                            _dateRange = null;
                          });
                          _filterSales();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filledTonal(
                      onPressed: _selectDateRange,
                      icon: const Icon(Icons.date_range),
                      tooltip: 'Sélectionner une période personnalisée',
                    ),
                  ],
                ),

                if (_dateRange != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          '${DateFormat('dd/MM/yyyy').format(_dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_dateRange!.end)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            setState(() => _dateRange = null);
                            _filterSales();
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Sales List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSales.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredSales.length,
                        itemBuilder: (context, index) {
                          final sale = _filteredSales[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.receipt,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                sale.productName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Client: ${sale.customerName}',
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
                                              NumberFormat.currency(symbol: '€', decimalDigits: 2)
                                                  .format(sale.totalPrice),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Text(
                                              '${sale.quantity} x ${NumberFormat.currency(symbol: '€', decimalDigits: 2).format(sale.unitPrice)}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.grey[500],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(sale.createdAt)),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (sale.customerPhone != null && sale.customerPhone!.isNotEmpty) ...[
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.phone,
                                            size: 16,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            sale.customerPhone!,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          onPressed: () => _deleteSale(sale),
                                          color: Colors.red,
                                          tooltip: 'Supprimer la vente',
                                        ),
                                      ],
                                    ),
                                    if (sale.notes != null && sale.notes!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.note,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                sale.notes!,
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
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
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune vente trouvée',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les ventes apparaîtront ici une fois effectuées',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
