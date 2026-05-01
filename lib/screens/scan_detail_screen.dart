import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/scan_model.dart';

class ScanDetailScreen extends StatefulWidget {
  final ScanModel scan;

  const ScanDetailScreen({super.key, required this.scan});

  @override
  State<ScanDetailScreen> createState() => _ScanDetailScreenState();
}

class _ScanDetailScreenState extends State<ScanDetailScreen>
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
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────

  String _getSeverityKey() => widget.scan.severity.toLowerCase();

  Color _getColorForSeverity(String severity) {
    switch (severity.toLowerCase()) {
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

  String _getCircleDisplayName(String severity) {
    switch (severity.toLowerCase()) {
      case 'saludable':
        return 'SALUDABLE';
      case 'leve':
        return 'LEVE';
      case 'moderada':
        return 'MODERADA';
      case 'grave':
        return 'GRAVE';
      default:
        return severity.toUpperCase();
    }
  }

  String _getDescription() {
    final severity = _getSeverityKey();
    final diseaseType = widget.scan.diseaseType;

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
    final severity = _getSeverityKey();
    final color = _getColorForSeverity(severity);
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
        title: Text(
          widget.scan.title,
          style: const TextStyle(
            color: Color(0xFF323846),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── IMAGEN DEL ESCANEO ──────────────────────────────────
            if (widget.scan.imagePath.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(widget.scan.imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.eco,
                        color: Colors.green[700],
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // ── CÍRCULO DE SEVERIDAD ────────────────────────────────
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (_, _) => CustomPaint(
                        size: const Size(220, 220),
                        painter: DetailCirclePainter(
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
                          '${widget.scan.confidence.toStringAsFixed(0)}% Confianza',
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

            // ── BARRA DE ESTADOS ────────────────────────────────────
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

            // ── TARJETA DE INFORMACIÓN ──────────────────────────────
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
                    widget.scan.diseaseType,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8fbc18),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getDescription(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF323846),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Metadatos
                  _buildMetaRow(
                    Icons.label_outline,
                    'Nombre',
                    widget.scan.title,
                  ),
                  const SizedBox(height: 8),
                  _buildMetaRow(
                    Icons.location_on_outlined,
                    'Sector / Lote',
                    widget.scan.sector.isNotEmpty
                        ? widget.scan.sector
                        : 'Sin sector',
                  ),
                  const SizedBox(height: 8),
                  _buildMetaRow(
                    Icons.calendar_today_outlined,
                    'Fecha',
                    widget.scan.date,
                  ),
                  const SizedBox(height: 8),
                  _buildMetaRow(
                    Icons.analytics_outlined,
                    'Confianza',
                    '${widget.scan.confidence.toStringAsFixed(1)}%',
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

  Widget _buildMetaRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8fbc18)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF323846),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
      ],
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

class DetailCirclePainter extends CustomPainter {
  final String severity;
  final double animationValue;

  DetailCirclePainter({required this.severity, required this.animationValue});

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
    switch (severity.toLowerCase()) {
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
  bool shouldRepaint(covariant DetailCirclePainter old) =>
      old.severity != severity || old.animationValue != animationValue;
}
