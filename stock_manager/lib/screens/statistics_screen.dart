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
);
}

Widget _buildStatCard(
String title,
String value,
IconData icon,
Color color,
) {
return FadeTransition(
opacity: _fadeAnimation,
child: ScaleTransition(
scale: _scaleAnimation,
child: Card(
elevation: 4,
shadowColor: color.withOpacity(0.3),
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
color.withOpacity(0.1),
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
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(30),
border: Border.all(color: color.withOpacity(0.3), width: 2),
),
child: Icon(icon, size: 32, color: color),
),
const SizedBox(height: 12),
Text(
value,
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.w700,
color: Theme.of(context).colorScheme.onSurface,
),
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
shadowColor: Colors.blue.withOpacity(0.3),
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
Colors.blue.withOpacity(0.05),
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
Icon(Icons.pie_chart, color: Theme.of(context).colorScheme.primary),
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
final index = categoryCounts.keys.toList().indexOf(entry.key);
final color = colors[index % colors.length];
final percentage = (entry.value / _getTotalProducts() * 100).toStringAsFixed(1);
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
badgeWidget: Container(
width: 8,
height: 8,
decoration: BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,
border: Border.all(color: color, width: 2),
),
),
badgePositionPercentageOffset: 1.1,
);
}).toList(),
),
),
),
const SizedBox(height: 20),
Wrap(
spacing: 12,
runSpacing: 8,
children: categoryCounts.entries.map((entry) {
final index = categoryCounts.keys.toList().indexOf(entry.key);
final color = colors[index % colors.length];
return Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(20),
border: Border.all(color: color.withOpacity(0.3), width: 1),
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
..sort((a, b) => (b.price * b.quantity).compareTo(a.price * a.quantity));
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
}
