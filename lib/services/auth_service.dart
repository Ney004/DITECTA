import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database_service.dart';

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

      debugPrint('✅ idToken: ${googleAuth.idToken}');
      debugPrint('✅ accessToken: ${googleAuth.accessToken}');

      if (googleAuth.idToken == null) {
        debugPrint('❌ idToken es null');
        return null;
      }

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

      await DatabaseService().migrateLocalToSupabase();

      return UserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
        displayName: googleUser.displayName,
        photoUrl: googleUser.photoUrl,
      );
    } catch (error) {
      debugPrint('❌ Error completo: $error');
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
    // Intentar restaurar sesión de Supabase
    final supabaseUser = _supabase.auth.currentUser;
    if (supabaseUser != null) {
      // Intentar restaurar Google silenciosamente
      await _googleSignIn.signInSilently();
      return currentUser;
    }
    return null;
  }

  Future<void> signOut() async {
    // Guardar copia local ANTES de cerrar sesión
    await DatabaseService().cacheSupabaseDataLocally();

    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }
}
