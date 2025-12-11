class StockMovement {
  final String productId;
  final int quantity;
  final String type; // 'in' ou 'out'
  final DateTime date;

  StockMovement({
    required this.productId,
    required this.quantity,
    required this.type,
    required this.date,
  });
}
