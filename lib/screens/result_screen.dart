import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/classification_service.dart';
import 'camera_screen.dart';
import '../services/database_service.dart';
import '../models/scan_model.dart';
import 'home.dart';

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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _getSeverity(String label) {
    if (label.contains('saludable')) return 'saludable';
    if (label.contains('leve')) return 'leve';
    if (label.contains('moderada')) return 'moderada';
    if (label.contains('grave')) return 'grave';
    return 'desconocido';
  }

  String _getDiseaseType(String label) {
    if (label.contains('cordana')) return 'Cordana';
    if (!label.contains('cordana') &&
        !label.contains('saludable') &&
        (label.contains('sigatoka') ||
            label.contains('grave') ||
            label.contains('leve') ||
            label.contains('moderada'))) {
      return 'Sigatoka Negra';
    }
    if (label.contains('saludable')) return 'Hoja Saludable';
    return 'Enfermedad Detectada';
  }

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

  Color _getColorForSeverity(String severity) {
    switch (severity) {
      case 'saludable':
        return const Color(0xFF4CAF50);
      case 'leve':
        return const Color(0xFFFFEB3B);
      case 'moderada':
        return const Color(0xFFFF9800);
      case 'grave':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

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

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${now.minute.toString().padLeft(2, '0')} $period';
  }

  // ── Guardar en base de datos ────────────────────────────────────────────────

  Future<void> _saveScanToDatabase({
    required String customName,
    required String customSector,
  }) async {
    final topPred = widget.result.topPrediction;
    final severity = _getSeverity(topPred.label);
    final disease = _getDiseaseType(topPred.label);
    final now = DateTime.now();

    final scan = ScanModel(
      title: customName,
      date: '${now.day}/${now.month}/${now.year} • ${_getCurrentTime()}',
      timeAgo: 'Ahora',
      severity: severity[0].toUpperCase() + severity.substring(1),
      diseaseType: disease,
      imagePath: widget.imagePath,
      confidence: topPred.confidence * 100,
      sector: customSector,
      scannedAt: now,
    );

    await DatabaseService().saveScan(scan);
  }

  // ── Diálogo de guardado ─────────────────────────────────────────────────────

  Future<void> _showSaveDialog() async {
    final nameController = TextEditingController();
    final sectorController = TextEditingController();

    // Capturar referencias ANTES de cualquier await
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Guardar escaneo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323846),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Opcional: agrega un nombre y la ubicación de la planta',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Campo nombre
              TextFormField(
                controller: nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Nombre / Etiqueta',
                  hintText: 'Ej: Planta norte, Mata 12... (opcional)',
                  prefixIcon: const Icon(
                    Icons.label_outline,
                    color: Color(0xFF8fbc18),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF8fbc18),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo sector / lote
              TextFormField(
                controller: sectorController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Sector / Lote',
                  hintText: 'Ej: Lote 3, Sector norte... (opcional)',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF8fbc18),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF8fbc18),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8fbc18),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      // Número correlativo basado en escaneos existentes
      final scanNumber = DatabaseService().getAllScans().length + 1;

      final name = nameController.text.trim().isNotEmpty
          ? nameController.text.trim()
          : 'Scaneo #$scanNumber';

      final sector = sectorController.text.trim();

      await _saveScanToDatabase(customName: name, customSector: sector);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Resultado guardado'),
          backgroundColor: Color(0xFF8fbc18),
        ),
      );

      // Redirigir al home limpiando el stack
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
      );
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPred = widget.result.topPrediction;
    final severity = _getSeverity(topPred.label);
    final diseaseType = _getDiseaseType(topPred.label);
    final color = _getColorForSeverity(severity);
    final confidence = topPred.confidence * 100;
    final circleTitle = _getCircleDisplayName(severity);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Resultado de Escaneo',
          style: TextStyle(
            color: Color(0xFF323846),
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

            // ── CÍRCULO DE SEVERIDAD ──────────────────────────────────
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) => CustomPaint(
                        size: const Size(220, 220),
                        painter: SeverityCirclePainter(
                          severity: severity,
                          animationValue: _scaleAnimation.value,
                        ),
                      ),
                    ),
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

            // ── BARRA DE ESTADOS ──────────────────────────────────────
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

            // ── TARJETA DE INFORMACIÓN ────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFfafaf5),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    diseaseType,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8fbc18),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getDescription(diseaseType, severity),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF323846),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: const Color(0xFF8fbc18).withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getCurrentTime(),
                        style: TextStyle(
                          fontSize: 11,
                          color: const Color(0xFF8fbc18).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── BOTONES ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botón Tomar de Nuevo
                  OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CameraScreen()),
                      ).then((imagePath) async {
                        if (imagePath != null && context.mounted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Container(
                              color: Colors.black54,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
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
                            ),
                          );

                          try {
                            final classifier = ClassificationService();
                            final result = await classifier.classifyImage(
                              imagePath,
                            );

                            if (context.mounted) {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ResultScreen(
                                    imagePath: imagePath,
                                    result: result,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(context);
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
                          if (context.mounted) {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          }
                        }
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('Tomar de Nuevo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8fbc18),
                      side: const BorderSide(
                        color: Color(0xFF8fbc18),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botón Guardar
                  ElevatedButton.icon(
                    onPressed: _showSaveDialog,
                    icon: const Icon(Icons.save, size: 20),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8fbc18),
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
}

// ── CUSTOM PAINTER ──────────────────────────────────────────────────────────

class SeverityCirclePainter extends CustomPainter {
  final String severity;
  final double animationValue;

  SeverityCirclePainter({required this.severity, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFFFFEB3B),
      const Color(0xFFFF9800),
      const Color(0xFFF44336),
    ];

    final activeIndex = _getActiveIndex(severity);
    const baseStrokeWidth = 18.0;
    const targetActiveWidth = 26.0;
    final activeStrokeWidth =
        baseStrokeWidth +
        (targetActiveWidth - baseStrokeWidth) * animationValue;

    final inactivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = baseStrokeWidth
      ..strokeCap = StrokeCap.butt;

    for (int i = 0; i < 4; i++) {
      if (i == activeIndex) continue;
      inactivePaint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        (-math.pi / 2) + (i * math.pi / 2),
        math.pi / 2,
        false,
        inactivePaint,
      );
    }

    final radiusAdjustment = (activeStrokeWidth - baseStrokeWidth) / 2;
    const angleOverlap = 0.04;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + radiusAdjustment),
      (-math.pi / 2) + (activeIndex * math.pi / 2) - angleOverlap,
      (math.pi / 2) + (2 * angleOverlap),
      false,
      Paint()
        ..color = colors[activeIndex]
        ..style = PaintingStyle.stroke
        ..strokeWidth = activeStrokeWidth
        ..strokeCap = StrokeCap.butt,
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
  bool shouldRepaint(covariant SeverityCirclePainter oldDelegate) =>
      oldDelegate.severity != severity ||
      oldDelegate.animationValue != animationValue;
}
