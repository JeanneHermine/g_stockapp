class Batch {
  final String id;
  final String productId;
  final String serialNumber;
  final DateTime entryDate;
  final DateTime? expirationDate;

  Batch({
    required this.id,
    required this.productId,
    required this.serialNumber,
    required this.entryDate,
    this.expirationDate,
  });
}
