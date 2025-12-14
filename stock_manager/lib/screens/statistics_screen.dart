import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:stock_manager/database/database_helper.dart';
import 'package:stock_manager/models/product.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  List<Product> _products = [];
  Map<String, String> _categoryMap = {};
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final products = await DatabaseHelper.instance.getAllProducts();
    final categories = await DatabaseHelper.instance.getCategories();
    final categoryMap = {for (var cat in categories) cat.id: cat.name};
    setState(() {
      _products = products;
      _categoryMap = categoryMap;
      _isLoading = false;
    });
    _animationController.forward(from: 0.0);
  }

  Map<String, int> _getCategoryCounts() {
    final Map<String, int> counts = {};
    for (var product in _products) {
      final categoryName = _categoryMap[product.categoryId] ?? 'Unknown';
      counts[categoryName] = (counts[categoryName] ?? 0) + 1;
    }
    return counts;
  }

  Map<String, double> _getCategoryValues() {
    final Map<String, double> values = {};
    for (var product in _products) {
      final categoryName = _categoryMap[product.categoryId] ?? 'Unknown';
      values[categoryName] =
          (values[categoryName] ?? 0) + (product.price * product.quantity);
    }
    return values;
  }

  double _getTotalValue() {
    return _products.fold(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }

  int _getTotalProducts() {
    return _products.length;
  }

  int _getTotalQuantity() {
    return _products.fold(0, (sum, product) => sum + product.quantity);
  }

  int _getLowStockCount() {
    return _products.where((p) => p.isLowStock).length;
  }

  // Correction : Utilisation de Color.fromARGB pour éviter les avertissements 'deprecated'
  Color _withAlpha(Color color, double alpha) {
    final int newAlpha = (alpha * 255).round().clamp(0, 255);
    return Color.fromARGB(newAlpha, (color.r * 255.0).round().clamp(0, 255), (color.g * 255.0).round().clamp(0, 255), (color.b * 255.0).round().clamp(0, 255));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOverviewCards(),
          const SizedBox(height: 16),
          _buildCategoryChart(),
          const SizedBox(height: 16),
          _buildValueChart(),
          const SizedBox(height: 16),
          _buildHeatMap(),
          const SizedBox(height: 16),
          _buildTopProducts(),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Produits',
                _getTotalProducts().toString(),
                Icons.inventory_2,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Quantité totale',
                _getTotalQuantity().toString(),
                Icons.shopping_cart,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Valeur totale',
                NumberFormat.currency(symbol: '€', decimalDigits: 0)
                    .format(_getTotalValue()),
                Icons.euro,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Alertes stock',
                _getLowStockCount().toString(),
                Icons.warning_amber,
                Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final trend = _getTrendForTitle(title);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 4,
          shadowColor: _withAlpha(color, 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _withAlpha(color, 0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _withAlpha(color, 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: _withAlpha(color, 0.3), width: 2),
                    ),
                    child: Icon(icon, size: 32, color: color),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        trend > 0 ? Icons.arrow_upward : trend < 0 ? Icons.arrow_downward : Icons.horizontal_rule,
                        color: trend > 0 ? Colors.green : trend < 0 ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChart() {
    final categoryCounts = _getCategoryCounts();
    if (categoryCounts.isEmpty) return const SizedBox();

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 4,
        shadowColor: _withAlpha(Colors.blue, 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _withAlpha(Colors.blue, 0.05),
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.pie_chart,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Répartition par catégorie',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 220,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
                      centerSpaceColor: Colors.transparent,
                      sections: categoryCounts.entries.map((entry) {
                        final index =
                            categoryCounts.keys.toList().indexOf(entry.key);
                        final color = colors[index % colors.length];
                        final percentage =
                            (entry.value / _getTotalProducts() * 100)
                                .toStringAsFixed(1);
                        return PieChartSectionData(
                          value: entry.value.toDouble(),
                          title: '$percentage%',
                          color: color,
                          radius: 85,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (event is FlTapUpEvent && pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
                            final touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            if (touchedIndex >= 0 && touchedIndex < categoryCounts.length) {
                              final categoryName = categoryCounts.keys.elementAt(touchedIndex);
                              _showCategoryDetailsDialog(categoryName);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: categoryCounts.entries.map((entry) {
                    final index =
                        categoryCounts.keys.toList().indexOf(entry.key);
                    final color = colors[index % colors.length];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _withAlpha(color, 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _withAlpha(color, 0.3), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValueChart() {
    final categoryValues = _getCategoryValues();
    if (categoryValues.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valeur par catégorie',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: categoryValues.entries.map((entry) {
                    final index =
                        categoryValues.keys.toList().indexOf(entry.key);
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: Colors.blue,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            NumberFormat.compact().format(value),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final categories = categoryValues.keys.toList();
                          if (value.toInt() >= 0 &&
                              value.toInt() < categories.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                categories[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts() {
    final sortedProducts = List<Product>.from(_products)
      ..sort(
          (a, b) => (b.price * b.quantity).compareTo(a.price * a.quantity));
    final topProducts = sortedProducts.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top 5 produits (valeur)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...topProducts.map((product) {
              final value = product.price * product.quantity;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${product.quantity} × ${NumberFormat.currency(symbol: '€').format(product.price)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '€').format(value),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showCategoryDetailsDialog(String categoryName) {
    final categoryProducts = _products.where((p) => _categoryMap[p.categoryId] == categoryName).toList();
    final totalValue = categoryProducts.fold(0.0, (sum, p) => sum + (p.price * p.quantity));
    final totalQuantity = categoryProducts.fold(0, (sum, p) => sum + p.quantity);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails de $categoryName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre de produits: ${categoryProducts.length}'),
            Text('Quantité totale: $totalQuantity'),
            Text('Valeur totale: ${NumberFormat.currency(symbol: '€').format(totalValue)}'),
            const SizedBox(height: 16),
            const Text('Produits:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: categoryProducts.length,
                itemBuilder: (context, index) {
                  final product = categoryProducts[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Quantité: ${product.quantity} - Prix: ${NumberFormat.currency(symbol: '€').format(product.price)}'),
                    dense: true,
                  );
                },
              ),
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
    );
  }

  int _getTrendForTitle(String title) {
    // Simulate trends since we don't have historical data
    // In a real app, this would compare current vs previous period
    switch (title) {
      case 'Produits':
        return 1; // Up trend
      case 'Quantité totale':
        return -1; // Down trend
      case 'Valeur totale':
        return 1; // Up trend
      case 'Alertes stock':
        return -1; // Down trend (good - fewer alerts)
      default:
        return 0; // No trend
    }
  }

  Widget _buildHeatMap() {
    // Simulate heat map data for sales by category and quantity
    final categoryCounts = _getCategoryCounts();
    if (categoryCounts.isEmpty) return const SizedBox();

    final categories = categoryCounts.keys.toList();
    final maxCount = categoryCounts.values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carte thermique - Produits par catégorie',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final count = categoryCounts[category]!;
                final intensity = count / maxCount;

                Color heatColor;
                if (intensity > 0.8) {
                  heatColor = Colors.red;
                } else if (intensity > 0.6) {
                  heatColor = Colors.orange;
                } else if (intensity > 0.4) {
                  heatColor = Colors.yellow;
                } else if (intensity > 0.2) {
                  heatColor = Colors.lightGreen;
                } else {
                  heatColor = Colors.green;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: heatColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          count.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeatMapLegend('Faible', Colors.green),
                const SizedBox(width: 8),
                _buildHeatMapLegend('Moyen', Colors.yellow),
                const SizedBox(width: 8),
                _buildHeatMapLegend('Élevé', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatMapLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
