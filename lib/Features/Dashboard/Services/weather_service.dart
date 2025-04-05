import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?q=$city&units=metric&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {

      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  Future<ForecastData> getForecast(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forecast?q=$city&units=metric&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return ForecastData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
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
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure']
    );
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
    final List<dynamic> list = json['list'];

    return ForecastData(
      cityName: json['city']['name'],
      items: list.map((item) => ForecastItem.fromJson(item)).toList(),
    );
  }
}

class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final String iconCode;
  final double pressure;

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
    return ForecastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      iconCode: json['weather'][0]['icon'],
    );
  }

  String getIconUrl() {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}

