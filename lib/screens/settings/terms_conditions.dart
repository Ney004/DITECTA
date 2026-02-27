import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

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
          "Términos y Condiciones",
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
                "Términos y Condiciones de Uso",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Última actualización: Febrero 2025",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              _Section(
                title: "1. Aceptación de Términos",
                content:
                    "Al descargar, instalar o usar DITECTA, usted acepta estar sujeto a estos Términos y Condiciones. Si no está de acuerdo con alguna parte de estos términos, no debe usar la aplicación.",
              ),

              _Section(
                title: "2. Uso de la Aplicación",
                content:
                    "DITECTA está diseñada para ayudar en la detección de enfermedades en cultivos de banano. Los resultados proporcionados son orientativos y no sustituyen el diagnóstico profesional de un agrónomo certificado.",
              ),

              _Section(
                title: "3. Responsabilidad",
                content:
                    "DITECTA no se hace responsable de las decisiones tomadas basadas únicamente en los resultados de la aplicación. Se recomienda siempre consultar con expertos agrícolas para decisiones críticas.",
              ),

              _Section(
                title: "4. Propiedad Intelectual",
                content:
                    "Todo el contenido, diseño y funcionalidad de DITECTA son propiedad exclusiva de sus creadores y están protegidos por leyes de propiedad intelectual.",
              ),

              _Section(
                title: "5. Privacidad",
                content:
                    "El uso de sus datos personales se rige por nuestra Política de Privacidad. Al usar DITECTA, acepta la recopilación y uso de información de acuerdo con dicha política.",
              ),

              _Section(
                title: "6. Modificaciones",
                content:
                    "Nos reservamos el derecho de modificar estos términos en cualquier momento. Los cambios serán efectivos al publicarse en la aplicación.",
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8fbc18).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8fbc18).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF8fbc18)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Para más información, contacte a support@ditecta.com",
                        style: TextStyle(fontSize: 13, color: Colors.grey[800]),
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
