import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';
import 'package:agrisage/ColorPage.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Weather Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Current weather
          if (MediaQuery.of(context).size.width < 450)
            DashboardCard(
              title: 'Current Weather',
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: isDesktop ? 1 : 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Today, June 15',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.wb_sunny,
                                    size: 60,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '28°C',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Feels like 30°C',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          'Clear Sky',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isDesktop)
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildWeatherDetail(
                                    'Humidity', '65%', Icons.water),
                                const SizedBox(height: 8),
                                _buildWeatherDetail(
                                    'Wind', '10 km/h', Icons.air),
                                const SizedBox(height: 8),
                                _buildWeatherDetail(
                                    'Pressure', '1013 hPa', Icons.speed),
                                const SizedBox(height: 8),
                                _buildWeatherDetail('UV Index', 'High',
                                    Icons.wb_sunny_outlined),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (!isDesktop)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          const Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildWeatherDetail(
                                      'Humidity', '65%', Icons.water)),
                              Expanded(
                                  child: _buildWeatherDetail(
                                      'Wind', '10 km/h', Icons.air)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildWeatherDetail(
                                      'Pressure', '1013 hPa', Icons.speed)),
                              Expanded(
                                  child: _buildWeatherDetail('UV Index', 'High',
                                      Icons.wb_sunny_outlined)),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Weekly forecast
          if (MediaQuery.of(context).size.width < 450)
            DashboardCard(
              title: '7-Day Forecast',
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final date = DateTime.now().add(Duration(days: index));
                    final dayName =
                        index == 0 ? 'Today' : _getDayName(date.weekday);

                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            _getWeatherIcon(index),
                            size: 32,
                            color: _getWeatherColor(index),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${25 + index % 5}°C',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${20 + index % 5}°C',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getWeatherCondition(index),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

          if (MediaQuery.of(context).size.width > 900)
            SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: DashboardCard(
                      title: 'Current Weather',
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Today, June 15',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.wb_sunny,
                                            size: 60,
                                            color: Colors.orange,
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '28°C',
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                'Feels like 30°C',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 8),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Text(
                                                  'Clear Sky',
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildWeatherDetail(
                                        'Humidity', '65%', Icons.water)),
                                Expanded(
                                    child: _buildWeatherDetail(
                                        'Wind', '10 km/h', Icons.air)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildWeatherDetail(
                                        'Pressure', '1013 hPa', Icons.speed)),
                                Expanded(
                                    child: _buildWeatherDetail('UV Index',
                                        'High', Icons.wb_sunny_outlined)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: DashboardCard(
                      title: '7-Day Forecast',
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final date =
                                DateTime.now().add(Duration(days: index));
                            final dayName = index == 0
                                ? 'Today'
                                : _getDayName(date.weekday);

                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Icon(
                                    _getWeatherIcon(index),
                                    size: 32,
                                    color: _getWeatherColor(index),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${25 + index % 5}°C',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${20 + index % 5}°C',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getWeatherCondition(index),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Weather map
          DashboardCard(
            title: 'Weather Map',
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMapTypeButton('Temperature', true),
                        const SizedBox(width: 8),
                        _buildMapTypeButton('Precipitation', false),
                        const SizedBox(width: 8),
                        _buildMapTypeButton('Wind', false),
                        const SizedBox(width: 8),
                        _buildMapTypeButton('Humidity', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: Placeholder()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgriWeatherAlert(
      String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTypeButton(String label, bool isSelected) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(label),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  IconData _getWeatherIcon(int index) {
    final icons = [
      Icons.wb_sunny,
      Icons.cloud,
      Icons.grain,
      Icons.wb_cloudy,
      Icons.thunderstorm,
      Icons.water,
      Icons.wb_sunny,
    ];
    return icons[index % icons.length];
  }

  Color _getWeatherColor(int index) {
    final colors = [
      Colors.orange,
      Colors.grey,
      Colors.lightBlue,
      Colors.blueGrey,
      Colors.purple,
      Colors.blue,
      Colors.orange,
    ];
    return colors[index % colors.length];
  }

  String _getWeatherCondition(int index) {
    final conditions = [
      'Sunny',
      'Cloudy',
      'Drizzle',
      'Partly Cloudy',
      'Thunderstorm',
      'Rainy',
      'Clear',
    ];
    return conditions[index % conditions.length];
  }
}
