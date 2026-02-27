import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home.dart';
import 'history.dart';
import 'login.dart';

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
    debugPrint('Intentando cargar datos del usuario...');

    var user = _authService.currentUser;
    debugPrint('currentUser: $user');

    if (user == null) {
      debugPrint('currentUser es null, intentando getCurrentUser()');
      user = await _authService.getCurrentUser();
      debugPrint('getCurrentUser result: $user');
    }

    if (user != null && mounted) {
      debugPrint('Usuario encontrado: ${user.email}');
      setState(() {
        _userName = user!.displayName ?? "Usuario";
        _userEmail = user.email;
        _userPhotoUrl = user.photoUrl;
      });
    } else {
      debugPrint('No hay usuario autenticado, volviendo al login');
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
                border: Border.all(color: Color(0xFF8fbc26), width: 5),
              ),
              child: ClipOval(
                child: _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                    ? Image.network(
                        _userPhotoUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Color(0xFFE8F5E9),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF416C18),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Color(0xFFE8F5E9),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Color(0xFF416C18),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Color(0xFFE8F5E9),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF416C18),
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
              style: TextStyle(fontSize: 15, color: Color(0xFF757575)),
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
                      color: Color(0xFF757575),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // CENTRO DE AYUDA
                  _SettingOption(
                    icon: Icons.help_outline,
                    iconColor: Color(0xFF8fbc26),
                    title: "Centro de Ayuda",
                    onTap: () {
                      // Navegar a centro de ayuda
                    },
                  ),

                  const Divider(height: 1),

                  // ACERCA DE LA APP
                  _SettingOption(
                    icon: Icons.info_outline,
                    iconColor: Color(0xFF8fbc26),
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
              style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // BARRA DE NAVEGACIÓN INFERIOR
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF8fbc26),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF8fbc26),
              fontSize: 20,
              height: 1.2,
            ),
          ),
          content: const Text(
            "¿Estás seguro que deseas cerrar sesión?",
            style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
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
              onPressed: () async {
                // Cerrar sesión
                await _authService.signOut();

                if (!context.mounted) return;

                Navigator.pop(context); // Cerrar diálogo
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
