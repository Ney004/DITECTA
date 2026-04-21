import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/classification_service.dart';
import 'camera_screen.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  final ClassificationResult result;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar animación de crecimiento inicial
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800), // 0.8 segundos
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack, // Efecto de "rebote" suave al final
    );

    // Iniciar animación automáticamente al cargar la pantalla
    Future.delayed(Duration(milliseconds: 400), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Obtener severidad (saludable, leve, moderada, grave)
  String _getSeverity(String label) {
    if (label.contains('saludable')) return 'saludable';
    if (label.contains('leve')) return 'leve';
    if (label.contains('moderada')) return 'moderada';
    if (label.contains('grave')) return 'grave';
    return 'desconocido';
  }

  // Obtener tipo de enfermedad (Sigatoka Negra o Cordana)
  String _getDiseaseType(String label) {
    if (label.contains('cordana')) return 'Cordana';
    if (label.contains('sigatoka') ||
        label.contains('grave') ||
        label.contains('leve') ||
        label.contains('moderada')) {
      // Si NO es cordana pero es enfermo, es Sigatoka
      if (!label.contains('cordana') && !label.contains('saludable')) {
        return 'Sigatoka Negra';
      }
    }
    if (label.contains('saludable')) return 'Hoja Saludable';
    return 'Enfermedad Detectada';
  }

  // Obtener nombre a mostrar en el círculo (solo severidad)
  String _getCircleDisplayName(String severity) {
    switch (severity) {
      case 'saludable':
        return 'SALUDABLE';
      case 'leve':
        return 'LEVE';
      case 'moderada':
        return 'MODERADA';
      case 'grave':
        return 'GRAVE';
      default:
        return 'DESCONOCIDO';
    }
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
  String _getDescription(String diseaseType, String severity) {
    if (severity == 'saludable') {
      return 'La planta muestra signos de buena salud. Continúa con los cuidados regulares y el monitoreo preventivo.';
    }

    if (diseaseType == 'Sigatoka Negra') {
      switch (severity) {
        case 'leve':
          return 'Manchas rojizo-amarronadas características observadas. El nivel de infección sugiere que se necesitan controles inmediatos para prevenir la propagación.';
        case 'moderada':
          return 'Manchas rojizo-amarronadas avanzadas. La infección ha progresado significativamente. Se requiere tratamiento fungicida inmediato.';
        case 'grave':
          return 'Nivel crítico de Sigatoka Negra. Las hojas muestran necrosis severa. Requiere tratamiento urgente y aislamiento de plantas afectadas.';
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
    final topPred = widget.result.topPrediction;
    final severity = _getSeverity(topPred.label);
    final diseaseType = _getDiseaseType(topPred.label);
    final color = _getColorForSeverity(severity);
    final confidence = topPred.confidence * 100;

    // Título para el CÍRCULO - solo severidad
    String circleTitle = _getCircleDisplayName(severity);

    // Título para la TARJETA - tipo de enfermedad
    String cardTitle = diseaseType;

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
          'Resultado de Escaneo',
          style: TextStyle(
            color: Color(0XFF323846),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // CÍRCULO DE PROGRESO CON ESTADO Y ANIMACIÓN
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Círculo animado
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(220, 220),
                          painter: SeverityCirclePainter(
                            severity: severity,
                            animationValue: _scaleAnimation.value,
                          ),
                        );
                      },
                    ),

                    // Contenido central
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ESTADO',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          circleTitle,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${confidence.toStringAsFixed(0)}% Confianza',
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

            const SizedBox(height: 16),

            // BARRA DE ESTADOS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStateIndicator('Saludable', 'saludable', severity),
                  _buildStateIndicator('Leve', 'leve', severity),
                  _buildStateIndicator('Moderada', 'moderada', severity),
                  _buildStateIndicator('Grave', 'grave', severity),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TARJETA DE INFORMACIÓN
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFfafaf5),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  // Texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cardTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8fbc18),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          textAlign: TextAlign.start,
                          _getDescription(diseaseType, severity),
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff323846),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Color(0xFF8fbc18).withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sector 4, Main Farm',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8fbc18).withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Color(0xFF8fbc18).withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getCurrentTime(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8fbc18).withValues(alpha: 0.7),
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
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Estira los botones a lo ancho
                children: [
                  // Botón Retake
                  OutlinedButton.icon(
                    onPressed: () async {
                      // El código que corregimos anteriormente con Navigator.push
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraScreen(),
                        ),
                      ).then((imagePath) async {
                        if (imagePath != null && context.mounted) {
                          // Mostrar overlay de análisis
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Container(
                                color: Colors.black54,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFF8fbc18),
                                            ),
                                        strokeWidth: 4,
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              '🔬 Analizando imagen...',
                                              style: TextStyle(
                                                color: Color(0xFF323846),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Detectando enfermedades',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          try {
                            // Analizar imagen
                            final classifier = ClassificationService();
                            final result = await classifier.classifyImage(
                              imagePath,
                            );

                            if (context.mounted) {
                              // Cerrar loading
                              Navigator.pop(context);

                              // Navegar a nueva pantalla de resultados
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                    imagePath: imagePath,
                                    result: result,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              // Cerrar loading
                              Navigator.pop(context);

                              // Mostrar error y volver al home
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al analizar imagen: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );

                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            }
                          }
                        } else {
                          // Si no se tomó foto, volver al home
                          if (context.mounted) {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          }
                        }
                      });
                    },
                    icon: Icon(Icons.refresh, size: 20),
                    label: Text('Tomar de Nuevo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF8fbc18),
                      side: BorderSide(color: Color(0xFF8fbc18), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Cambiamos el SizedBox a 'height' para separar de arriba hacia abajo
                  const SizedBox(height: 16),

                  // Botón Guardar
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Resultado guardado'),
                          backgroundColor: Color(0xFF8fbc18),
                        ),
                      );
                    },
                    icon: Icon(Icons.save, size: 20),
                    label: Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8fbc18),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
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

// CUSTOM PAINTER PARA EL CÍRCULO DE SEVERIDAD CON ANIMACIÓN
class SeverityCirclePainter extends CustomPainter {
  final String severity;
  final double animationValue;

  SeverityCirclePainter({required this.severity, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Definir los 4 colores
    final colors = [
      Color(0xFF4CAF50), // Verde - Saludable
      Color(0xFFFFEB3B), // Amarillo - Leve
      Color(0xFFFF9800), // Naranja - Moderado
      Color(0xFFF44336), // Rojo - Grave
    ];

    final activeIndex = _getActiveIndex(severity);

    // GROSOR BASE: Todos comienzan con el mismo grosor
    final baseStrokeWidth = 18.0;
    final targetActiveWidth = 26.0; // Grosor final del segmento activo

    // Calcular grosor actual del segmento activo basado en animationValue
    // animationValue va de 0.0 (inicio) a 1.0 (final)
    final activeStrokeWidth =
        baseStrokeWidth +
        (targetActiveWidth - baseStrokeWidth) * animationValue;

    // 1. DIBUJAR SEGMENTOS INACTIVOS (siempre mismo grosor)
    final inactivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = baseStrokeWidth
      ..strokeCap = StrokeCap.butt;

    for (int i = 0; i < 4; i++) {
      if (i == activeIndex) continue;

      inactivePaint.color = colors[i];
      final rect = Rect.fromCircle(center: center, radius: radius);

      final startAngle = (-math.pi / 2) + (i * math.pi / 2);
      final sweepAngle = math.pi / 2;

      canvas.drawArc(rect, startAngle, sweepAngle, false, inactivePaint);
    }

    // 2. DIBUJAR SEGMENTO ACTIVO (crece con la animación)
    // Radio ajustado para compensar el grosor extra
    final radiusAdjustment = (activeStrokeWidth - baseStrokeWidth) / 2;
    final activeRadius = radius + radiusAdjustment;

    final angleOverlap = 0.04;

    final activePaint = Paint()
      ..color = colors[activeIndex]
      ..style = PaintingStyle.stroke
      ..strokeWidth = activeStrokeWidth
      ..strokeCap = StrokeCap.butt;

    final activeRect = Rect.fromCircle(center: center, radius: activeRadius);

    final activeStartAngle =
        (-math.pi / 2) + (activeIndex * math.pi / 2) - angleOverlap;
    final activeSweepAngle = (math.pi / 2) + (2 * angleOverlap);

    canvas.drawArc(
      activeRect,
      activeStartAngle,
      activeSweepAngle,
      false,
      activePaint,
    );
  }

  int _getActiveIndex(String severity) {
    switch (severity) {
      case 'saludable':
        return 0;
      case 'leve':
        return 1;
      case 'moderada':
        return 2;
      case 'grave':
        return 3;
      default:
        return 0;
    }
  }

  @override
  bool shouldRepaint(covariant SeverityCirclePainter oldDelegate) {
    return oldDelegate.severity != severity ||
        oldDelegate.animationValue != animationValue;
  }
}
