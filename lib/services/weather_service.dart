import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      '1c1afc0e0c386417bcf79648ed4d2048'; // ← Reemplaza con tu API key
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData?> getWeather(String city) async {
    try {
      final url = Uri.parse(
        '$baseUrl?q=$city&appid=$apiKey&units=metric&lang=es',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        debugPrint('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error al obtener clima: $e');
      return null;
    }
  }

  // Obtener clima por coordenadas
  Future<WeatherData?> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=es',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        debugPrint('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error al obtener clima: $e');
      return null;
    }
  }
}

// Modelo de datos del clima
class WeatherData {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final String cityName;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.cityName,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      cityName: json['name'],
    );
  }
}
