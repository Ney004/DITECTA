import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database_service.dart';
import 'supabase_service.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });
}

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _supabase = Supabase.instance.client;

  // ── Sign in con Google + Supabase ───────────────────────────────
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('❌ googleUser es null - usuario canceló');
        return null;
      }

      debugPrint('✅ Google user: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      debugPrint('🔑 idToken: ${googleAuth.idToken != null ? "OK" : "NULL"}');
      debugPrint(
        '🔑 accessToken: ${googleAuth.accessToken != null ? "OK" : "NULL"}',
      );

      if (googleAuth.idToken == null) {
        debugPrint('❌ idToken es null');
        return null;
      }

      debugPrint('🔄 Autenticando en Supabase...');

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      debugPrint('✅ Supabase user: ${response.user?.email}');

      if (response.user == null) {
        debugPrint('❌ Supabase user es null');
        return null;
      }

      // ── Guardar perfil en Supabase ──────────────────────────────
      debugPrint('🔄 Guardando perfil...');
      await SupabaseService().saveUserProfile(
        displayName: googleUser.displayName ?? '',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
      );

      // ── Migrar datos locales a Supabase (solo primera vez) ──────
      debugPrint('🔄 Migrando datos locales...');
      await DatabaseService().migrateLocalToSupabase();

      debugPrint('✅ Login completo: ${googleUser.email}');

      return UserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
        displayName: googleUser.displayName,
        photoUrl: googleUser.photoUrl,
      );
    } catch (error, stackTrace) {
      debugPrint('❌ Error completo: $error');
      debugPrint('❌ StackTrace: $stackTrace');
      return null;
    }
  }

  // ── Obtener usuario actual ──────────────────────────────────────
  UserModel? get currentUser {
    final supabaseUser = _supabase.auth.currentUser;
    final googleUser = _googleSignIn.currentUser;
    if (supabaseUser == null) return null;

    return UserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      displayName:
          googleUser?.displayName ?? supabaseUser.userMetadata?['full_name'],
      photoUrl:
          googleUser?.photoUrl ?? supabaseUser.userMetadata?['avatar_url'],
    );
  }

  // ── Verificar sesión silenciosa ─────────────────────────────────
  Future<UserModel?> getCurrentUser() async {
    final session = _supabase.auth.currentSession;

    if (session != null) {
      debugPrint('✅ Sesión Supabase activa: ${session.user.email}');
      await _googleSignIn.signInSilently();
      return currentUser;
    }

    // Intentar restaurar Google silenciosamente
    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser == null) {
      debugPrint('ℹ️ No hay sesión activa');
      return null;
    }

    // Re-autenticar en Supabase
    try {
      debugPrint('🔄 Re-autenticando en Supabase...');
      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null) {
        final response = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
        );

        if (response.user != null) {
          debugPrint('✅ Re-autenticado: ${response.user!.email}');
          return currentUser;
        }
      }
    } catch (e) {
      debugPrint('❌ Error re-autenticando: $e');
    }

    return null;
  }

  // ── Cerrar sesión ───────────────────────────────────────────────
  Future<void> signOut() async {
    debugPrint('🔄 Cerrando sesión...');
    await DatabaseService().cacheSupabaseDataLocally();
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
    debugPrint('✅ Sesión cerrada');
  }
}
