import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class WeatherService {
  // Helper method to safely convert numeric values
  static double toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String city) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/weather?q=$city&units=metric&appid=$apiKey'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('Weather API response: ${response.body}');
        try {
          return Weather.fromJson(jsonDecode(response.body));
        } catch (e) {
          print('JSON parse error in weather: $e');
          print('Raw response: ${response.body}');
          rethrow;
        }
      } else {
        print('Weather API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on SocketException {
      print('No internet connection');
      throw Exception('No internet connection');
    } on HttpException {
      print('HTTP error occurred');
      throw Exception('HTTP error occurred');
    } on FormatException {
      print('Invalid response format');
      throw Exception('Invalid response format');
    } catch (e) {
      print('Unknown error: $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<ForecastData> getForecast(String city) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/forecast?q=$city&units=metric&appid=$apiKey'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('Forecast API response: ${response.body}');
        try {
          return ForecastData.fromJson(jsonDecode(response.body));
        } catch (e) {
          print('JSON parse error in forecast: $e');
          print('Raw response: ${response.body}');
          rethrow;
        }
      } else {
        print('Forecast API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } on SocketException {
      print('No internet connection');
      throw Exception('No internet connection');
    } on HttpException {
      print('HTTP error occurred');
      throw Exception('HTTP error occurred');
    } on FormatException {
      print('Invalid response format');
      throw Exception('Invalid response format');
    } catch (e) {
      print('Unknown error: $e');
      throw Exception('Unknown error occurred: $e');
    }
  }
}

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    try {
      return Weather(
          cityName: json['name'] ?? 'Unknown',
          temperature: WeatherService.toDouble(json['main']?['temp']),
          description: json['weather']?[0]?['description'] ?? 'Unknown',
          iconCode: json['weather']?[0]?['icon'] ?? '01d',
          feelsLike: WeatherService.toDouble(json['main']?['feels_like']),
          humidity: json['main']?['humidity'] ?? 0,
          windSpeed: WeatherService.toDouble(json['wind']?['speed']),
          pressure: json['main']?['pressure'] ?? 0);
    } catch (e) {
      print('Error parsing Weather JSON: $e');
      rethrow;
    }
  }

  String getIconUrl() {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}

class ForecastData {
  final List<ForecastItem> items;
  final String cityName;

  ForecastData({
    required this.items,
    required this.cityName,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> list = json['list'] ?? [];
      final items = <ForecastItem>[];

      for (var item in list) {
        try {
          items.add(ForecastItem.fromJson(item));
        } catch (e) {
          print('Error parsing individual forecast item: $e');
          // Continue with other items even if one fails
        }
      }

      return ForecastData(
        cityName: json['city']?['name'] ?? 'Unknown',
        items: items,
      );
    } catch (e) {
      print('Error parsing ForecastData: $e');
      // Return empty forecast data instead of throwing
      return ForecastData(
        cityName: 'Unknown',
        items: [],
      );
    }
  }
}

class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final int pressure;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
    required this.pressure,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    try {
      return ForecastItem(
        dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
        temperature: WeatherService.toDouble(json['main']?['temp']),
        feelsLike: WeatherService.toDouble(json['main']?['feels_like']),
        description: json['weather']?[0]?['description'] ?? 'Unknown',
        humidity: json['main']?['humidity'] ?? 0,
        windSpeed: WeatherService.toDouble(json['wind']?['speed']),
        pressure: json['main']?['pressure'] ?? 0,
        iconCode: json['weather']?[0]?['icon'] ?? '01d',
      );
    } catch (e) {
      print('Error parsing ForecastItem JSON: $e');
      rethrow;
    }
  }

  String getIconUrl() {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
