import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Política de Privacidad",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Política de Privacidad",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Última actualización: Febrero 2025",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              _Section(
                title: "1. Información que Recopilamos",
                content:
                    "• Información de cuenta (nombre, email)\n• Imágenes de cultivos para análisis\n• Ubicación GPS para servicios climáticos\n• Historial de escaneos y resultados\n• Datos de uso de la aplicación",
              ),

              _Section(
                title: "2. Cómo Usamos su Información",
                content:
                    "Utilizamos la información recopilada para:\n• Proporcionar análisis de enfermedades\n• Mejorar nuestros algoritmos de detección\n• Enviar alertas climáticas relevantes\n• Personalizar su experiencia\n• Cumplir con obligaciones legales",
              ),

              _Section(
                title: "3. Compartir Información",
                content:
                    "No vendemos ni compartimos su información personal con terceros, excepto:\n• Cuando sea requerido por ley\n• Para proteger nuestros derechos\n• Con su consentimiento explícito",
              ),

              _Section(
                title: "4. Seguridad de Datos",
                content:
                    "Implementamos medidas de seguridad técnicas y organizativas para proteger su información contra acceso no autorizado, pérdida o alteración.",
              ),

              _Section(
                title: "5. Sus Derechos",
                content:
                    "Usted tiene derecho a:\n• Acceder a su información personal\n• Corregir datos inexactos\n• Solicitar la eliminación de sus datos\n• Revocar consentimientos\n• Exportar sus datos",
              ),

              _Section(
                title: "6. Cookies y Tecnologías Similares",
                content:
                    "Utilizamos cookies y tecnologías similares para mejorar la funcionalidad de la app y analizar su uso.",
              ),

              _Section(
                title: "7. Retención de Datos",
                content:
                    "Conservamos su información mientras su cuenta esté activa o según sea necesario para proporcionar servicios. Puede solicitar la eliminación en cualquier momento.",
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contacto",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Para preguntas sobre privacidad:\nprivacy@ditecta.com",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
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
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF323846),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
