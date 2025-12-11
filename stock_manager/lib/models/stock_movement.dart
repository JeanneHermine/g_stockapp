/// StockMovement model for stock_manager
class StockMovement {
  final String id;
  final String productId;
  final String productName;
  final int quantityChange;
  final String type;
  final String? reason;
  final String createdAt;

  StockMovement({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantityChange,
    required this.type,
    this.reason,
    required this.createdAt,
  });

  factory StockMovement.fromMap(Map<String, dynamic> map) => StockMovement(
    id: map['id'] as String,
    productId: map['productId'] as String,
    productName: map['productName'] as String,
    quantityChange: map['quantityChange'] as int,
    type: map['type'] as String,
    reason: map['reason'] as String?,
    createdAt: map['createdAt'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'quantityChange': quantityChange,
    'type': type,
    'reason': reason,
    'createdAt': createdAt,
  };
}
