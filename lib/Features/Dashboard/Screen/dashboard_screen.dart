import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Models/task_model.dart';
import 'package:agrisage/Features/Dashboard/Models/inventory_model.dart';
import 'package:agrisage/Features/Dashboard/Models/crop_model.dart';
import 'package:agrisage/Features/Dashboard/Services/task_service.dart';
import 'package:agrisage/Features/Dashboard/Services/inventory_service.dart';
import 'package:agrisage/Features/Dashboard/Services/crop_service.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';
import 'package:agrisage/Features/Dashboard/Widgets/ndvi_widget.dart';
import 'package:agrisage/Features/Dashboard/Widgets/ndwi_widget.dart';
import 'package:agrisage/Features/Dashboard/Widgets/weather_widget.dart';
import 'package:agrisage/Features/Dashboard/Widgets/tasks_widget.dart';
import 'package:agrisage/Features/Dashboard/Widgets/inventory_widget.dart';
import 'package:agrisage/Features/Dashboard/Widgets/crop_widget.dart';
import 'package:agrisage/Features/Dashboard/Widgets/prediction_widget.dart';
import 'package:agrisage/Features/Dashboard/Widgets/tips_widget.dart';
import 'package:agrisage/Features/Dashboard/Widgets/analytics_widget.dart';
import 'package:agrisage/ColorPage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TaskService _taskService = TaskService();
  final InventoryService _inventoryService = InventoryService();
  final CropService _cropService = CropService();

  // For controlling the active section in mobile view
  int _selectedIndex = 0;
  final List<String> _sectionTitles = [
    'Overview',
    'Field Analysis',
    'Weather',
    'Tasks',
    'Inventory',
    'Crops',
    'Predictions',
    'Tips'
  ];

  @override
  void initState() {
    super.initState();
    _loadDummyData();
  }

  void _loadDummyData() {
    // Load dummy tasks
    _taskService.addTask(Task(
      id: '1',
      title: 'Apply Fertilizer',
      description: 'Apply 100kg of NPK fertilizer to the north field',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.high,
      isCompleted: false,
    ));
    _taskService.addTask(Task(
      id: '2',
      title: 'Irrigation Check',
      description: 'Check water levels in irrigation system',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.medium,
      isCompleted: false,
    ));
    _taskService.addTask(Task(
      id: '3',
      title: 'Harvest Planning',
      description: 'Prepare equipment for upcoming wheat harvest',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: TaskPriority.low,
      isCompleted: true,
    ));

    // Load dummy inventory items
    _inventoryService.addItem(InventoryItem(
      id: '1',
      name: 'NPK Fertilizer',
      category: 'Fertilizer',
      quantity: 500,
      unit: 'kg',
      lastUpdated: DateTime.now(),
    ));
    _inventoryService.addItem(InventoryItem(
      id: '2',
      name: 'Pesticide X',
      category: 'Pesticide',
      quantity: 200,
      unit: 'liters',
      lastUpdated: DateTime.now(),
    ));
    _inventoryService.addItem(InventoryItem(
      id: '3',
      name: 'Wheat Seeds',
      category: 'Seeds',
      quantity: 300,
      unit: 'kg',
      lastUpdated: DateTime.now(),
    ));

    // Load dummy crops
    _cropService.addCrop(Crop(
      id: '1',
      name: 'Wheat',
      variety: 'HD-2967',
      fieldLocation: 'North Field',
      plantingDate: DateTime.now().subtract(const Duration(days: 45)),
      expectedHarvestDate: DateTime.now().add(const Duration(days: 75)),
      estimatedYield: 4.5,
      yieldUnit: 'tons/hectare',
      healthStatus: 'Good',
    ));
    _cropService.addCrop(Crop(
      id: '2',
      name: 'Rice',
      variety: 'Basmati',
      fieldLocation: 'East Field',
      plantingDate: DateTime.now().subtract(const Duration(days: 30)),
      expectedHarvestDate: DateTime.now().add(const Duration(days: 90)),
      estimatedYield: 3.8,
      yieldUnit: 'tons/hectare',
      healthStatus: 'Excellent',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgriSage Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorPage.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                // Refresh data
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // User profile
            },
          ),
        ],
      ),
      drawer: isDesktop ? null : _buildDrawer(),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement chat functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chat functionality coming soon!')),
          );
        },
        backgroundColor: ColorPage.primaryColor,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorPage.primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,
                      size: 40, color: ColorPage.primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  'AgriSage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < _sectionTitles.length; i++)
            ListTile(
              leading: _getIconForSection(i),
              title: Text(_sectionTitles[i]),
              selected: _selectedIndex == i,
              onTap: () {
                setState(() {
                  _selectedIndex = i;
                  Navigator.pop(context);
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Side navigation
        SizedBox(
          width: 250,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 20),
              for (int i = 0; i < _sectionTitles.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    color: _selectedIndex == i
                        ? ColorPage.primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          _selectedIndex = i;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            _getIconForSection(i),
                            const SizedBox(width: 16),
                            Text(
                              _sectionTitles[i],
                              style: TextStyle(
                                fontWeight: _selectedIndex == i
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedIndex == i
                                    ? ColorPage.primaryColor
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Vertical divider
        const VerticalDivider(width: 1),
        // Main content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSectionContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return _buildSectionContent();
  }

  Widget _buildSectionContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverviewSection();
      case 1:
        return _buildFieldAnalysisSection();
      case 2:
        return _buildWeatherSection();
      case 3:
        return TasksWidget(taskService: _taskService);
      case 4:
        return InventoryWidget(inventoryService: _inventoryService);
      case 5:
        return CropWidget(cropService: _cropService);
      case 6:
        return const PredictionWidget();
      case 7:
        return const TipsWidget();
      default:
        return const Center(child: Text('Section not found!'));
    }
  }

  Widget _buildOverviewSection() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isMedium = size.width > 600 && size.width <= 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Dashboard Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick stats row
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatCard(
                'Active Tasks',
                _taskService.getActiveTasks().length.toString(),
                Icons.task_alt,
                Colors.orange,
                isDesktop
                    ? size.width * 0.2
                    : (isMedium ? size.width * 0.4 : size.width - 48),
              ),
              _buildStatCard(
                'Crops Monitored',
                _cropService.getAllCrops().length.toString(),
                Icons.eco,
                Colors.green,
                isDesktop
                    ? size.width * 0.2
                    : (isMedium ? size.width * 0.4 : size.width - 48),
              ),
              _buildStatCard(
                'Inventory Items',
                _inventoryService.getAllItems().length.toString(),
                Icons.inventory_2,
                Colors.blue,
                isDesktop
                    ? size.width * 0.2
                    : (isMedium ? size.width * 0.4 : size.width - 48),
              ),
              _buildStatCard(
                'Weather',
                '28°C',
                Icons.thermostat,
                Colors.red,
                isDesktop
                    ? size.width * 0.2
                    : (isMedium ? size.width * 0.4 : size.width - 48),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Today's tasks and summary
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isDesktop ? 3 : 1,
                child: DashboardCard(
                  title: 'Today\'s Tasks',
                  child: SizedBox(
                    height: 300,
                    child: _buildRecentTasksList(),
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 16),
              if (isDesktop)
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      DashboardCard(
                        title: 'Field Health Summary',
                        child: Container(
                          height: 140,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildHealthIndicator('NDVI', 0.75, Colors.green),
                              _buildHealthIndicator('NDWI', 0.62, Colors.blue),
                              _buildHealthIndicator('Soil', 0.82, Colors.brown),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DashboardCard(
                        title: 'Upcoming Harvests',
                        child: Container(
                          height: 144,
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: _cropService.getAllCrops().length,
                            itemBuilder: (context, index) {
                              final crop = _cropService.getAllCrops()[index];
                              return ListTile(
                                title: Text(crop.name),
                                subtitle: Text(
                                    '${crop.variety} - ${crop.fieldLocation}'),
                                trailing: Text(
                                  '${crop.expectedHarvestDate.difference(DateTime.now()).inDays} days',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (!isDesktop) const SizedBox(height: 16),
          if (!isDesktop)
            DashboardCard(
              title: 'Field Health Summary',
              child: Container(
                height: 140,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHealthIndicator('NDVI', 0.75, Colors.green),
                    _buildHealthIndicator('NDWI', 0.62, Colors.blue),
                    _buildHealthIndicator('Soil', 0.82, Colors.brown),
                  ],
                ),
              ),
            ),

          if (!isDesktop) const SizedBox(height: 16),
          if (!isDesktop)
            DashboardCard(
              title: 'Upcoming Harvests',
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: _cropService.getAllCrops().length,
                  itemBuilder: (context, index) {
                    final crop = _cropService.getAllCrops()[index];
                    return ListTile(
                      title: Text(crop.name),
                      subtitle: Text('${crop.variety} - ${crop.fieldLocation}'),
                      trailing: Text(
                        '${crop.expectedHarvestDate.difference(DateTime.now()).inDays} days',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Weather and alerts section
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DashboardCard(
                        title: 'Weather Forecast',
                        child: SizedBox(
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(5, (index) {
                              return _buildWeatherDay(
                                DateTime.now().add(Duration(days: index)),
                                index == 0 ? 28 : (25 + index),
                                index == 0
                                    ? Icons.wb_sunny
                                    : (index % 2 == 0
                                        ? Icons.cloud
                                        : Icons.wb_cloudy),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DashboardCard(
                        title: 'Recent Recommendations',
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.all(16),
                          child: ListView(
                            children: const [
                              ListTile(
                                leading:
                                    Icon(Icons.water_drop, color: Colors.blue),
                                title: Text('Increase Irrigation'),
                                subtitle: Text(
                                    'North field showing signs of water stress'),
                              ),
                              ListTile(
                                leading:
                                    Icon(Icons.pest_control, color: Colors.red),
                                title: Text('Pest Alert'),
                                subtitle: Text(
                                    'Potential aphid infestation in wheat field'),
                              ),
                              ListTile(
                                leading: Icon(Icons.eco, color: Colors.green),
                                title: Text('Optimal Harvest Time'),
                                subtitle: Text(
                                    'East field rice approaching optimal harvest window'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    DashboardCard(
                      title: 'Weather Forecast',
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(8),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(7, (index) {
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.all(8),
                              child: _buildWeatherDay(
                                DateTime.now().add(Duration(days: index)),
                                index == 0 ? 28 : (25 + index),
                                index == 0
                                    ? Icons.wb_sunny
                                    : (index % 2 == 0
                                        ? Icons.cloud
                                        : Icons.wb_cloudy),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DashboardCard(
                      title: 'Recent Recommendations',
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        child: ListView(
                          children: const [
                            ListTile(
                              leading:
                                  Icon(Icons.water_drop, color: Colors.blue),
                              title: Text('Increase Irrigation'),
                              subtitle: Text(
                                  'North field showing signs of water stress'),
                            ),
                            ListTile(
                              leading:
                                  Icon(Icons.pest_control, color: Colors.red),
                              title: Text('Pest Alert'),
                              subtitle: Text(
                                  'Potential aphid infestation in wheat field'),
                            ),
                            ListTile(
                              leading: Icon(Icons.eco, color: Colors.green),
                              title: Text('Optimal Harvest Time'),
                              subtitle: Text(
                                  'East field rice approaching optimal harvest window'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildFieldAnalysisSection() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Field Analysis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: const NdviWidget(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: const NdwiWidget(),
                    ),
                  ],
                )
              : Column(
                  children: const [
                    NdviWidget(),
                    SizedBox(height: 16),
                    NdwiWidget(),
                  ],
                ),
          const SizedBox(height: 16),
          DashboardCard(
            title: 'Field Health Timeline',
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Image.network(
                  'https://via.placeholder.com/800x250?text=Field+Health+Timeline+Chart',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DashboardCard(
            title: 'Field Selection',
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Field for Analysis',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: isDesktop ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildFieldCard('North Field', 'Wheat', 0.85, 'Good'),
                        _buildFieldCard(
                            'East Field', 'Rice', 0.78, 'Excellent'),
                        _buildFieldCard(
                            'South Field', 'Corn', 0.62, 'Moderate'),
                        _buildFieldCard('West Field', 'Soybean', 0.73, 'Good'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherSection() {
    return const WeatherWidget();
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

  Widget _buildRecentTasksList() {
    final tasks = _taskService.getActiveTasks();

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No active tasks for today!',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getPriorityColor(task.priority).withOpacity(0.2),
            child: Icon(
              Icons.flag,
              color: _getPriorityColor(task.priority),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              fontWeight:
                  task.isCompleted ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Text(task.description),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              setState(() {
                _taskService.updateTask(
                  task.id,
                  task.copyWith(isCompleted: value ?? false),
                );
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildHealthIndicator(String label, double value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDay(DateTime date, int temperature, IconData icon) {
    final day = date.day == DateTime.now().day
        ? 'Today'
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Icon(icon, size: 40, color: Colors.orange),
        const SizedBox(height: 8),
        Text(
          '$temperature°C',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          date.day == DateTime.now().day
              ? 'Clear'
              : ['Sunny', 'Cloudy', 'Partly Cloudy', 'Rainy'][date.day % 4],
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildFieldCard(
      String fieldName, String crop, double healthIndex, String status) {
    Color statusColor;
    if (status == 'Excellent') {
      statusColor = Colors.green;
    } else if (status == 'Good') {
      statusColor = Colors.lightGreen;
    } else if (status == 'Moderate') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return InkWell(
      onTap: () {
        // Navigate to detailed field view
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              crop,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(healthIndex * 100).toInt()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Icon _getIconForSection(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.dashboard);
      case 1:
        return const Icon(Icons.grass);
      case 2:
        return const Icon(Icons.wb_sunny);
      case 3:
        return const Icon(Icons.check_circle);
      case 4:
        return const Icon(Icons.inventory);
      case 5:
        return const Icon(Icons.eco);
      case 6:
        return const Icon(Icons.analytics);
      case 7:
        return const Icon(Icons.lightbulb);
      default:
        return const Icon(Icons.error);
    }
  }
}
