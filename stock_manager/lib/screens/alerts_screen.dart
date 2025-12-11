import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:stock_manager/database/database_helper.dart";
import "package:stock_manager/models/product.dart";
import "package:stock_manager/screens/product_detail_screen.dart";

class AlertsScreen extends StatefulWidget {
const AlertsScreen({super.key});

@override
State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
List<Product> _lowStockProducts = [];
bool _isLoading = true;

@override
void initState() {
super.initState();
_loadData();
}

Future<void> _loadData() async {
setState(() => _isLoading = true);
final products = await DatabaseHelper.instance.getLowStockProducts();
setState(() {
_lowStockProducts = products;
_isLoading = false;
});
}

@override
Widget build(BuildContext context) {
if (_isLoading) {
return const Center(child: CircularProgressIndicator());
}


if (_lowStockProducts.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 80,
          color: Colors.green[400],
        ),
        const SizedBox(height: 16),
        Text(
          'Aucune alerte de stock',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tous vos produits sont bien approvisionnés',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    ),
  );
}

return RefreshIndicator(
  onRefresh: _loadData,
  child: ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red[700],
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_lowStockProducts.length} produit(s) en alerte',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Stock inférieur ou égal au minimum',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      ..._lowStockProducts.map((product) => _buildAlertCard(product)),
    ],
  ),
);


}

Widget _buildAlertCard(Product product) {
final urgencyLevel = _getUrgencyLevel(product);


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
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: urgencyLevel['color'] as Color,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (urgencyLevel['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        urgencyLevel['icon'] as IconData,
                        size: 16,
                        color: urgencyLevel['color'] as Color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        urgencyLevel['label'] as String,
                        style: TextStyle(
                          color: urgencyLevel['color'] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product.category,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    Icons.inventory_2,
                    'Stock actuel',
                    '${product.quantity}',
                    urgencyLevel['color'] as Color,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    Icons.warning_amber,
                    'Stock min.',
                    '${product.minQuantity}',
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    Icons.euro,
                    'Prix unitaire',
                    NumberFormat.currency(symbol: '€').format(product.price),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    Icons.qr_code,
                    'Code-barres',
                    product.barcode,
                    Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Réapprovisionner ${product.minQuantity - product.quantity + 10} unités recommandé',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);


}

Widget _buildInfoChip(IconData icon, String label, String value, Color color) {
return Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(icon, size: 14, color: color),
const SizedBox(width: 4),
Text(
label,
style: TextStyle(
fontSize: 10,
color: Colors.grey[600],
),
),
],
),
const SizedBox(height: 4),
Text(
value,
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold,
color: color,
),
overflow: TextOverflow.ellipsis,
),
],
),
);
}

Map<String, dynamic> _getUrgencyLevel(Product product) {
final percentage = (product.quantity / product.minQuantity * 100);


if (product.quantity == 0) {
  return {
    'label': 'RUPTURE',
    'color': Colors.red[900],
    'icon': Icons.cancel,
  };
} else if (percentage <= 50) {
  return {
    'label': 'URGENT',
    'color': Colors.red,
    'icon': Icons.error,
  };
} else if (percentage <= 100) {
  return {
    'label': 'ATTENTION',
    'color': Colors.orange,
    'icon': Icons.warning,
  };
} else {
  return {
    'label': 'FAIBLE',
    'color': Colors.amber,
    'icon': Icons.info,
  };
}


}
}
