import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF5), // Fondo hueso/claro
        elevation: 0, // Generalmente estos diseños limpios no llevan sombra
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "DITECTA",
                style: TextStyle(
                  color: Colors.green.shade400, // Color verde suave
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2, // Espaciado entre letras característico
                ),
              ),
              const Text(
                "Hola, Granjero",
                style: TextStyle(
                  color: Color(
                    0xFF323846,
                  ), // Un azul oscuro/grisáceo casi negro
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _optionsDialogBox,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.white, // contorno blanco
                width: 6,
              ),
            ),
            padding: EdgeInsets.all(40),
            backgroundColor: Colors.green,
            shadowColor: Colors.greenAccent,
            elevation: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt, color: Colors.white, size: 50),
              SizedBox(height: 10),
              Text(
                "EMPEZAR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Selecciona una opción",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF7CAA2D), // Verde DITECTA
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
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF7CAA2D),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Tomar una foto",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12),

              // BOTÓN SELECCIONAR DE GALERÍA
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Elegir desde la galería",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
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
