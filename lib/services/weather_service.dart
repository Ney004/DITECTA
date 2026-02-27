import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherService {
  final String apiKey = '1c1afc0e0c386417bcf79648ed4d2048';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData?> getWeather(String city) async {
    try {
      final url = Uri.parse(
        '$baseUrl?q=$city&appid=$apiKey&units=metric&lang=es',
      );

      debugPrint('=== LLAMANDO A API ===');
      debugPrint('URL: $url');

      final response = await http.get(url);

      debugPrint('Status Code: ${response.statusCode}');

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

// Modelo de datos del clima CORREGIDO
class WeatherData {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;
  final int clouds;
  final String description;
  final String icon;
  final String cityName;
  final String sunrise;
  final String sunset;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.clouds,
    required this.description,
    required this.icon,
    required this.cityName,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    String sunriseStr = '--:--';
    String sunsetStr = '--:--';

    try {
      // Convertir timestamps de sunrise y sunset con manejo de null
      if (json['sys'] != null && json['sys']['sunrise'] != null) {
        final sunriseTime = DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunrise'] as int) * 1000,
        );
        final timeFormat = DateFormat('HH:mm');
        sunriseStr = timeFormat.format(sunriseTime);
      }

      if (json['sys'] != null && json['sys']['sunset'] != null) {
        final sunsetTime = DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunset'] as int) * 1000,
        );
        final timeFormat = DateFormat('HH:mm');
        sunsetStr = timeFormat.format(sunsetTime);
      }
    } catch (e) {
      debugPrint('Error al parsear sunrise/sunset: $e');
    }

    return WeatherData(
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      visibility: json['visibility'] ?? 10000,
      clouds: json['clouds']?['all'] ?? 0,
      description: json['weather']?[0]?['description'] ?? 'Sin descripción',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      cityName: json['name'] ?? 'Desconocido',
      sunrise: sunriseStr,
      sunset: sunsetStr,
    );
  }
}
