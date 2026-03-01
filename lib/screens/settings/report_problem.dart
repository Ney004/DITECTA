import 'package:flutter/material.dart';

class ReportProblem extends StatefulWidget {
  const ReportProblem({super.key});

  @override
  State<ReportProblem> createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Bug / Error';

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // Aquí implementarías el envío del reporte (email, API, etc.)

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              SizedBox(width: 12),
              Text(
                "Reporte Enviado",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323846),
                ),
              ),
            ],
          ),
          content: const Text(
            "Gracias por tu reporte. Nuestro equipo lo revisará pronto.",
            style: TextStyle(fontSize: 14, color: Color(0xFF323846)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver a perfil
              },
              child: const Text(
                "Aceptar",
                style: TextStyle(color: Color(0xFF323846)),
              ),
            ),
          ],
        ),
      );
    }
  }

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
          "Reportar un Problema",
          style: TextStyle(
            color: Color(0xFF323846),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // INFORMACIÓN
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
                    Icon(Icons.info_outline, color: const Color(0xFF8fbc18)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Ayúdanos a mejorar reportando errores o sugerencias",
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF8fbc18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CATEGORÍA
              const Text(
                "Categoría",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323846),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Bug / Error',
                    child: Text(
                      'Bug / Error',
                      style: TextStyle(color: Color(0xFF323846)),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Sugerencia',
                    child: Text(
                      'Sugerencia',
                      style: TextStyle(color: Color(0xFF323846)),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Problema de Login',
                    child: Text(
                      'Problema de Login',
                      style: TextStyle(color: Color(0xFF323846)),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Detección Incorrecta',
                    child: Text(
                      'Detección Incorrecta',
                      style: TextStyle(color: Color(0xFF323846)),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Otro',
                    child: Text(
                      'Otro',
                      style: TextStyle(color: Color(0xFF323846)),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 24),

              // ASUNTO
              const Text(
                "Asunto",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323846),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: "Breve descripción del problema",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un asunto';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // DESCRIPCIÓN
              const Text(
                "Descripción",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323846),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText:
                      "Describe el problema con el mayor detalle posible...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor describe el problema';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // BOTÓN ENVIAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8fbc18),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Enviar Reporte",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFaFaF5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
