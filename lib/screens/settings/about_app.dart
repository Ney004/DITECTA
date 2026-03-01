import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF5),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Acerca de la App",
          style: TextStyle(
            color: Color(0XFF323846),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // LOGO
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xfffafaf5),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  "assets/icons/icon_logo.png",
                  width: 80,
                  height: 80,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "DITECTA",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF416c26),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Versión 1.0.0",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 32),

            // DESCRIPCIÓN
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sobre DITECTA",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8fbc18),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "DITECTA es una aplicación móvil diseña para la detección de Sigatoka en matas de banano y platano, basada en inteligencia artificial para analizar imágenes y proporcionar diagnóstico.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Características:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8fbc18),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Análisis de imágenes para detección temprana de Sigatoka.\n\n"
                    "Resultados basados en inteligencia artificial.\n\n"
                    "Interfaz diseñada para un uso facil y rápido en el campo.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // CONTACTO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contacto",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8fbc18),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ContactItem(
                    icon: Icons.email_outlined,
                    text: "ditectaSoporte@gmail.com",
                  ),
                  _ContactItem(
                    icon: Icons.phone_android_outlined,
                    text: "+57 311 663 0355",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "DITECTA. Todos los derechos reservados.",
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF8fbc18)),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
