class InventoryItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final DateTime lastUpdated;
  final String? location;
  final double? pricePerUnit;
  final String? supplier;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.lastUpdated,
    this.location,
    this.pricePerUnit,
    this.supplier,
  });

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    DateTime? lastUpdated,
    String? location,
    double? pricePerUnit,
    String? supplier,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      supplier: supplier ?? this.supplier,
    );
  }
}
