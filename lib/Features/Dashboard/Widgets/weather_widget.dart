import 'package:agrisage/secrets.dart';
import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';

import '../Services/weather_service.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService weatherService = WeatherService(apiKey: Secrets.weatherApiKey);
  Weather? _weather;
  ForecastData? _forecast;
  String _cityName = 'London';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await weatherService.getWeather(_cityName);
      final forecast = await weatherService.getForecast(_cityName);
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
      _isLoading = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                 Text(
                                  'Today, ${DateFormat('MMMM d').format(DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      '${_weather!.iconCode}',
                                      height: 60,
                                      width: 60,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.error, size: 60, color: Colors.red);
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_weather?.temperature.toStringAsFixed(1)}°C',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Feels like ${_weather?.feelsLike.toStringAsFixed(1)}°C',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${_weather?.description[0].toUpperCase()}${_weather?.description.substring(1)}',
                                            style: TextStyle(
                                              color: Colors.lightBlue,
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
                                      'Humidity', '${_weather?.humidity}', Icons.water),
                                  const SizedBox(height: 8),
                                  _buildWeatherDetail(
                                      'Wind', '${_weather?.windSpeed}', Icons.air),
                                  const SizedBox(height: 8),
                                  _buildWeatherDetail(
                                      'Pressure', '${_weather?.pressure}', Icons.speed),
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
                                        'Humidity', '${_weather?.humidity}', Icons.water)),
                                Expanded(
                                    child: _buildWeatherDetail(
                                        'Wind', '${_weather?.windSpeed}', Icons.air)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildWeatherDetail(
                                        'Pressure', '${_weather?.pressure}', Icons.speed)),
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
                  padding: const EdgeInsets.all(8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(7, (index) {
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: _forecast!.items.length > 7 ? 7 : _forecast!.items.length,
                          itemBuilder: (context, index) {
                            final item = _forecast!.items[index];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${item.dateTime.hour}:00', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Image.network(item.getIconUrl(), height: 50),
                                    Text('${item.temperature.toStringAsFixed(1)}°C'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
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
                                        Text(
                                          'Today, ${DateFormat('MMMM d').format(DateTime.now())}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                Colors.lightBlueAccent,
                                                BlendMode.srcATop,
                                              ),
                                              child: Image.network(
                                                'https://openweathermap.org/img/wn/${_weather!.iconCode}@2x.png',
                                                height: 90,
                                                width: 90,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Icon(Icons.error, size: 90, color: Colors.red);
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                 Text(
                                                  '${_weather?.temperature.toStringAsFixed(1)}°C',
                                                  style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Feels like ${_weather?.feelsLike.toStringAsFixed(1)}°C',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
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
                                                    color: Colors.blueGrey
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                    '${_weather?.description[0].toUpperCase()}${_weather?.description.substring(1)}',
                                                    style: TextStyle(
                                                      color: Colors.lightBlue,
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
                                          'Humidity', '${_weather?.humidity}%', Icons.water)),
                                  Expanded(
                                      child: _buildWeatherDetail(
                                          'Wind', '${_weather?.windSpeed} km/h', Icons.air)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                      child: _buildWeatherDetail(
                                          'Pressure', '${_weather?.pressure} hPa', Icons.speed)),
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
                          height: 200, // Slightly increased height to fix overflow
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _forecast!.items.length > 7 ? 7 : _forecast!.items.length,
                            itemBuilder: (context, index) {
                              final item = _forecast!.items[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                elevation: 6,
                                shadowColor: Colors.blue.withOpacity(0.2),
                                child: Container(
                                  width: 160,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    gradient: LinearGradient(
                                      colors: [Colors.lightBlueAccent, Colors.orangeAccent],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade200.withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Time
                                      Text(
                                        '${item.dateTime.hour}:00',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 6),

                                      // Weather Icon
                                      Image.network(
                                        item.getIconUrl(),
                                        height: 50,
                                        width: 50,
                                      ),
                                      SizedBox(height: 6),

                                      // Temperature
                                      Text(
                                        '${item.temperature.toStringAsFixed(1)}°C',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                        ),
                                      ),

                                      // Feels Like
                                      Text(
                                        'Feels like ${item.feelsLike.toStringAsFixed(1)}°C',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),

                                      SizedBox(height: 4),

                                      // Weather Description (Capitalized)
                                      Text(
                                        item.description[0].toUpperCase() + item.description.substring(1),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue.shade700,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
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
