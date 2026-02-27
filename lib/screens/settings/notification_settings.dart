import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _treatmentReminders = true;
  bool _weatherAlerts = true;

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
          "Notificaciones",
          style: TextStyle(
            color: Color(0xFF323846),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // RECORDATORIOS DE TRATAMIENTO
          Container(
            color: Colors.white,
            child: SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8fbc18).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  color: Color(0xFF8fbc18),
                ),
              ),
              title: const Text(
                "Recordatorios de Tratamiento",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Aplicación de fungicidas y cuidados",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              value: _treatmentReminders,
              onChanged: (value) {
                setState(() {
                  _treatmentReminders = value;
                });
              },
              activeThumbColor: const Color(0xFF8fbc18),
            ),
          ),

          const SizedBox(height: 12),

          // ALERTAS CLIMÁTICAS
          Container(
            color: Colors.white,
            child: SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8fbc18).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.wb_cloudy_outlined,
                  color: Color(0xFF8fbc18),
                ),
              ),
              title: const Text(
                "Alertas Climáticas",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Condiciones que afectan tus cultivos",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              value: _weatherAlerts,
              onChanged: (value) {
                setState(() {
                  _weatherAlerts = value;
                });
              },
              activeThumbColor: const Color(0xFF8fbc18),
            ),
          ),

          const SizedBox(height: 24),

          // NOTA INFORMATIVA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF8fbc18).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFF8fbc18).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF8fbc18)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Las notificaciones te ayudarán a mantener tus cultivos saludables",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF323846).withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
