import 'package:flutter/material.dart';
import 'home.dart';
import 'history.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
        title: const Text(
          "Mi Perfil",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // FOTO DE PERFIL
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF416C18), width: 4),
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.green[100],
                  child: Icon(Icons.person, size: 60, color: Color(0xFF8FBC26)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // NOMBRE
            const Text(
              "Walther White",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF323846),
              ),
            ),

            const SizedBox(height: 4),

            // CORREO (NUEVO)
            Text(
              "Heisenberg@gmail.com",
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),

            const SizedBox(height: 32),

            // SECCIÓN AJUSTES
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AJUSTES",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // CENTRO DE AYUDA
                  _SettingOption(
                    icon: Icons.help_outline,
                    iconColor: Colors.grey[600]!,
                    title: "Centro de Ayuda",
                    onTap: () {
                      // Navegar a centro de ayuda
                    },
                  ),

                  const Divider(height: 1),

                  // ACERCA DE LA APP
                  _SettingOption(
                    icon: Icons.info_outline,
                    iconColor: Colors.grey[600]!,
                    title: "Acerca de la App",
                    onTap: () {
                      // Navegar a acerca de la app
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // BOTÓN CERRAR SESIÓN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      "Cerrar Sesión",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // VERSIÓN
            Text(
              "DITECTA v1.0.0",
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // BARRA DE NAVEGACIÓN INFERIOR
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF416C18),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const History()),
            );
          }
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

  // Diálogo de confirmación para cerrar sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Cerrar Sesión",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("¿Estás seguro que deseas cerrar sesión?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Aquí implementarías la lógica de cerrar sesión
              },
              child: const Text(
                "Cerrar Sesión",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// WIDGET DE OPCIÓN DE AJUSTE
class _SettingOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _SettingOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF323846),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
