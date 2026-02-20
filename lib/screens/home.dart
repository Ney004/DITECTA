import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/weather_card.dart';
import '../widgets/scan_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      ),

      body: Stack(
        children: [
          /// 🔹 Parte superior (Weather)
          Column(children: const [WeatherCard()]),

          /// 🔹 Botón centrado
          ScanButton(onPressed: _optionsDialogBox),
        ],
      ),
    );
  }

  // -------------------------
  // LÓGICA
  // -------------------------

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
          backgroundColor: const Color(0xFFFAFAF5), // fondo verde muy suave
          title: const Text(
            "Seleccione una opción",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF416c18), // verde oscuro
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // BOTÓN TOMAR FOTO
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
                    color: const Color(0xFFEDEDED), // gris claro
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Text(
                        "Tomar foto",
                        style: TextStyle(
                          color: Color(0xFF416C18), // verde oscuro
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // BOTÓN GALERÍA
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
                    color: Color(0xFFEDEDED), // gris claro
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Text(
                        "Elegir desde la galería",
                        style: TextStyle(
                          color: Color(0xFF416C18), // verde oscuro
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
