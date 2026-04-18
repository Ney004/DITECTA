import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/classification_service.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final ClassificationResult result;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  // Obtener severidad (saludable, leve, moderada, grave)
  String _getSeverity(String label) {
    if (label.contains('saludable')) return 'saludable';
    if (label.contains('leve')) return 'leve';
    if (label.contains('moderada')) return 'moderada';
    if (label.contains('grave')) return 'grave';
    return 'desconocido';
  }

  // Obtener tipo de enfermedad (sigatoka o cordana)
  String? _getDiseaseType(String label) {
    if (label.contains('sigatoka')) return 'Sigatoka';
    if (label.contains('cordana')) return 'Cordana';
    return null;
  }

  // Obtener color según severidad
  Color _getColorForSeverity(String severity) {
    switch (severity) {
      case 'saludable':
        return Color(0xFF4CAF50); // Verde
      case 'leve':
        return Color(0xFFFFEB3B); // Amarillo
      case 'moderada':
        return Color(0xFFFF9800); // Naranja
      case 'grave':
        return Color(0xFFF44336); // Rojo
      default:
        return Colors.grey;
    }
  }

  // Obtener descripción según tipo y severidad
  String _getDescription(String? diseaseType, String severity) {
    if (severity == 'saludable') {
      return 'La planta muestra signos de buena salud. Continúa con los cuidados regulares y el monitoreo preventivo.';
    }

    if (diseaseType == 'Sigatoka') {
      switch (severity) {
        case 'leve':
          return 'Manchas rojizo-amarronadas características observadas. El nivel de infección sugiere que se necesitan controles inmediatos para prevenir la propagación.';
        case 'moderada':
          return 'Manchas rojizo-amarronadas avanzadas. La infección ha progresado significativamente. Se requiere tratamiento fungicida inmediato.';
        case 'grave':
          return 'Nivel crítico de Sigatoka. Las hojas muestran necrosis severa. Requiere tratamiento urgente y aislamiento de plantas afectadas.';
      }
    }

    if (diseaseType == 'Cordana') {
      switch (severity) {
        case 'leve':
          return 'Síntomas tempranos de Cordana detectados. Monitorear de cerca y aplicar tratamiento preventivo.';
        case 'moderada':
          return 'Infección moderada de Cordana. Se recomienda aplicación de fungicida y mejora de ventilación.';
        case 'grave':
          return 'Infección grave de Cordana. Tratamiento urgente requerido. Considerar eliminación de tejido muy afectado.';
      }
    }

    return 'Enfermedad detectada. Se recomienda consultar con un especialista.';
  }

  @override
  Widget build(BuildContext context) {
    final topPred = result.topPrediction;
    final severity = _getSeverity(topPred.label);
    final diseaseType = _getDiseaseType(topPred.label);
    final color = _getColorForSeverity(severity);
    final confidence = topPred.confidence * 100;

    // Título para mostrar
    String displayTitle = severity.toUpperCase();
    if (diseaseType != null) {
      displayTitle = diseaseType;
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detection Result',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // CÍRCULO DE PROGRESO CON ESTADO
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Círculo de fondo con gradiente
                    CustomPaint(
                      size: Size(220, 220),
                      painter: SeverityCirclePainter(severity: severity),
                    ),

                    // Contenido central
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'STATUS',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          displayTitle,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${confidence.toStringAsFixed(0)}% Confidence',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // BARRA DE ESTADOS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStateIndicator('HEALTHY', 'saludable', severity),
                  _buildStateIndicator('MILD', 'leve', severity),
                  _buildStateIndicator('MODERATE', 'moderada', severity),
                  _buildStateIndicator('SEVERE', 'grave', severity),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // TARJETA DE INFORMACIÓN
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF5A7A7C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      diseaseType != null
                          ? Icons.warning_amber
                          : Icons.check_circle,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          diseaseType ?? 'Hoja Saludable',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getDescription(diseaseType, severity),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sector 4, Main Farm',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getCurrentTime(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // BOTONES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Botón Retake
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.refresh, size: 20),
                      label: Text('Retake'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF5A7A7C),
                        side: BorderSide(color: Color(0xFF5A7A7C), width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Botón Guardar
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Resultado guardado'),
                            backgroundColor: Color(0xFF4CAF50),
                          ),
                        );
                      },
                      icon: Icon(Icons.save, size: 20),
                      label: Text('Guardar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5A7A7C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ENLACE A EXPERT HELP
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Conectando con experto...'),
                    backgroundColor: Color(0xFF5A7A7C),
                  ),
                );
              },
              icon: Icon(
                Icons.help_outline,
                size: 18,
                color: Color(0xFF5A7A7C),
              ),
              label: Text(
                'Expert Help',
                style: TextStyle(
                  color: Color(0xFF5A7A7C),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Widget para indicadores de estado
  Widget _buildStateIndicator(String label, String state, String currentState) {
    final isActive = state == currentState;
    final color = _getColorForSeverity(state);

    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.grey[300],
            border: Border.all(
              color: isActive ? color : Colors.grey[400]!,
              width: isActive ? 3 : 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? color : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${now.minute.toString().padLeft(2, '0')} $period';
  }
}

// CUSTOM PAINTER PARA EL CÍRCULO DE SEVERIDAD
class SeverityCirclePainter extends CustomPainter {
  final String severity;

  SeverityCirclePainter({required this.severity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Colores del gradiente según severidad
    final colors = _getGradientColors(severity);

    // Pintar círculo de fondo gris claro
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(center, radius, bgPaint);

    // Pintar arco con gradiente
    final rect = Rect.fromCircle(center: center, radius: radius);

    final gradient = SweepGradient(
      colors: colors,
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    // Dibujar arco completo
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, paint);
  }

  List<Color> _getGradientColors(String severity) {
    // Colores: Verde → Amarillo → Naranja → Rojo
    return [
      Color(0xFF4CAF50), // Verde (saludable)
      Color(0xFFFFEB3B), // Amarillo (leve)
      Color(0xFFFF9800), // Naranja (moderada)
      Color(0xFFF44336), // Rojo (grave)
    ];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
