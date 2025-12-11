import ‘package:flutter/material.dart’;
import ‘package:fl_chart/fl_chart.dart’;
import ‘package:intl/intl.dart’;
import ‘package:stock_manager/database/database_helper.dart’;
import ‘package:stock_manager/models/product.dart’;

class StatisticsScreen extends StatefulWidget {
const StatisticsScreen({super.key});

@override
State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
List<Product> _products = [];
bool _isLoading = true;

@override
void initState() {
super.initState();
_loadData();
}

Future<void> _loadData() async {
setState(() => _isLoading = true);
final products = await DatabaseHelper.instance.getAllProducts();
setState(() {
_products = products;
_isLoading = false;
});
}

Map<String, int> _getCategoryCounts() {
final Map<String, int> counts = {};
for (var product in _products) {
counts[product.category] = (counts[product.category] ?? 0) + 1;
}
return counts;
}

Map<String, double> _getCategoryValues() {
final Map<String, double> values = {};
for (var product in _products) {
values[product.category] =
(values[product.category] ?? 0) + (product.price * product.quantity);
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
‘Produits’,
_getTotalProducts().toString(),
Icons.inventory_2,
Colors.blue,
),
),
const SizedBox(width: 12),
Expanded(
child: _buildStatCard(
‘Quantité totale’,
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
‘Valeur totale’,
NumberFormat.currency(symbol: ‘€’, decimalDigits: 0)
.format(_getTotalValue()),
Icons.euro,
Colors.orange,
),
),
const SizedBox(width: 12),
Expanded(
child: _buildStatCard(
‘Alertes stock’,
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
return Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [
Icon(icon, size: 32, color: color),
const SizedBox(height: 8),
Text(
value,
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
Text(
title,
style: TextStyle(
fontSize: 12,
color: Colors.grey[600],
),
textAlign: TextAlign.center,
),
],
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

return Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Répartition par catégorie',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: categoryCounts.entries.map((entry) {
                final index =
                    categoryCounts.keys.toList().indexOf(entry.key);
                final color = colors[index % colors.length];
                final percentage =
                    (entry.value / _getTotalProducts() * 100).toStringAsFixed(1);
                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  title: '$percentage%',
                  color: color,
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categoryCounts.entries.map((entry) {
            final index = categoryCounts.keys.toList().indexOf(entry.key);
            final color = colors[index % colors.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
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
                Text('${entry.key}: ${entry.value}'),
              ],
            );
          }).toList(),
        ),
      ],
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