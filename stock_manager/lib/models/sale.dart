class Sale {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String customerName;
  final String? customerPhone;
  final String? notes;
  final String createdAt;

  Sale({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.customerName,
    this.customerPhone,
    this.notes,
    required this.createdAt,
  });

  factory Sale.fromMap(Map<String, dynamic> map) => Sale(
    id: map['id'] as String,
    productId: map['productId'] as String,
    productName: map['productName'] as String,
    quantity: map['quantity'] as int,
    unitPrice: map['unitPrice'] as double,
    totalPrice: map['totalPrice'] as double,
    customerName: map['customerName'] as String,
    customerPhone: map['customerPhone'] as String?,
    notes: map['notes'] as String?,
    createdAt: map['createdAt'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'notes': notes,
    'createdAt': createdAt,
  };
}
