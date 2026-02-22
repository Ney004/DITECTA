import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/weather_card.dart';
import '../widgets/scan_button.dart';
import '../widgets/recent_scans.dart';
import 'history.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ScanItem> mockScans = [
    ScanItem(
      title: "North Plot #12",
      timeAgo: "2H AGO",
      status: "Healthy",
      statusColor: Colors.green,
      imagePath: "", // dejarlo vacío por ahora, mostrará icono
    ),
    ScanItem(
      title: "West Boundary",
      timeAgo: "YESTERDAY",
      status: "Mild",
      statusColor: Colors.orange,
      imagePath: "",
    ),
    ScanItem(
      title: "Seedling Section",
      timeAgo: "OCT 12",
      status: "Severe",
      statusColor: Colors.red,
      imagePath: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF5),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DITECTA",
                style: TextStyle(
                  color: Colors.green.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Text(
                "Hola, Granjero",
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
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.green[100],
              child: Icon(Icons.person, color: Colors.green[700], size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Weather Card
              const WeatherCard(),

              const SizedBox(height: 24),

              // Botón centrado
              ScanButton(onPressed: _optionsDialogBox),

              const SizedBox(height: 8),

              const SizedBox(height: 32),

              // Recent Scans
              RecentScans(scans: mockScans),

              const SizedBox(height: 80), // espacio para la barra inferior
            ],
          ),
        ),
      ),

      // Barra de navegación inferior (opcional)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF416C18),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          // Aquí puedes manejar la navegación entre pantallas
          if (index == 0) {
            // Home
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          } else if (index == 1) {
            // Navegar a Historial
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const History()),
            );
          } /*else if (index == 2) {
            // Navegar a Cuenta
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            );
          }*/
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historial",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cuenta"),
        ],
      ),
    );
  }

  void _openCamera() {
    ImagePicker().pickImage(source: ImageSource.camera);
  }

  void _openGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery);
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF416c18),
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
                      SizedBox(width: 8),
                      Text(
                        "Tomar foto",
                        style: TextStyle(
                          color: Color(0xFF416C18),
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
                      SizedBox(width: 8),
                      Text(
                        "Elegir desde la galería",
                        style: TextStyle(
                          color: Color(0xFF416C18),
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
