import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool _isSending = false;

  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    try {
      await _supabase.from('reports').insert({
        'user_id': _supabase.auth.currentUser?.id, // null si no hay sesión
        'category': _selectedCategory,
        'subject': _subjectController.text.trim(),
        'description': _descriptionController.text.trim(),
      });

      if (mounted) {
        setState(() => _isSending = false);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar reporte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF8fbc18)),
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
              Navigator.pop(context); // cerrar diálogo
              Navigator.pop(context); // volver a perfil
            },
            child: const Text(
              "Aceptar",
              style: TextStyle(
                color: Color(0xFF8fbc18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
              // Banner info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8fbc18).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8fbc18).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF8fbc18)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Ayúdanos a mejorar reportando errores o sugerencias",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8fbc18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Categoría
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
                    child: Text('Bug / Error'),
                  ),
                  DropdownMenuItem(
                    value: 'Sugerencia',
                    child: Text('Sugerencia'),
                  ),
                  DropdownMenuItem(
                    value: 'Problema de Login',
                    child: Text('Problema de Login'),
                  ),
                  DropdownMenuItem(
                    value: 'Detección Incorrecta',
                    child: Text('Detección Incorrecta'),
                  ),
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                ],
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),

              const SizedBox(height: 24),

              // Asunto
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF8fbc18),
                      width: 2,
                    ),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Por favor ingresa un asunto'
                    : null,
              ),

              const SizedBox(height: 24),

              // Descripción
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF8fbc18),
                      width: 2,
                    ),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Por favor describe el problema'
                    : null,
              ),

              const SizedBox(height: 32),

              // Botón enviar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSending ? null : _submitReport,
                  icon: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white),
                  label: Text(
                    _isSending ? 'Enviando...' : 'Enviar Reporte',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8fbc18),
                    disabledBackgroundColor: const Color(
                      0xFF8fbc18,
                    ).withValues(alpha: 0.6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
