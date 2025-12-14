import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/database/database_helper.dart';
import 'package:stock_manager/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _screens = [
      // Remplacez par vos écrans réels
      Center(child: Text('Produits')),
      Center(child: Text('Statistiques')),
      Center(child: Text('Ventes')),
      Center(child: Text('Alertes')),
      Center(child: Text('Historique')),
    ];

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex != index) {
      _fadeController.reverse().then((_) {
        setState(() {
          _selectedIndex = index;
        });
        _fadeController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Manager'),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Changer de thème',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      widget.userName[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(widget.userName, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _DashboardOverview(),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Produits',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Ventes',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning_amber),
            label: 'Alertes',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}

class _DashboardOverview extends StatefulWidget {
  @override
  State<_DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<_DashboardOverview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  bool _loading = true;
  int _totalProducts = 0;
  int _totalQuantity = 0;
  double _totalValue = 0;
  int _lowStock = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _totalProducts = products.length;
      _totalQuantity = products.fold(0, (sum, p) => sum + p.quantity);
      _totalValue = products.fold(0, (sum, p) => sum + (p.price * p.quantity));
      _lowStock = products.where((p) => p.quantity <= 0).length;
      _loading = false;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(),
      );
    }
    final isWide = MediaQuery.of(context).size.width > 600;
    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(
                  icon: Icons.inventory_2,
                  label: 'Produits',
                  value: '$_totalProducts',
                  color: Colors.blue,
                ),
                _StatCard(
                  icon: Icons.shopping_cart,
                  label: 'Quantité',
                  value: '$_totalQuantity',
                  color: Colors.green,
                ),
                _StatCard(
                  icon: Icons.euro,
                  label: 'Valeur',
                  value: '${_totalValue.toStringAsFixed(0)} €',
                  color: Colors.orange,
                ),
                _StatCard(
                  icon: Icons.warning_amber,
                  label: 'Alertes',
                  value: '$_lowStock',
                  color: Colors.red,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withAlpha(31), // 0.12 * 255 ≈ 31
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(value,
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }
}
