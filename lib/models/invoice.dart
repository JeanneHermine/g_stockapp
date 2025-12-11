class Invoice {
  final String id;
  final String customerId;
  final DateTime date;
  final double total;
  final List<Map<String, dynamic>> items;

  Invoice({
    required this.id,
    required this.customerId,
    required this.date,
    required this.total,
    required this.items,
  });
}
