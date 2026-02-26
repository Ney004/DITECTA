import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final WeatherService _weatherService = WeatherService();
  WeatherData? _weatherData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    // TEMPORAL: Datos de prueba
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _weatherData = WeatherData(
          temperature: 26.0,
          humidity: 60,
          windSpeed: 12.0,
          description: "parcialmente nublado",
          icon: "02d",
          cityName: "Medellín",
        );
        _isLoading = false;
      });
    }
  }

  IconData _getWeatherIcon(String? icon) {
    if (icon == null) return Icons.wb_sunny_rounded;

    switch (icon.substring(0, 2)) {
      case '01':
        return Icons.wb_sunny_rounded;
      case '02':
      case '03':
      case '04':
        return Icons.cloud_rounded;
      case '09':
      case '10':
        return Icons.water_drop_rounded;
      case '11':
        return Icons.thunderstorm_rounded;
      case '13':
        return Icons.ac_unit_rounded;
      case '50':
        return Icons.foggy;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  Color _getWeatherColor(String? icon) {
    if (icon == null) return Colors.orange;

    switch (icon.substring(0, 2)) {
      case '01':
        return Colors.orange;
      case '02':
      case '03':
      case '04':
        return Colors.grey;
      case '09':
      case '10':
        return Colors.blue;
      case '11':
        return Colors.deepPurple;
      case '13':
        return Colors.lightBlue;
      case '50':
        return Colors.blueGrey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.fromLTRB(5, 20, 5, 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF8fbc18)),
            )
          : _weatherData == null
          ? const Center(
              child: Text(
                "No se pudo cargar el clima",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Info clima
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_weatherData!.temperature.toStringAsFixed(1)}°C",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8fbc18),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _weatherData!.description.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Humedad: ${_weatherData!.humidity}%",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        "Viento: ${_weatherData!.windSpeed.toStringAsFixed(1)} km/h",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // Icono
                Icon(
                  _getWeatherIcon(_weatherData!.icon),
                  size: 60,
                  color: _getWeatherColor(_weatherData!.icon),
                ),
              ],
            ),
    );
  }
}
