import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherDetail extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetail({super.key, required this.weatherData});

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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF5),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          weatherData.cityName,
          style: const TextStyle(
            color: Color(0xFF323846),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TEMPERATURA PRINCIPAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAF5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    _getWeatherIcon(weatherData.icon),
                    size: 100,
                    color: _getWeatherColor(weatherData.icon),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${weatherData.temperature.toStringAsFixed(1)}°C",
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8fbc18),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weatherData.description.toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // DETALLES DEL CLIMA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DETALLES",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GRID DE DETALLES
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _DetailCard(
                        icon: Icons.water_drop_outlined,
                        title: "Humedad",
                        value: "${weatherData.humidity}%",
                        color: Color(0xFF8fbc18),
                      ),
                      _DetailCard(
                        icon: Icons.air,
                        title: "Viento",
                        value:
                            "${weatherData.windSpeed.toStringAsFixed(1)} km/h",
                        color: Color(0xFF8fbc18),
                      ),
                      _DetailCard(
                        icon: Icons.compress,
                        title: "Presión",
                        value: "${weatherData.pressure} hPa",
                        color: Color(0xFF8fbc18),
                      ),
                      _DetailCard(
                        icon: Icons.thermostat,
                        title: "Sensación",
                        value: "${weatherData.feelsLike.toStringAsFixed(1)}°C",
                        color: Color(0xFF8fbc18),
                      ),
                      _DetailCard(
                        icon: Icons.visibility_outlined,
                        title: "Visibilidad",
                        value:
                            "${(weatherData.visibility / 1000).toStringAsFixed(1)} km",
                        color: Color(0xFF8fbc18),
                      ),
                      _DetailCard(
                        icon: Icons.cloud_outlined,
                        title: "Nubosidad",
                        value: "${weatherData.clouds}%",
                        color: Color(0xFF8fbc18),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // SOL
                  const Text(
                    "SOL",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAF5),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SunTimeCard(
                          icon: Icons.wb_sunny,
                          title: "Amanecer",
                          time: weatherData.sunrise,
                          color: Color(0xFF8fbc18),
                        ),
                        Container(
                          width: 1,
                          height: 60,
                          color: Colors.grey[300],
                        ),
                        _SunTimeCard(
                          icon: Icons.nights_stay,
                          title: "Atardecer",
                          time: weatherData.sunset,
                          color: Color(0xFF8fbc18),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET DE TARJETA DE DETALLE
class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF323846),
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET DE HORA DEL SOL
class _SunTimeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final Color color;

  const _SunTimeCard({
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF323846),
          ),
        ),
      ],
    );
  }
}
