import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Models/inventory_model.dart';
import 'package:agrisage/Features/Dashboard/Services/inventory_service.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';
import 'package:agrisage/ColorPage.dart';

class InventoryWidget extends StatefulWidget {
  final InventoryService inventoryService;

  const InventoryWidget({super.key, required this.inventoryService});

  @override
  State<InventoryWidget> createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  String _selectedNewCategory = 'Fertilizer';
  final List<String> _categories = [
    'Fertilizer',
    'Pesticide',
    'Seeds',
    'Equipment',
    'Fuel',
    'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    // Get available categories from inventory
    final availableCategories = ['All'];
    final categoryCounts = widget.inventoryService.getCategoryCounts();
    availableCategories.addAll(categoryCounts.keys);

    // Filter items based on search and category
    final List<InventoryItem> filteredItems =
        widget.inventoryService.getAllItems().where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Inventory Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Stats cards

          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 120,
            ),
            shrinkWrap: true,
            children: [
              _buildStatCard(
                'Total Items',
                widget.inventoryService.getAllItems().length.toString(),
                Icons.inventory_2,
                Colors.blue,
                isDesktop ? 280 : size.width * 0.45 - 16,
              ),
              _buildStatCard(
                'Categories',
                categoryCounts.length.toString(),
                Icons.category,
                Colors.purple,
                isDesktop ? 280 : size.width * 0.45 - 16,
              ),
              _buildStatCard(
                'Low Stock',
                widget.inventoryService.getLowStockItems(50).length.toString(),
                Icons.warning_amber,
                Colors.orange,
                isDesktop ? 280 : size.width * 0.45 - 16,
              ),
              _buildStatCard(
                'This Month',
                '${widget.inventoryService.getAllItems().length > 0 ? 3 : 0}',
                Icons.date_range,
                Colors.green,
                isDesktop ? 280 : size.width * 0.45 - 16,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Search and filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search inventory items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedCategory,
                items: availableCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                hint: const Text('Category'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showAddItemDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPage.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Inventory table
          DashboardCard(
            title: 'Inventory Items',
            child: SizedBox(
              width: double.infinity,
              height: 500,
              child: filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No inventory items found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : isDesktop
                      ? _buildDesktopInventoryTable(filteredItems)
                      : _buildMobileInventoryList(filteredItems),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              Icon(icon, color: color),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopInventoryTable(List<InventoryItem> items) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Last Updated')),
          DataColumn(label: Text('Actions')),
        ],
        rows: items.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item.name)),
              DataCell(Text(item.category)),
              DataCell(Text('${item.quantity} ${item.unit}')),
              DataCell(Text(_formatDate(item.lastUpdated))),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditItemDialog(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteItemDialog(item),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileInventoryList(List<InventoryItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: ListTile(
            title: Text(item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${item.category}'),
                Text('Quantity: ${item.quantity} ${item.unit}'),
                Text('Last Updated: ${_formatDate(item.lastUpdated)}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditItemDialog(item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteItemDialog(item),
                ),
              ],
            ),
            onTap: () => _showEditItemDialog(item),
          ),
        );
      },
    );
  }

  void _showAddItemDialog() {
    _nameController.clear();
    _quantityController.clear();
    _unitController.text = 'kg';
    _selectedNewCategory = 'Fertilizer';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Inventory Item'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedNewCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedNewCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _unitController,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _quantityController.text.isNotEmpty) {
                widget.inventoryService.addItem(InventoryItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  category: _selectedNewCategory,
                  quantity: double.parse(_quantityController.text),
                  unit: _unitController.text,
                  lastUpdated: DateTime.now(),
                ));
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(InventoryItem item) {
    _nameController.text = item.name;
    _quantityController.text = item.quantity.toString();
    _unitController.text = item.unit;
    _selectedNewCategory = item.category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Inventory Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedNewCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedNewCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _quantityController.text.isNotEmpty) {
                widget.inventoryService.updateItem(
                  item.id,
                  InventoryItem(
                    id: item.id,
                    name: _nameController.text,
                    category: _selectedNewCategory,
                    quantity: double.parse(_quantityController.text),
                    unit: _unitController.text,
                    lastUpdated: DateTime.now(),
                    location: item.location,
                    pricePerUnit: item.pricePerUnit,
                    supplier: item.supplier,
                  ),
                );
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Update Item'),
          ),
        ],
      ),
    );
  }

  void _showDeleteItemDialog(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Inventory Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.inventoryService.deleteItem(item.id);
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
