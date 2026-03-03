import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isTakingPicture = false;
  bool _flashOn = false;
  bool _showBanner = false;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se encontró ninguna cámara'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        }
        return;
      }

      final camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        _showTemporaryBanner();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al inicializar cámara: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  void _showTemporaryBanner() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showBanner = true;
        });
      }
    });

    _bannerTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showBanner = false;
        });
      }
    });
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    try {
      setState(() {
        _flashOn = !_flashOn;
      });

      await _controller!.setFlashMode(
        _flashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('Error al cambiar flash: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    setState(() {
      _isTakingPicture = true;
    });

    try {
      if (_flashOn) {
        await _controller!.setFlashMode(FlashMode.off);
      }

      final XFile image = await _controller!.takePicture();

      final Directory tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = path.join(tempDir.path, 'IMG_$timestamp.jpg');

      await File(image.path).copy(filePath);

      if (mounted) {
        Navigator.pop(context, filePath);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al tomar foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF8fbc18)),
              const SizedBox(height: 16),
              Text(
                "Inicializando cámara...",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // PREVIEW DE LA CÁMARA
          SizedBox.expand(child: CameraPreview(_controller!)),

          // OVERLAY CON GUÍAS
          CustomPaint(painter: CameraOverlayPainter(), child: Container()),

          // CONTROLES
          SafeArea(
            child: Column(
              children: [
                // HEADER
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // BOTÓN CERRAR
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),

                      // BOTÓN FLASH
                      Container(
                        decoration: BoxDecoration(
                          color: _flashOn ? Color(0xFFFF5252) : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _toggleFlash,
                          icon: Icon(
                            _flashOn ? Icons.flash_on : Icons.flash_off,
                            color: _flashOn ? Colors.white : Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // BANNER DE INSTRUCCIONES CON ANIMACIÓN E IGNOREPOINTER
                IgnorePointer(
                  ignoring: !_showBanner,
                  child: AnimatedSlide(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    offset: _showBanner ? Offset.zero : Offset(0, -1),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 400),
                      opacity: _showBanner ? 1.0 : 0.0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF8fbc18).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.eco,
                                color: Color(0xFF8fbc18),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Alinea la hoja dentro del marco",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "DETECTANDO ENFERMEDADES",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // BOTÓN DE CAPTURA
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                    onTap: _isTakingPicture ? null : _takePicture,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isTakingPicture
                            ? Colors.grey
                            : Color(0xFF4CAF50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _isTakingPicture
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 32,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// PAINTER PARA OVERLAY CON GUÍAS
class CameraOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final double rectWidth = size.width * 0.85;
    final double rectHeight = size.height * 0.65;
    final double left = (size.width - rectWidth) / 2;
    final double top = (size.height - rectHeight) / 2;

    final rect = Rect.fromLTWH(left, top, rectWidth, rectHeight);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(20)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, darkPaint);

    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final cornerLength = 40.0;

    // Esquina superior izquierda
    canvas.drawLine(
      Offset(rect.left, rect.top + 20),
      Offset(rect.left, rect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      cornerPaint,
    );

    // Esquina superior derecha
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right - cornerLength, rect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + 20),
      cornerPaint,
    );

    // Esquina inferior izquierda
    canvas.drawLine(
      Offset(rect.left, rect.bottom - 20),
      Offset(rect.left, rect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      cornerPaint,
    );

    // Esquina inferior derecha
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.bottom),
      Offset(rect.right, rect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom - 20),
      Offset(rect.right, rect.bottom),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
