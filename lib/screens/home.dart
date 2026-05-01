// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/weather_card.dart';
import '../widgets/scan_button.dart';
import '../widgets/recent_scans.dart';
import '../services/auth_service.dart';
import '../services/classification_service.dart';
import 'history.dart';
import 'profile.dart';
import 'camera_screen.dart';
import 'result_screen.dart';
import '../services/database_service.dart';
import '../models/scan_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  String? _userPhotoUrl;
  String _userName = "Agricultor";
  bool _isAnalyzing = false; // ← AGREGAR
  bool _hasSynced = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeModel();
    _syncPendingIfOnline();
  }

  Future<void> _syncPendingIfOnline() async {
    if (_hasSynced) return; // ← evita repetir

    try {
      final result = await Connectivity().checkConnectivity();
      final hasInternet = result.any((r) => r != ConnectivityResult.none);
      if (hasInternet) {
        debugPrint('🔄 Verificando escaneos pendientes...');
        await DatabaseService().syncPendingScans();
        _hasSynced = true; // ← marca como sincronizado
      }
    } catch (e) {
      debugPrint('❌ Error verificando conectividad: $e');
    }
  }

  // ← AGREGAR ESTE MÉTODO
  Future<void> _initializeModel() async {
    try {
      await ClassificationService().initialize();
      print('✅ Modelo inicializado en Home');
    } catch (e) {
      print('❌ Error inicializando modelo: $e');
    }
  }

  Future<void> _loadUserData() async {
    var user = _authService.currentUser;

    user ??= await _authService.getCurrentUser();

    if (user != null && mounted) {
      setState(() {
        _userPhotoUrl = user!.photoUrl;
        _userName = user.displayName?.split(' ')[0] ?? "Agricultor";
      });
    } else {
      setState(() {
        _userName = "Agricultor";
        _userPhotoUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ← CAMBIAR de Scaffold a Stack
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFfafaf5),
          appBar: AppBar(
            backgroundColor: const Color(0xFFfafaf5),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DITECTA",
                    style: TextStyle(
                      color: Color(0xFF8fbc26),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "Hola, $_userName",
                    style: TextStyle(
                      color: Color(0xFF323846),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Profile()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFE8F5E9),
                    backgroundImage:
                        _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                        ? NetworkImage(_userPhotoUrl!)
                        : null,
                    child: _userPhotoUrl == null || _userPhotoUrl!.isEmpty
                        ? Icon(Icons.person, color: Color(0xFF8fbc26), size: 20)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const WeatherCard(),
                    const SizedBox(height: 24),
                    ScanButton(onPressed: _optionsDialogBox),
                    const SizedBox(height: 8),
                    const SizedBox(height: 32),
                    StreamBuilder<List<ScanModel>>(
                      stream: DatabaseService().watchAllScans(),
                      builder: (context, snapshot) {
                        // Toma solo los 3 más recientes del stream
                        final recentScans = (snapshot.data ?? [])
                            .take(3)
                            .toList();

                        return RecentScans(
                          scans: recentScans,
                          onViewAll: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const History(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF8fbc26),
            unselectedItemColor: Colors.grey,
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const History()),
                );
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "Historial",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Cuenta",
              ),
            ],
          ),
        ),

        // ← AGREGAR OVERLAY DE LOADING
        if (_isAnalyzing)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
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
          ),
      ],
    );
  }

  // ← MODIFICAR _openCamera
  Future<void> _openCamera() async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );

    if (imagePath != null && mounted) {
      await _analyzeImage(imagePath); // ← CAMBIAR
    }
  }

  // ← MODIFICAR _openGallery
  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null && mounted) {
      await _analyzeImage(image.path); // ← CAMBIAR
    }
  }

  // ← AGREGAR ESTE MÉTODO NUEVO
  Future<void> _analyzeImage(String imagePath) async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Clasificar imagen
      final classifier = ClassificationService();
      final result = await classifier.classifyImage(imagePath);

      // Navegar a pantalla de resultados
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(imagePath: imagePath, result: result),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al analizar imagen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFAFAF5),
          title: const Text(
            "Seleccione una opción",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF323846),
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.pop(context);
                  _openCamera();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Color(0xFF8fbc26)),
                      SizedBox(width: 8),
                      Text(
                        "Tomar foto",
                        style: TextStyle(
                          color: Color(0xFF323846),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, color: Color(0xFF8fbc26)),
                      SizedBox(width: 8),
                      Text(
                        "Elegir desde la galería",
                        style: TextStyle(
                          color: Color(0xFF323846),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
