import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vue d’ensemble',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildStatCard(
                    'Produits en stock',
                    '120',
                    Icons.inventory,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Mouvements',
                    '45',
                    Icons.swap_horiz,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    'Ventes',
                    '32',
                    Icons.shopping_cart,
                    Colors.green,
                  ),
                  _buildStatCard('Alertes', '3', Icons.warning, Colors.red),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Graphiques (exemple)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Container(
              height: 150,
              color: Colors.grey[200],
              child: Center(
                child: Text('Graphique à intégrer'),
              ), // Placeholder pour graphique
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
