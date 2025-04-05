import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Models/crop_model.dart';
import 'package:agrisage/Features/Dashboard/Services/crop_service.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';
import 'package:agrisage/ColorPage.dart';

class CropWidget extends StatefulWidget {
  final CropService cropService;

  const CropWidget({super.key, required this.cropService});

  @override
  State<CropWidget> createState() => _CropWidgetState();
}

class _CropWidgetState extends State<CropWidget> {
  String _searchQuery = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _varietyController = TextEditingController();
  final TextEditingController _fieldLocationController =
      TextEditingController();
  final TextEditingController _estimatedYieldController =
      TextEditingController();
  final TextEditingController _yieldUnitController = TextEditingController();
  DateTime _selectedPlantingDate = DateTime.now();
  DateTime _selectedHarvestDate = DateTime.now().add(const Duration(days: 90));
  String _selectedHealthStatus = 'Good';
  final List<String> _healthStatuses = [
    'Excellent',
    'Good',
    'Moderate',
    'Poor'
  ];
  // Remove the expanded state variable since we're making it scrollable

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _fieldLocationController.dispose();
    _estimatedYieldController.dispose();
    _yieldUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    // Filter crops based on search
    final List<Crop> filteredCrops =
        widget.cropService.getAllCrops().where((crop) {
      return crop.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          crop.variety.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          crop.fieldLocation.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Crop Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Crop calendar visualization
          DashboardCard(
            title: 'Crop Calendar',
            child: Container(
              height: 400, // Fixed height container
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Fixed upper part showing month names
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.asset(
                      'lib/assets/Dashboard/crop_calendar_upper.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),

                  // Scrollable lower part
                  Expanded(
                    child: Stack(
                      children: [
                        // Scrollable content
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Image.asset(
                              'lib/assets/Dashboard/crop_calendar_lower.png',
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),

                        // Gradient overlay at the bottom to indicate scrollability
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Search and add button
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search crops...',
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
              ElevatedButton.icon(
                onPressed: () => _showAddCropDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Crop'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPage.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Crop cards
          filteredCrops.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No crops found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              : isDesktop
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: filteredCrops.length,
                      itemBuilder: (context, index) {
                        return _buildCropCard(filteredCrops[index]);
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredCrops.length,
                      itemBuilder: (context, index) {
                        return _buildCropListItem(filteredCrops[index]);
                      },
                    ),
        ],
      ),
    );
  }

  Widget _buildCropCard(Crop crop) {
    final daysToHarvest =
        crop.expectedHarvestDate.difference(DateTime.now()).inDays;
    final growthPercentage = _calculateGrowthPercentage(crop);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crop.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Variety: ${crop.variety}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getHealthStatusColor(crop.healthStatus)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    crop.healthStatus,
                    style: TextStyle(
                      color: _getHealthStatusColor(crop.healthStatus),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${crop.fieldLocation}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Growth Progress',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: growthPercentage,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorPage.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(growthPercentage * 100).toInt()}% Complete',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Days to Harvest',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      daysToHarvest > 0
                          ? '$daysToHarvest days'
                          : 'Ready to harvest',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            daysToHarvest > 0 ? Colors.black87 : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Est. Yield: ${crop.estimatedYield} ${crop.yieldUnit}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.edit, size: 20, color: Colors.blue),
                      onPressed: () => _showEditCropDialog(crop),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _showDeleteCropDialog(crop),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropListItem(Crop crop) {
    final daysToHarvest =
        crop.expectedHarvestDate.difference(DateTime.now()).inDays;
    final growthPercentage = _calculateGrowthPercentage(crop);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        title: Text(
          crop.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('${crop.variety} - ${crop.fieldLocation}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getHealthStatusColor(crop.healthStatus).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            crop.healthStatus,
            style: TextStyle(
              color: _getHealthStatusColor(crop.healthStatus),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      'Planted on: ${_formatDate(crop.plantingDate)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      'Expected harvest: ${_formatDate(crop.expectedHarvestDate)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Growth Progress',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: growthPercentage,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ColorPage.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(growthPercentage * 100).toInt()}% Complete',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      daysToHarvest > 0
                          ? '$daysToHarvest days to harvest'
                          : 'Ready to harvest',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            daysToHarvest > 0 ? Colors.black87 : Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.eco, size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      'Estimated yield: ${crop.estimatedYield} ${crop.yieldUnit}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showEditCropDialog(crop),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _showDeleteCropDialog(crop),
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCropDialog() {
    _nameController.clear();
    _varietyController.clear();
    _fieldLocationController.clear();
    _estimatedYieldController.text = '0.0';
    _yieldUnitController.text = 'tons/hectare';
    _selectedPlantingDate = DateTime.now();
    _selectedHarvestDate = DateTime.now().add(const Duration(days: 90));
    _selectedHealthStatus = 'Good';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Crop'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Crop Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _varietyController,
                decoration: const InputDecoration(
                  labelText: 'Variety',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _fieldLocationController,
                decoration: const InputDecoration(
                  labelText: 'Field Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _estimatedYieldController,
                      decoration: const InputDecoration(
                        labelText: 'Estimated Yield',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _yieldUnitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Planting Date: '),
                  const SizedBox(width: 8),
                  TextButton(
                    child: Text(_formatDate(_selectedPlantingDate)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedPlantingDate,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedPlantingDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Harvest Date: '),
                  const SizedBox(width: 8),
                  TextButton(
                    child: Text(_formatDate(_selectedHarvestDate)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedHarvestDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedHarvestDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedHealthStatus,
                decoration: const InputDecoration(
                  labelText: 'Health Status',
                  border: OutlineInputBorder(),
                ),
                items: _healthStatuses.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHealthStatus = value!;
                  });
                },
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
                  _fieldLocationController.text.isNotEmpty) {
                widget.cropService.addCrop(Crop(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  variety: _varietyController.text,
                  fieldLocation: _fieldLocationController.text,
                  plantingDate: _selectedPlantingDate,
                  expectedHarvestDate: _selectedHarvestDate,
                  estimatedYield: double.parse(_estimatedYieldController.text),
                  yieldUnit: _yieldUnitController.text,
                  healthStatus: _selectedHealthStatus,
                ));
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Add Crop'),
          ),
        ],
      ),
    );
  }

  void _showEditCropDialog(Crop crop) {
    _nameController.text = crop.name;
    _varietyController.text = crop.variety;
    _fieldLocationController.text = crop.fieldLocation;
    _estimatedYieldController.text = crop.estimatedYield.toString();
    _yieldUnitController.text = crop.yieldUnit;
    _selectedPlantingDate = crop.plantingDate;
    _selectedHarvestDate = crop.expectedHarvestDate;
    _selectedHealthStatus = crop.healthStatus;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Crop'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Crop Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _varietyController,
                decoration: const InputDecoration(
                  labelText: 'Variety',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _fieldLocationController,
                decoration: const InputDecoration(
                  labelText: 'Field Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _estimatedYieldController,
                      decoration: const InputDecoration(
                        labelText: 'Estimated Yield',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _yieldUnitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Planting Date: '),
                  const SizedBox(width: 8),
                  TextButton(
                    child: Text(_formatDate(_selectedPlantingDate)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedPlantingDate,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedPlantingDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Harvest Date: '),
                  const SizedBox(width: 8),
                  TextButton(
                    child: Text(_formatDate(_selectedHarvestDate)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedHarvestDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedHarvestDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedHealthStatus,
                decoration: const InputDecoration(
                  labelText: 'Health Status',
                  border: OutlineInputBorder(),
                ),
                items: _healthStatuses.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHealthStatus = value!;
                  });
                },
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
                  _fieldLocationController.text.isNotEmpty) {
                widget.cropService.updateCrop(
                  crop.id,
                  Crop(
                    id: crop.id,
                    name: _nameController.text,
                    variety: _varietyController.text,
                    fieldLocation: _fieldLocationController.text,
                    plantingDate: _selectedPlantingDate,
                    expectedHarvestDate: _selectedHarvestDate,
                    estimatedYield:
                        double.parse(_estimatedYieldController.text),
                    yieldUnit: _yieldUnitController.text,
                    healthStatus: _selectedHealthStatus,
                    treatments: crop.treatments,
                    additionalData: crop.additionalData,
                  ),
                );
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Update Crop'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCropDialog(Crop crop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Crop'),
        content: Text(
            'Are you sure you want to delete "${crop.name} (${crop.variety})" from ${crop.fieldLocation}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.cropService.deleteCrop(crop.id);
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

  double _calculateGrowthPercentage(Crop crop) {
    final totalGrowthDays =
        crop.expectedHarvestDate.difference(crop.plantingDate).inDays;
    final daysGrown = DateTime.now().difference(crop.plantingDate).inDays;

    if (daysGrown <= 0) return 0.0;
    if (daysGrown >= totalGrowthDays) return 1.0;

    return daysGrown / totalGrowthDays;
  }

  Color _getHealthStatusColor(String status) {
    switch (status) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return Colors.lightGreen;
      case 'Moderate':
        return Colors.orange;
      case 'Poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
