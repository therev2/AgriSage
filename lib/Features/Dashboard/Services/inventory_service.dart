import 'package:agrisage/Features/Dashboard/Models/inventory_model.dart';

class InventoryService {
  // In-memory storage for inventory items
  final List<InventoryItem> _items = [];

  // Get all inventory items
  List<InventoryItem> getAllItems() {
    return List.from(_items);
  }

  // Add a new inventory item
  void addItem(InventoryItem item) {
    _items.add(item);
  }

  // Update an existing inventory item
  void updateItem(String id, InventoryItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = updatedItem;
    }
  }

  // Delete an inventory item
  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  // Get items by category
  List<InventoryItem> getItemsByCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  // Get items with low quantity
  List<InventoryItem> getLowStockItems(double threshold) {
    return _items.where((item) => item.quantity < threshold).toList();
  }

  // Get total value of inventory
  double getTotalInventoryValue() {
    return _items.fold(0.0,
        (total, item) => total + (item.quantity * (item.pricePerUnit ?? 0.0)));
  }

  // Get items by location
  List<InventoryItem> getItemsByLocation(String location) {
    return _items.where((item) => item.location == location).toList();
  }

  // Adjust inventory quantity
  void adjustQuantity(String id, double newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index];
      _items[index] = item.copyWith(
        quantity: newQuantity,
        lastUpdated: DateTime.now(),
      );
    }
  }

  // Get categories with inventory counts
  Map<String, int> getCategoryCounts() {
    final Map<String, int> counts = {};
    for (var item in _items) {
      counts[item.category] = (counts[item.category] ?? 0) + 1;
    }
    return counts;
  }
}
