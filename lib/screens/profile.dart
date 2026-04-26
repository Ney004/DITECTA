import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'home.dart';
import 'history.dart';
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

  bool _isLoggedIn = false;
  bool _isLoading = true;
  String _userName = "Agricultor";
  String _userEmail = "No has iniciado sesión";
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    var user = _authService.currentUser;
    user ??= await _authService.getCurrentUser();

    if (mounted) {
      setState(() {
        if (user != null) {
          _isLoggedIn = true;
          _userName = user.displayName ?? "Agricultor";
          _userEmail = user.email;
          _userPhotoUrl = user.photoUrl;
        } else {
          _isLoggedIn = false;
          _userName = "Agricultor";
          _userEmail = "No has iniciado sesión";
          _userPhotoUrl = null;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();

      if (!mounted) return;

      if (user != null) {
        setState(() {
          _isLoggedIn = true;
          _userName = user.displayName ?? "Agricultor";
          _userEmail = user.email;
          _userPhotoUrl = user.photoUrl;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión iniciada correctamente'),
            backgroundColor: Color(0xFF8fbc18),
          ),
        );
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión cancelado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF5),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Home()),
          ),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF8fbc18)),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // ── FOTO DE PERFIL ──────────────────────────────
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF8fbc18),
                        width: 4,
                      ),
                    ),
                    child: ClipOval(
                      child:
                          _isLoggedIn &&
                              _userPhotoUrl != null &&
                              _userPhotoUrl!.isNotEmpty
                          ? Image.network(
                              _userPhotoUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: Colors.green[100],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green[700],
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, _, _) => Container(
                                color: Colors.green[100],
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.green[700],
                                ),
                              ),
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

                  // ── NOMBRE ──────────────────────────────────────
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF323846),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ── EMAIL ───────────────────────────────────────
                  Text(
                    _userEmail,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 8),

                  // ── BADGE NUBE (solo si está logueado) ──────────
                  if (_isLoggedIn)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8fbc18).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF8fbc18).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cloud_done_outlined,
                            size: 14,
                            color: const Color(0xFF8fbc18),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Datos sincronizados en la nube',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8fbc18),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // ── BOTÓN INICIAR SESIÓN (sin sesión) ───────────
                  if (!_isLoggedIn)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Info sobre ventajas de iniciar sesión
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF8fbc18,
                              ).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFF8fbc18,
                                ).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Color(0xFF8fbc18),
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Guarda tus escaneos en la nube',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF323846),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Inicia sesión para sincronizar tu historial y acceder desde cualquier dispositivo.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botón Google
                          ElevatedButton(
                            onPressed: _handleGoogleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/Google.png',
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'G',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Iniciar sesión con Google",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),

                  // ── AJUSTES ─────────────────────────────────────
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
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
                        _SettingOption(
                          icon: Icons.notifications_outlined,
                          iconColor: const Color(0xFF8fbc18),
                          title: "Notificaciones",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationSettings(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── INFORMACIÓN Y SOPORTE ────────────────────────
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
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
                        _SettingOption(
                          icon: Icons.info_outline,
                          iconColor: const Color(0xFF8fbc18),
                          title: "Acerca de la App",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AboutApp()),
                          ),
                        ),
                        const Divider(height: 1),
                        _SettingOption(
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF8fbc18),
                          title: "Términos y Condiciones",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsConditions(),
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        _SettingOption(
                          icon: Icons.privacy_tip_outlined,
                          iconColor: const Color(0xFF8fbc18),
                          title: "Política de Privacidad",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicy(),
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        _SettingOption(
                          icon: Icons.bug_report_outlined,
                          iconColor: const Color(0xFF8fbc18),
                          title: "Reportar un Problema",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReportProblem(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── DATOS ────────────────────────────────────────
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
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
                          onTap: () => _showDeleteHistoryDialog(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── CERRAR SESIÓN (con sesión) ───────────────────
                  if (_isLoggedIn)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: OutlinedButton(
                        onPressed: () => _showLogoutDialog(context),
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

                  Text(
                    "DITECTA v1.0.0",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),

      // ── BOTTOM NAV ──────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFAFAF5),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF8fbc26),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const History()),
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

  // ── Diálogo borrar historial ─────────────────────────────────────
  void _showDeleteHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text(
              "Borrar Historial",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF323846),
              ),
            ),
          ],
        ),
        content: const Text(
          "¿Estás seguro que deseas borrar todo tu historial de escaneos?\nEsta acción no se puede deshacer.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar", style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              await DatabaseService().clearAllScans();

              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text("Historial borrado correctamente"),
                  backgroundColor: Color(0xFF8fbc18),
                ),
              );
            },
            child: const Text(
              "Borrar",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Diálogo cerrar sesión ────────────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Cerrar Sesión",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF323846),
          ),
        ),
        content: const Text("¿Estás seguro que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar", style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              await _authService.signOut();

              navigator.pop();

              if (mounted) {
                setState(() {
                  _isLoggedIn = false;
                  _userName = "Agricultor";
                  _userEmail = "No has iniciado sesión";
                  _userPhotoUrl = null;
                });
              }

              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada correctamente'),
                  backgroundColor: Color(0xFF8fbc18),
                ),
              );
            },
            child: const Text(
              "Cerrar Sesión",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ── SETTING OPTION WIDGET ────────────────────────────────────────────────────
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
