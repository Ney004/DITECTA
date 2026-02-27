import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home.dart';
import 'history.dart';
import 'login.dart';
import '../screens/settings/about_app.dart';
import '../screens/settings/terms_conditions.dart';
import '../screens/settings/privacy_policy.dart';
import '../screens/settings/report_problem.dart';
import '../screens/settings/notification_settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _authService = AuthService();

  String _userName = "Cargando...";
  String _userEmail = "Cargando...";
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var user = _authService.currentUser;

    user ??= await _authService.getCurrentUser();

    if (user != null && mounted) {
      setState(() {
        _userName = user!.displayName ?? "Usuario";
        _userEmail = user.email;
        _userPhotoUrl = user.photoUrl;
      });
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAF5),
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
            color: Color(0xFF323846),
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
                border: Border.all(color: Color(0xFF8fbc18), width: 4),
              ),
              child: ClipOval(
                child: _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                    ? Image.network(
                        _userPhotoUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.green[100],
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.green[700],
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.green[100],
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.green[700],
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.green[100],
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.green[700],
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // NOMBRE
            Text(
              _userName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF323846),
              ),
            ),

            const SizedBox(height: 4),

            // CORREO
            Text(
              _userEmail,
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

                  // NOTIFICACIONES
                  _SettingOption(
                    icon: Icons.notifications_outlined,
                    iconColor: const Color(0xFF8fbc18),
                    title: "Notificaciones",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationSettings(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // SECCIÓN INFORMACIÓN Y SOPORTE
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "INFORMACIÓN Y SOPORTE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ACERCA DE LA APP
                  _SettingOption(
                    icon: Icons.info_outline,
                    iconColor: Color(0XFF8fbc18),
                    title: "Acerca de la App",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutApp(),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  // TÉRMINOS Y CONDICIONES
                  _SettingOption(
                    icon: Icons.description_outlined,
                    iconColor: Color(0XFF8fbc18),
                    title: "Términos y Condiciones",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsConditions(),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  // POLÍTICA DE PRIVACIDAD
                  _SettingOption(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Color(0xFF8fbc18),
                    title: "Política de Privacidad",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy(),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  // REPORTAR UN PROBLEMA
                  _SettingOption(
                    icon: Icons.bug_report_outlined,
                    iconColor: Color(0xFF8fbc18),
                    title: "Reportar un Problema",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportProblem(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // BORRAR HISTORIAL
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DATOS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _SettingOption(
                    icon: Icons.delete_outline,
                    iconColor: Colors.red,
                    title: "Borrar Historial",
                    onTap: () {
                      _showDeleteHistoryDialog(context);
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
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
        backgroundColor: Color(0xFFFAFAF5),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0XFF8fbc18),
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

  // Diálogo de confirmación para borrar historial
  void _showDeleteHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0XFF8fbc18),
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                "Borrar Historial",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "¿Estás seguro que deseas borrar todo tu historial de escaneos? Esta acción no se puede deshacer.",
          ),
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
                // Aquí implementarías la lógica para borrar historial
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Historial borrado correctamente"),
                    backgroundColor: Color(0xFF8fbc18),
                  ),
                );
              },
              child: const Text(
                "Borrar",
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
              onPressed: () async {
                await _authService.signOut();

                if (!context.mounted) return;

                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
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
                color: iconColor.withValues(alpha: 0.1),
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
